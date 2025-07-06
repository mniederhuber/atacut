

process MAKEBWS {
    tag "${bedgraph_file.simpleName}"
    label "bgtobw"
    
    publishDir "${params.output_paths.cutsites}/bw", mode: params.publish_mode
    
    input:
    path bedgraph_file
    path chrom_sizes
    
    output:
    path "${bedgraph_file.simpleName}.bw", emit: bigwig
    
    script:
    """
    bedGraphToBigWig ${bedgraph_file} ${chrom_sizes} ${bedgraph_file.simpleName}.bw
    """
} 