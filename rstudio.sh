# Install R (from binary)
REPO="deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
URL="https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc"
FILE="/etc/apt/trusted.gpg.d/cran_ubuntu_key.asc"

sudo add-apt-repository -y $REPO
sudo apt update
wget $URL -aO $FILE
sudo apt install -y --no-install-recommends \
  r-base


# Install Tidyverse
REPO="ppa:c2d4u.team/c2d4u4.0+"

sudo add-apt-repository -y $REPO
sudo apt update
sudo apt install -y \
  r-cran-tidyverse


# Install RStudio (from binary)
URL="https://rstudio.org/download/latest/stable/server/bionic/rstudio-server-latest-$(dpkg --print-architecture).deb"
FILE="rstudio-server.deb"

wget $URL -O $FILE
sudo dpkg -i $FILE
rm $FILE


# Setup RStudio
STR_RUN='#!/usr/bin/with-contenv bash
## load /etc/environment vars first:
for line in $( cat /etc/environment ) ; do export $line > /dev/null; done
exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0'
STR_FINISH='#!/bin/bash
rstudio-server stop'
STR_LOG='[*]
log-level=warn
logger-type=syslog'

sudo mkdir -p /etc/services.d/rstudio
echo $STR_RUN | sudo tee /etc/services.d/rstudio/run
echo $STR_FINISH | sudo tee /etc/services.d/rstudio/finish
echo $STR_LOG | sudo tee /etc/rstudio/logging.conf


# Install Python
sudo apt update
sudo apt install -y \
  software-properties-common \
  python3-dev \
  python3-pip \
  build-essential
pip3 install -U virtualenv
