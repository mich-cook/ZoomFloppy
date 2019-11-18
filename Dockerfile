# specific known version of 18.04 LTS 
FROM ubuntu:bionic-20190612

# get sudo on the machine so we don't have to modify the scripts
RUN apt update && apt install -y sudo && rm -rf /var/lib/apt/lists/*

COPY install_c64sw.sh /
RUN /install_c64sw.sh
