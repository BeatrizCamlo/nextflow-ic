nextflow.enable.dsl = 2

include {
    combine_references
    alignment
    sort_and_index
} from './processes'

def validateParameters() {
    if (!params.reads || !params.reference) {
        error """
Parâmetros obrigatórios não informados.

Uso:

nextflow run main.nf \
    --reads reads.fastq \
    --reference referencias/
"""
    }
}

workflow {

    validateParameters()

    reads_ch = Channel.fromPath(
        params.reads,
        checkIfExists: true
    )

    references_ch = Channel.fromPath(
        "${params.reference}/*.{fa,fastaq,fna}",
        checkIfExists: true
    ).collect()

    combined_reference = combine_references(references_ch)

    sam = alignment(reads_ch, combined_reference)

    sort_and_index(sam)
}