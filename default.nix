let
 pkgs = import (fetchTarball "https://github.com/rstats-on-nix/nixpkgs/archive/0074aa452298eaab34e265290a14cdcedd2e3897.tar.gz") {};
  rix = [(pkgs.rPackages.buildRPackage {
            name = "rix";
            src = pkgs.fetchgit {
             url = "https://github.com/b-rodrigues/rix/";
             rev = "971d6cec26437c43162bfddfcf1a1bdc873287a0";
             sha256 = "sha256-ngmnNyet4Rj6F4+RL0Lyd49egsyUU66LaJLqeZK1k34=";
            };
            propagatedBuildInputs = builtins.attrValues {
              inherit (pkgs.rPackages) codetools httr jsonlite sys;
            };
         })
  ];
 system_packages = builtins.attrValues {
  inherit (pkgs) R glibcLocalesUtf8 quarto nix;
};
  in
  pkgs.mkShell {
    LOCALE_ARCHIVE = if pkgs.system == "x86_64-linux" then  "${pkgs.glibcLocalesUtf8}/lib/locale/locale-archive" else "";
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";

    buildInputs = [ system_packages rix pkgs.rPackages.quarto pkgs.rPackages.targets pkgs.rPackages.tarchetypes];

    shellHook = '' Rscript -e "targets::tar_make()" '';
  }

