library(rix)

rix(r_ver = "4.3.1",
    r_pkgs = c("dplyr", "ggplot2"),
    system_pkgs = NULL,
    git_pkgs = NULL,
    tex_pkgs = NULL,
    # Attention, rstudio n'est pas disponible pour macOS
    # via Nix, ni pour arm64-linux, seulement Linux et Windows
    ide = "rstudio",
    # Ce shellhook est nécessaire pour démarrer Rstudio sur Linux
    shell_hook = "export QT_XCB_GL_INTEGRATION=none",
    project_path = ".",
    overwrite = TRUE)
