FROM debian:bullseye-slim

LABEL description="Imagem para workflow Nextflow com minimap2 e samtools"

RUN apt-get update && apt-get install -y \
    openjdk-17-jre-headless \
    wget \
    curl \
    bzip2 \
    minimap2 \
    samtools \
    && rm -rf /var/lib/apt/lists/*


ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN curl -s https://get.nextflow.io | bash && \
    mv nextflow /usr/local/bin/

WORKDIR /project