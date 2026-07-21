# Pipeline de Alinhamento de Sequências

Este projeto foi desenvolvido para o **Centro Multiusuário de Bioinformática (BioME/IMD/UFRN)** e automatiza o processo de alinhamento de sequências utilizando **Nextflow**.

A pipeline recebe um arquivo de leituras (FASTQ/FASTQ.GZ) e um diretório contendo arquivos de referência (FASTA/FNA), combina automaticamente todas as referências em um único arquivo FASTA preservando identificadores únicos, realiza o alinhamento das sequências utilizando **Minimap2** e, em seguida, utiliza o **Samtools** para converter, ordenar e indexar os arquivos gerados.

## Ferramentas utilizadas

- **Nextflow** – Gerenciamento do workflow.
- **Minimap2** – Alinhamento das sequências.
- **Samtools** – Conversão, ordenação e indexação dos arquivos de alinhamento.
- **Docker** *(opcional)* – Execução da pipeline em ambiente isolado.

---

## Estrutura do projeto

```text
.
├── Dockerfile
├── main.nf
├── processes.nf
├── nextflow.config
├── README.md
├── results/
│   ├── bam/
│   ├── reference/
│   └── sam/
└── work/
```

---

## Pré-requisitos

Para executar a pipeline localmente é necessário possuir:

- Java 17 ou superior;
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
sudo mv nextflow /usr/local/bin/
```

Verifique a instalação:

```bash
nextflow -version
```

---

## Preparação dos dados

O repositório **não inclui os arquivos de referência nem os arquivos de teste**, pois eles possuem tamanho elevado.

Para executar a pipeline utilizando o conjunto de dados de demonstração, faça o download do pacote disponibilizado pela Oxford Nanopore:

```bash
wget https://ont-exd-int-s3-euwst1-epi2me-labs.s3.amazonaws.com/wf-alignment/wf-alignment-demo.tar.gz

tar -xzvf wf-alignment-demo.tar.gz
```

Após a extração, será criada a seguinte estrutura:

```text
wf-alignment-demo/
├── fastq/
│   ├── sample_A/
│   │   └── reads.fastq.gz
│   ├── sample_B/
│   │   └── reads.fastq.gz
│   └── sample_C/
│       └── reads.fastq.gz
└── references/
    ├── Escherichia_coli.fasta
    ├── Salmonella_enterica.fasta
    └── Staphylococcus_aureus.fasta
```

O diretório `references/` contém os genomas de referência utilizados pela pipeline e deve ser informado no parâmetro `--reference`.

O parâmetro `--reads` deve receber um dos arquivos `reads.fastq.gz` presentes no diretório `fastq/`.

---

## Execução

### Execução local

```bash
nextflow run main.nf \
    --reads wf-alignment-demo/fastq/sample_A/reads.fastq.gz \
    --reference wf-alignment-demo/references
```

Também é possível utilizar outros arquivos de entrada:

```bash
nextflow run main.nf \
    --reads caminho/para/arquivo.fastq.gz \
    --reference caminho/para/references
```

---

## Execução com Docker

### Construir a imagem

```bash
docker build -t ic-alignment .
```

### Executar a pipeline

```bash
docker run --rm \
    -v $(pwd):/project \
    -w /project \
    ic-alignment \
    nextflow run main.nf \
    --reads wf-alignment-demo/fastq/sample_A/reads.fastq.gz \
    --reference wf-alignment-demo/references
```

---

## Resultados

Ao final da execução, os arquivos serão armazenados na pasta `results`.

```text
results/
├── bam/
│   ├── aligned_sorted.bam
│   └── aligned_sorted.bam.bai
├── reference/
│   └── combined_reference.fasta
└── sam/
    └── alignment.sam
```

### Arquivos gerados

| Arquivo | Descrição |
|----------|-----------|
| `combined_reference.fasta` | Arquivo FASTA contendo todas as referências combinadas, preservando identificadores únicos para cada sequência. |
| `alignment.sam` | Resultado do alinhamento gerado pelo Minimap2. |
| `aligned_sorted.bam` | Arquivo BAM ordenado. |
| `aligned_sorted.bam.bai` | Índice do arquivo BAM. |

---

## Fluxo da pipeline

A pipeline executa as seguintes etapas:

1. Recebe um arquivo de leituras (`FASTQ` ou `FASTQ.GZ`);
2. Recebe um diretório contendo arquivos de referência (`.fa`, `.fasta` ou `.fna`);
3. Localiza automaticamente todos os arquivos de referência presentes no diretório informado;
4. Combina todas as referências em um único arquivo FASTA, adicionando um prefixo baseado no nome de cada arquivo aos identificadores das sequências para evitar colisões entre cabeçalhos;
5. Executa o alinhamento das leituras utilizando o **Minimap2**;
6. Converte o arquivo SAM para BAM utilizando o **Samtools**;
7. Ordena o arquivo BAM;
8. Gera o índice (`.bai`) do arquivo BAM.

---

## Exemplo de execução

Após baixar o conjunto de dados de demonstração, execute:

```bash
nextflow run main.nf \
    --reads wf-alignment-demo/fastq/sample_A/reads.fastq.gz \
    --reference wf-alignment-demo/references
```

Ao término da execução, a estrutura de saída será semelhante a:

```text
results/
├── bam/
│   ├── aligned_sorted.bam
│   └── aligned_sorted.bam.bai
├── reference/
│   └── combined_reference.fasta
└── sam/
    └── alignment.sam
```

---

## Autores

Projeto desenvolvido para o **Centro Multiusuário de Bioinformática (BioME/IMD/UFRN)**.
