process alignment {
    publishDir "results/sam", mode: 'copy'

    input:
    path reads
    path ref

    output:
    path "alignment.sam"

    script:
    """
    minimap2 -ax sr ${ref} ${reads} > alignment.sam
    """
}

process sort_and_index {
    publishDir "results/bam", mode: 'copy'

    input:
    path sam_file

    output:
    path "aligned_sorted.bam"
    path "aligned_sorted.bam.bai"

    script:
    """
    samtools view -bS ${sam_file} | samtools sort -o aligned_sorted.bam
    samtools index aligned_sorted.bam
    """
}