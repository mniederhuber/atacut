

process BAM2BED {
    label "medium"
    
    publishDir "${params.outdir}/bed", mode: params.publish_mode
    
    input:
    path bam_file
    
    output:
    path "${bam_file.baseName}.bed"
    
    script:
    """
    module load bedtools
    bamToBed -i ${bam_file} > ${bam_file.baseName}.bed
    """
} 