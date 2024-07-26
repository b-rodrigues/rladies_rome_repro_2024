library(targets)
library(tarchetypes)

list(
  tar_force(
    name = pres,
    command = quarto::quarto_render("presentation/pres.qmd"),
    format = "file", 
    force = TRUE
  )
)
