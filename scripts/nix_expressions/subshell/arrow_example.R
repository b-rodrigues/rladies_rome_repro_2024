# This script shows how to run some R code inside a Nix environment
# from a session that may or may not be managed by Nix. 
# We refer to such workflows as "running code in a subshell".
# The output from the "subshell" is sent back to the main session
# for further analysis or inspection.
library("rix")

# We define a path to hold the default.nix of the subshell
path_env_arrow <- file.path("env_arrow")

# We use rix_init() to create .Rprofile that will be loaded
# by that subshell. This is needed to avoid interference between
# the main session and the subshell regarding package libraries.
rix_init(
  project_path = path_env_arrow,
  rprofile_action = "overwrite",
  message_type = "simple"
)

# We now create the default.nix of the subshell.
rix(
  r_ver = "4.1.1",
  r_pkgs = c("dplyr", "arrow"),
  overwrite = TRUE,
  project_path = path_env_arrow
)

# The code we wish to execute needs to be wrapped
# instide a function. This code can be as complex as needed
# but shouldn’t ideally have no side-effects other than writing to 
# disk and return a single object (or `NULL` if only side-effects).
arrow_test <- function() {
  library(arrow)
  library(dplyr)
  
  arrow_cars <- arrow::Table$create(cars)
  # in more recent versions of {arrow}
  # one can use arrow_table() instead
  
  arrow_cars %>%
    filter(speed > 10) %>%
    as.data.frame()
}

# We can now run the function inside of the subshell
# using `with_nix()`
out_nix_arrow <- with_nix(
  expr = function() arrow_test(),
  program = "R",
  project_path = path_env_arrow,
  message_type = "simple"
)
