process combine_references {

    tag "Combine References"

    publishDir "${params.outdir}/reference", mode: 'copy'

    input:
    path references

    output:
    path "combined_reference.fasta"

    script:
    """
    touch combined_reference.fasta

    for fasta in ${references}; do

        prefix=\$(basename "\$fasta")
        prefix=\${prefix%%.*}

        awk -v p="\$prefix" '
            /^>/ {
                sub(/^>/,"")
                print ">" p "|" \$0
                next
            }
            {
                print
            }
        ' "\$fasta" >> combined_reference.fasta

    done
    """
}

process alignment {

    tag "Read Alignment"

    publishDir "${params.outdir}/sam", mode: 'copy'

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

    input:
    path sam_file

    output:
    path "aligned_sorted.bam"
    path "aligned_sorted.bam.bai"

    script:
    """
    samtools view -bS ${sam_file} \
        | samtools sort -o aligned_sorted.bam

    samtools index aligned_sorted.bam
    """
}
