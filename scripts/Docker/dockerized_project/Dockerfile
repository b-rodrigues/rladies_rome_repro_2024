FROM rocker/r-ver:4.3.0

RUN apt-get update && apt-get install -y \
    libglpk-dev \
    libxml2-dev \
    libcairo2-dev \
    libgit2-dev \
    default-libmysqlclient-dev \
    libpq-dev \
    libsasl2-dev \
    libsqlite3-dev \
    libssh2-1-dev \
    libxtst6 \
    libcurl4-openssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libxt-dev \
    unixodbc-dev \
    wget \
    pandoc


RUN R -e "install.packages('renv')"

RUN mkdir /home/housing

RUN mkdir /home/housing/pipeline_output

RUN mkdir /home/housing/shared_folder

COPY renv.lock /home/housing/renv.lock

COPY functions /home/housing/functions

COPY analyse_data.Rmd /home/housing/analyse_data.Rmd

COPY _targets.R /home/housing/_targets.R

RUN R -e "setwd('/home/housing');renv::init();renv::restore()"

RUN cd /home/housing && R -e "targets::tar_make()"

CMD mv /home/housing/pipeline_output/* /home/housing/shared_folder/