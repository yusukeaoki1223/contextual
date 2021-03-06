library(readr)
library(DBI)
library(RSQLite)

# Import of the R6A - Yahoo! Front Page Today Module User Click Log Dataset

# The data_import_directory has to contain unpacked data files that were themselves unpacked from a tarball
# available by request at https://webscope.sandbox.yahoo.com/catalog.php?datatype=r&did=49

# ydata-fp-td-clicks-v1_0.20090501 and ydata-fp-td-clicks-v1_0.20090502 are messy,
# and should NOT be included in the _unpacked directory.

# The import generates parsing warnings, and the readr status bar behaves irregular. This can be ignored.

# Configuration ----------------------------------------------------------------------------------------------

data_import_directory  <- "D:/Cloudy/DropBox/Dropbox/yahoo/R6A/_unpacked/"
db_dir_file            <- "D:/YahooDb/yahoo.sqlite"

row_max                <- 5600000 # > nr of rows in any imported file
by_step                <- 800000  # read data and write sql in in batches

# Data types -------------------------------------------------------------------------------------------------

dtypes <-
  c(
    "numeric",
    "factor",
    "factor",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    "numeric",
    rep(
      c(
        "factor",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric",
        "numeric"
      ),
      25
    )
  )

# Function to generate header labels -------------------------------------------------------------------------

print_headers <- function() {
  feature_gen <- function(s) {
    sapply(c(2:6, 1), FUN = function(i) paste(s, i, sep = ""))
  }
  feat_vec <- vector()
  for (i in 1:25) {
    feat_vec <- c(feat_vec, paste("a", i, "_id", sep = ""))
    feat_vec <- c(feat_vec, feature_gen(paste("a", i, "_feat", sep = "")))
  }
  c(
    c("timestamped", "article_id", "click", "delete_me"),
    c(feature_gen("user_feat"), feat_vec)
  )
}

# Convert columns to types -----------------------------------------------------------------------------------

convert_to_types <- function(obj,types){
  out <- lapply(1:length(obj),
                FUN = function(i){FUN1 <- switch(types[i],character = as.character, numeric = as.numeric,
                                                 factor = as.factor); FUN1(obj[,i])})

  names(out) <- colnames(obj)
  as.data.frame(out,stringsAsFactors = FALSE)
}

# connect to db ----------------------------------------------------------------------------------------------

con <- dbConnect(RSQLite::SQLite(), db_dir_file)

# drop index ... add again when inserts completed ------------------------------------------------------------

tryCatch({dbSendQuery(con,"DROP INDEX index_t ON yahoo")}, error=function(w) print("No index yet."))

# loop over each file in steps (batches) of a million records ------------------------------------------------

files = list.files(path = data_import_directory)

for (f in 1:length(files)) {
  data_file_path <- paste0(data_import_directory,files[f])

  message (paste0("\n## Starting import of ",files[f],"\n"))

  for (i in seq(0, row_max, by = by_step)) {

    # read a million records
    dat <- read_delim(data_file_path, delim = " ", col_names = print_headers(),
                      skip = i, n_max = by_step, guess_max = 1)

    message (paste0("\n## Writing row ",format((i+1),scientific = F),
                    " to ",format(i+by_step,scientific = F),"\n"))

    # cleanup before saving batch
    dat$delete_me <- NULL
    dat <- lapply(dat, gsub, pattern = '\\|', replacement = '', perl = TRUE)
    dat <- lapply(dat, gsub, pattern = '[1-9]:', replacement = '', perl = TRUE)
    dat <- as.data.frame(dat, stringsAsFactors = FALSE)
    dat <- convert_to_types(dat,dtypes)

    # add an index for each time step t
    if ( dim(dat)[1] >= 1 ) dat$t = seq(i + 1, i + dim(dat)[1])

    # save batch (and if already data, append) to DB table "yahoo"
    dbWriteTable(con, "yahoo", dat, append = TRUE)
  }
  rm(dat)
  gc()
  Sys.sleep(1)
  message (paste0("\n## Completed import of ",files[f],"\n"))

}

# create index on completion table - remove when insert, add again afterward ---------------------------------

tryCatch({dbSendQuery(con,"CREATE INDEX index_t ON yahoo (t)")}, error=function(w) print("Index error."))

# disconnect from and then shutdown  -------------------------------------------------------------------------

dbDisconnect(con, shutdown = TRUE)



