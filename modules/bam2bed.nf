

process BAM2BED {
    tag "${bam_file.baseName}"
    label "medium"
    
    publishDir "${params.output_paths.cutsites}/bed", mode: params.publish_mode
    
    input:
    path bam_file
    
    output:
    path "${bam_file.baseName}.bed", emit: bed
    
    script:
    """
    module load bedtools
    bamToBed -i ${bam_file} > ${bam_file.baseName}.bed
    """
} 