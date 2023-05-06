ARG VARIANT="4.2.2"

FROM rocker/r-ver:${VARIANT}

RUN apt-get update && apt-get -y upgrade
RUN apt-get -y install wget \
                       curl \
                       gdebi-core \
                       git \
                       pandoc \
                       jq \
                       python3-pip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*
 
# install quarto
ENV QUARTO_VERSION="1.2.262"
RUN curl -o quarto-linux-amd64.deb -L "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb"
RUN gdebi -n quarto-linux-amd64.deb

# install languageserver
RUN apt install --assume-yes --no-install-recommends build-essential libcurl4-openssl-dev libssl-dev libxml2-dev r-base
RUN Rscript -e "install.packages('languageserver')"
