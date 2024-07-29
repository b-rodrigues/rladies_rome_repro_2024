let
  # We define the nixpkgs repositories to use
  # This one here is the official nixpkgs repository from NixOS
  # which points to the tip of master, so this expression is not
  # reproducible as it keeps changing!
  # To make this reproducible, the expression needs to point
  # to a specific commit
  pkgs = import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/refs/heads/master.tar.gz") {};

  # System packages, such as programming languages
  system_packages = builtins.attrValues {
    inherit (pkgs) R python312;
  };

  # List of R packages to install from Github
  git_pkgs = [
    (pkgs.rPackages.buildRPackage {
        name = "rix";
        src = pkgs.fetchgit {
        url = "https://github.com/b-rodrigues/rix/";
        branchName = "master";
        rev = "2bcd605e5b3f00582ec5262abf5f0cbefe26f905";
        sha256 = "sha256-7GAx0oVSSMYLOSBttQC1JxsLxaCriPJYCr59DhAiU+E=";
       };
       propagatedBuildInputs = builtins.attrValues {
         inherit (pkgs.rPackages) codetools curl httr jsonlite sys;
       };
    })

    (pkgs.rPackages.buildRPackage {
        name = "fusen";
        src = pkgs.fetchgit {
        url = "https://github.com/ThinkR-open/fusen";
        branchName = "main";
        rev = "d617172447d2947efb20ad6a4463742b8a5d79dc";
        sha256 = "sha256-TOHA1ymLUSgZMYIA1a2yvuv0799svaDOl3zOhNRxcmw=";
       };
       propagatedBuildInputs = builtins.attrValues {
         inherit (pkgs.rPackages)
           attachment
           cli
           desc
           devtools
           glue
           here
           magrittr
           parsermd
           roxygen2
           stringi
           tibble
           tidyr
           usethis
           yaml;
       };
    })
  ];

  # List of R packages to install from nixpkgs
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      chronicler
      data_table
      reticulate;
  };

  # List of Python packaget to install from nixpkgs
  pypkgs = builtins.attrValues {
    inherit (pkgs.python312Packages) 
      polars
      plotnine;
  };

 # List of TeXLive packages to install from nixpkgs
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive)
      scheme-small
      amsmath
      booktabs
      setspace
      lineno
      cochineal
      tex-gyre
      framed
      multirow
      wrapfig
      fontawesome5
      tcolorbox
      orcidlink
      environ
      tikzfill
      pdfcol;
  });

in
  # pkgs.mkShell is a function that creates a shell
  pkgs.mkShell {

    # These are the inputs, defined above, of the shell
    buildInputs = [ system_packages rpkgs pypkgs git_pkgs tex ];

    # This will run each time we start the shell
    shellHook = "echo 'Welcome to your development environment!'";
  }
