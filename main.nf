nextflow.enable.dsl = 2

include { alignment; sort_and_index } from './processes'

def validateParameters() {
    if (!params.reads || !params.reference) {
        error """
        Parâmetros obrigatórios não informados.

        Uso:
        nextflow run main.nf --reads <arquivo.fastq> --reference <arquivo.fasta>
        """
    }
}

workflow {

    validateParameters()

    reads_ch = Channel.fromPath(params.reads, checkIfExists: true)
    reference_ch = Channel.fromPath(params.reference, checkIfExists: true)

    alignment(reads_ch, reference_ch) | sort_and_index
}