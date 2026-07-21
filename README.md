# Pipeline de Alinhamento de Sequências de RNA

Este projeto foi desenvolvido para o **Centro Multiusuário de Bioinformática (BioME/IMD/UFRN)** e automatiza o processo de alinhamento de sequências de RNA utilizando **Nextflow**.

O pipeline recebe um arquivo de leituras (FASTQ) e um diretório contendo arquivos de referência (FASTA), combina todas as referências em um único arquivo FASTA preservando identificadores únicos, realiza o alinhamento das sequências com o **Minimap2** e, em seguida, utiliza o **Samtools** para converter, ordenar e indexar os arquivos gerados.

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
├── references/
│   ├── chr1.fna
│   ├── chr2.fna
│   └── ...
├── zika_reads.fastq
├── results/
│   ├── reference/
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

## Preparação das referências

Devido ao grande tamanho dos genomas de referência, recomenda-se disponibilizá-los em formato compactado (`.zip`, `.tar.gz` ou `.gz`).

Após realizar o download, extraia o conteúdo para um diretório contendo apenas os arquivos FASTA.

Exemplo utilizando um arquivo `.tar.gz`:

```bash
tar -xzf referencias.tar.gz
```

Ou, para arquivos `.zip`:

```bash
unzip referencias.zip
```

Após a extração, a estrutura do diretório deve ser semelhante a:

```text
references/
├── chr1.fna
├── chr2.fna
├── chr3.fna
├── chr4.fna
└── ...
```

A pipeline localizará automaticamente todos os arquivos com extensão `.fa`, `.fasta` e `.fna` presentes nesse diretório.

## Como executar

### Utilizando Docker

```bash
docker compose up --build
```

### Execução local

```bash
./nextflow run main.nf \
    --reads zika_reads.fastq \
    --reference references/
```

Para utilizar outros arquivos de entrada, basta informar seus caminhos:

```bash
./nextflow run main.nf \
    --reads amostra.fastq \
    --reference minhas_referencias/
```

## Resultados

Ao final da execução, os arquivos serão armazenados na pasta `results`.

```text
results/
├── reference/
│   └── combined_reference.fasta
├── sam/
│   └── alignment.sam
└── bam/
    ├── aligned_sorted.bam
    └── aligned_sorted.bam.bai
```

### Arquivos gerados

| Arquivo | Descrição |
|----------|-----------|
| `combined_reference.fasta` | Arquivo FASTA gerado pela combinação de todas as referências, com identificadores únicos para cada sequência. |
| `alignment.sam` | Resultado do alinhamento das sequências. |
| `aligned_sorted.bam` | Arquivo BAM ordenado. |
| `aligned_sorted.bam.bai` | Índice do arquivo BAM. |

## Fluxo da pipeline

O pipeline executa as seguintes etapas:

1. Recebe um arquivo de leituras (FASTQ) e um diretório contendo arquivos de referência (FASTA);
2. Localiza automaticamente todos os arquivos `.fa`, `.fasta` e `.fna` presentes no diretório informado;
3. Combina todas as referências em um único arquivo FASTA, adicionando um prefixo baseado no nome de cada arquivo aos identificadores das sequências para evitar colisões entre cabeçalhos;
4. Executa o alinhamento das reads utilizando o **Minimap2**;
5. Converte o arquivo SAM para BAM utilizando o **Samtools**;
6. Ordena o arquivo BAM;
7. Gera o índice do arquivo BAM.

## Autores

Projeto desenvolvido para o **Centro Multiusuário de Bioinformática (BioME/IMD/UFRN)**.