let
  pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/f56976ac4a4fbcb8f095d6f0df2d3c1a461e9032.tar.gz") {};
 
  rpkgs = builtins.attrValues {
    inherit (pkgs.rPackages) 
      renv
      targets
      tarchetypes
      dplyr
      janitor
      quarto;
  };
 
  git_archive_pkgs = [
    (pkgs.rPackages.buildRPackage {
      name = "housing";
      src = pkgs.fetchgit {
        url = "https://github.com/rap4all/housing/";
        rev = "1c860959310b80e67c41f7bbdc3e84cef00df18e";
        sha256 = "sha256-s4KGtfKQ7hL0sfDhGb4BpBpspfefBN6hf+XlslqyEn4=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          dplyr
          ggplot2
          janitor
          purrr
          readxl
          rlang
          rvest
          stringr
          tidyr;
      };
    })

    (pkgs.rPackages.buildRPackage {
      name = "rix";
      src = pkgs.fetchgit {
        url = "https://github.com/b-rodrigues/rix/";
        rev = "971d6cec26437c43162bfddfcf1a1bdc873287a0";
        sha256 = "sha256-ngmnNyet4Rj6F4+RL0Lyd49egsyUU66LaJLqeZK1k34=";
      };
      propagatedBuildInputs = builtins.attrValues {
        inherit (pkgs.rPackages) 
          codetools
          curl
          jsonlite
          sys;
      };
    })
  ];
 
  tex = (pkgs.texlive.combine {
    inherit (pkgs.texlive) 
      scheme-small
      amsmath;
  });
  
  system_packages = builtins.attrValues {
    inherit (pkgs) 
      R
      glibcLocales
      nix
      quarto;
  };
 
  wrapped_pkgs = pkgs.rstudioWrapper.override {
               packages = [ git_archive_pkgs rpkgs ];
  };
 
in

pkgs.mkShell {
  LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocales}/lib/locale/locale-archive" else "";
  LANG = "en_US.UTF-8";
   LC_ALL = "en_US.UTF-8";
   LC_TIME = "en_US.UTF-8";
   LC_MONETARY = "en_US.UTF-8";
   LC_PAPER = "en_US.UTF-8";
   LC_MEASUREMENT = "en_US.UTF-8";

  shellHook = "export QT_XCB_GL_INTEGRATION=none";

  buildInputs = [ git_archive_pkgs rpkgs tex system_packages  wrapped_pkgs ];
  
}