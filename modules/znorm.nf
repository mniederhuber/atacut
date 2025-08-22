

process ZNORM {

    label "large"
    
    publishDir "${params.outdir}/bw", mode: params.publish_mode
    
    input:
    path bw_file
    path znorm_script
    
    output:
    path "${bw_file.simpleName}-znorm.bw", emit: znorm_bw
    
    script:
    def r_version = params.znorm_params?.r_version ?: "4.4.0"
    
    """
    Rscript --vanilla ${znorm_script} ${bw_file} ${bw_file.simpleName}-znorm.bw
    """
} 