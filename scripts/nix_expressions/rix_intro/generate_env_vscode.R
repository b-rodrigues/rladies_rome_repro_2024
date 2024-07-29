library(rix)

rix(r_ver = "4.3.1",
    r_pkgs = c("dplyr", "ggplot2"),
    system_pkgs = NULL,
    git_pkgs = NULL,
    tex_pkgs = NULL,
    # Pour utiliser VS code, mettez "code" à "ide"
    # cela va installer le paquet R {languageserver}
    # contrairement à Rstudio, vous pouvez utiliser VS code 
    # installé comme d'habitude, sans Nix
    # Si vous voulez aussi installer VS code via Nix, rajoutez "vscode"
    # ou "vscodium" à 'system_pkgs'
    ide = "code",
    project_path = ".",
    overwrite = FALSE)
