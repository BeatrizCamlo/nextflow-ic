nextflow.enable.dsl=2

include{alignment} from './processes.nf'

workflow{
	zika_ch = Channel.fromPath('zika_reads.fastq')
	hum_ch = Channel.fromPath('human.1.rna.fna')

	alignment(zika_ch, hum_ch)
}
