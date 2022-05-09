sudo apt update
sudo apt install -y --no-install-recommends software-properties-common dirmngr

wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base

# Ubuntu CRAN binaries
sudo add-apt-repository ppa:c2d4u.team/c2d4u4.0+ -y 
sudo apt update && sudo apt install r-cran-tidyverse  # Not necessary, proves the repo was registered


RSTUDIO_VERSION="stable"
ARCH=$(dpkg --print-architecture)
DOWNLOAD_FILE=rstudio-server.deb
R_HOME=/usr/local/lib/R

sudo apt-get update && sudo apt-get install -y --no-install-recommends \
    file \
    git \
    libapparmor1 \
    libgc1c2 \
    libclang-dev \
    libcurl4-openssl-dev \
    libedit2 \
    libobjc4 \
    libssl-dev \
    libpq5 \
    lsb-release \
    psmisc \
    procps \
    python-setuptools \
    pwgen \
    sudo \
    wget

wget "https://rstudio.org/download/latest/${RSTUDIO_VERSION}/server/bionic/rstudio-server-latest-${ARCH}.deb" \
    -O "$DOWNLOAD_FILE" \
  && sudo dpkg -i "$DOWNLOAD_FILE" \
  && rm "$DOWNLOAD_FILE"

## Set up RStudio init scripts
sudo mkdir -p /etc/services.d/rstudio

# Run file
echo '#!/usr/bin/with-contenv bash
## load /etc/environment vars first:
for line in $( cat /etc/environment ) ; do export $line > /dev/null; done
exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
> /tmp/rstudio-run \
  && sudo mv /tmp/rstudio-run /etc/services.d/rstudio/run

# Finish file
echo '#!/bin/bash
rstudio-server stop' \
> /tmp/rstudio-finish \
  && sudo mv /tmp/rstudio-finish /etc/services.d/rstudio/finish


# Logging file to stderr
LOGGING="[*]
log-level=warn
logger-type=syslog
"

printf "%s" "$LOGGING" > /tmp/rstudio-logging && sudo mv /tmp/rstudio-logging /etc/rstudio/logging.conf
  
  
  sudo apt update && sudo apt install -y \
  software-properties-common \
  python3-dev \
  python3-pip \
  build-essential

# I don't currently recommend using `venv` over `virtualenv` due to
# bug between Ubuntu and pip which causes an incorrect `pip freeze` output
pip3 install -U virtualenv
