process alignment {

    tag "Read Alignment"

    publishDir "${params.outdir}/sam", mode: 'copy'

    cpus 4
    memory '8 GB'

    input:
    path reads
    path reference

    output:
    path "alignment.sam"

    script:
    """
    minimap2 \
        -ax sr \
        ${reference} \
        ${reads} \
        > alignment.sam
    """
}

process sort_and_index {

    tag "Sort and Index"

    publishDir "${params.outdir}/bam", mode: 'copy'

    cpus 2
    memory '4 GB'

    input:
    path sam_file

    output:
    path "aligned_sorted.bam"
    path "aligned_sorted.bam.bai"

    script:
    """
    samtools view \
        -bS ${sam_file} \
    | samtools sort \
        -o aligned_sorted.bam

    samtools index aligned_sorted.bam
    """
}