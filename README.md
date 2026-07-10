# Pipeline de Alinhamento de Sequências de RNA

Este projeto foi desenvolvido para o **Centro Multiusuário de Bioinformática (BioME/IMD/UFRN)** e automatiza o processo de alinhamento de sequências de RNA utilizando **Nextflow**.

O pipeline recebe um arquivo de leituras (FASTQ) e um genoma de referência (FASTA), realiza o alinhamento das sequências com o **Minimap2** e, em seguida, utiliza o **Samtools** para converter, ordenar e indexar os arquivos gerados.

## Ferramentas utilizadas

- **Nextflow** – Gerenciamento do fluxo de trabalho.
- **Minimap2** – Alinhamento das sequências.
- **Samtools** – Conversão, ordenação e indexação dos arquivos de alinhamento.
- **Docker** *(opcional)* – Execução do pipeline em ambiente isolado.

## Estrutura do projeto

```text
.
├── main.nf
├── processes.nf
├── nextflow.config
├── Dockerfile
├── docker-compose.yml
├── human.1.rna.fna
├── zika_reads.fastq
├── results/
│   ├── sam/
│   └── bam/
└── README.md
```

## Pré-requisitos

Antes de executar o pipeline, é necessário ter instalado:

- Java 11 ou superior;
- Nextflow;
- Minimap2;
- Samtools.

### Instalação no Ubuntu/Debian

```bash
sudo apt update

sudo apt install -y \
    openjdk-17-jre-headless \
    minimap2 \
    samtools \
    curl

curl -s https://get.nextflow.io | bash
chmod +x nextflow
```

## Como executar

### Utilizando Docker

```bash
docker compose up --build
```

### Execução local

```bash
./nextflow run main.nf \
    --reference human.1.rna.fna \
    --reads zika_reads.fastq
```

Para utilizar outros arquivos de entrada, basta informar seus caminhos:

```bash
./nextflow run main.nf \
    --reference referencia.fasta \
    --reads amostra.fastq
```

## Resultados

Ao final da execução, os arquivos serão salvos na pasta `results`.

```
results/
├── sam/
│   └── alignment.sam
└── bam/
    ├── aligned_sorted.bam
    └── aligned_sorted.bam.bai
```

### Arquivos gerados

| Arquivo | Descrição |
|----------|-----------|
| `alignment.sam` | Resultado do alinhamento das sequências. |
| `aligned_sorted.bam` | Arquivo BAM ordenado. |
| `aligned_sorted.bam.bai` | Índice do arquivo BAM. |

## Fluxo da pipeline

O pipeline executa as seguintes etapas:

1. Lê o arquivo de sequências (FASTQ) e o genoma de referência (FASTA);
2. Alinha as sequências utilizando o **Minimap2**;
3. Converte o arquivo SAM para BAM com o **Samtools**;
4. Ordena o arquivo BAM;
5. Gera o índice do arquivo BAM.

## Autores

Projeto desenvolvido para o **Centro Multiusuário de Bioinformática (BioME/IMD/UFRN)**.