library(targets)
library(tarchetypes)

tar_option_set(packages = c(
                 "dplyr",
                 "ggplot2",
                 "janitor",
                 "purrr",
                 "readxl",
                 "rvest",
                 "stringr",
                 "tidyr"
                 )
               )

source("functions/get_raw_data.R")
source("functions/get_laspeyeres.R")

list(
  tar_target(
    raw_data,
    get_raw_data(url = "https://github.com/b-rodrigues/rap4all/raw/master/datasets/vente-maison-2010-2021.xlsx")
  ),
  tar_target(
    flat_data,
    clean_raw_data(raw_data)
  ),
  tar_target(
    # Communes are the lowest administrative division
    # in Luxembourg
    former_communes,
    get_former_communes()
  ),
  tar_target(
    current_communes,
    get_current_communes()
  ),
  tar_target(
    country_level_data,
    make_country_level_data(flat_data)
  ),
  tar_target(
    commune_level_data,
    make_commune_level_data(flat_data)
  ),
  tar_target(
    commune_data,
    get_laspeyeres(commune_level_data)
  ),

  tar_target(
    country_data,
    get_laspeyeres(country_level_data)
  ),

  tar_target(
    communes,
    c("Luxembourg",
      "Esch-sur-Alzette",
      "Mamer",
      "Schengen",
      "Wincrange")
  ),

  tar_render(
    analyse_data,
    "analyse_data.Rmd",
    output_dir = "/home/housing/pipeline_output"
  )

)
