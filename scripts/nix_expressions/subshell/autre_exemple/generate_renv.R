#voir https://b-rodrigues.github.io/rix/articles/z-advanced-topic-running-r-or-shell-code-in-nix-from-r.html#case-study-2-breaking-changes-in-stringr-1-5-0 

library("rix")

path_env_stringr <- file.path(".", "_env_stringr_1.4.1")

rix_init(
  project_path = path_env_stringr,
  rprofile_action = "overwrite",
  message_type = "simple"
)

rix(
  r_ver = "latest",
  r_pkgs = "stringr@1.4.1",
  overwrite = TRUE,
  project_path = path_env_stringr
)

out_nix_stringr <- with_nix(
  expr = function() stringr::str_subset(c("", "a"), ""),
  program = "R",
  exec_mode = "non-blocking",
  project_path = path_env_stringr,
  message_type = "simple"
)
