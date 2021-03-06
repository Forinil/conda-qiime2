FROM ubuntu:20.04

ARG BUILD_DATE
ARG SOURCE_COMMIT
LABEL maintainer="Konrad Botor (kbotor@gmail.com)" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Conda Qiime2" \
      org.label-schema.description="Docker image containing Conda and Qiime2 usable with Singularity" \
      org.label-schema.url="https://github.com/Forinil/conda-qiime2" \
      org.label-schema.vcs-ref=$SOURCE_COMMIT \
      org.label-schema.vcs-url="https://github.com/Forinil/conda-qiime2" \
      org.label-schema.vendor="Konrad Botor" \
      org.label-schema.version="1.0" \
      org.label-schema.schema-version="1.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
    apt-utils \
    wget=1.20.3-1ubuntu1 \
    git=1:2.25.1-1ubuntu3 && \
    apt-get clean && \
    rm -rf rm -rf /var/lib/apt/lists/* && \
    wget https://repo.anaconda.com/miniconda/Miniconda3-py38_4.8.3-Linux-x86_64.sh && \
    chmod +x Miniconda3-py38_4.8.3-Linux-x86_64.sh && \
    ./Miniconda3-py38_4.8.3-Linux-x86_64.sh -b -p /opt/miniconda3 && \
    ln -s /opt/miniconda3/bin/conda /usr/bin/conda && \
    wget https://data.qiime2.org/distro/core/qiime2-2020.8-py36-linux-conda.yml && \
    conda env create -n qiime2-2020.8 --file qiime2-2020.8-py36-linux-conda.yml && \
    conda install -y -n qiime2-2020.8 -c conda-forge -c bioconda -c qiime2 -c defaults q2cli q2templates q2-types q2-feature-table q2-metadata vsearch snakemake && \
    chmod --recursive a+rw /opt/miniconda3 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm /qiime2-2020.8-py36-linux-conda.yml && \
    rm /Miniconda3-py38_4.8.3-Linux-x86_64.sh

CMD ["/bin/bash"]