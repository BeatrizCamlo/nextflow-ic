nextflow.enable.dsl=2

include { alignment; sort_and_index } from './processes.nf'

workflow {
    zika_ch = Channel.fromPath('zika_reads.fastq', checkIfExists: true)
    hum_ch = Channel.fromPath('human.1.rna.fna', checkIfExists: true)

    alignment(zika_ch, hum_ch) | sort_and_index
}