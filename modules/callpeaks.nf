

process CALLPEAKS {
    label "large"
    
    publishDir "${params.outdir}/peaks", mode: params.publish_mode
    
    input:
    path bed_file
    
    output:
    path "${bed_file.simpleName}_peaks.narrowPeak"
    path "${bed_file.simpleName}_peaks.xls"
    path "${bed_file.simpleName}_summits.bed"
    
    script:
    def shift = params.macs2.shift != null ? params.macs2.shift : -37
    def extsize = params.macs2.extsize != null ? params.macs2.extsize : 75
    def keep_dup = params.macs2.keep_dup != null ? params.macs2.keep_dup : "all"
    def model = params.macs2.model ? "" : "--nomodel"
    
    """
    module load macs/2.2.9.1
    macs2 callpeak -f BED -t ${bed_file} -n ${bed_file.simpleName} \\
        --shift ${shift} --extsize ${extsize} --keep-dup ${keep_dup} ${model}
    """
} 