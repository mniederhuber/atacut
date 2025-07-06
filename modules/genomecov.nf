

process GENOMECOV {
    tag "${bed_file.simpleName}"
    label "large"
    
    publishDir "${params.output_paths.cutsites}/bg", mode: params.publish_mode
    
    input:
    path bed_file
    path chrom_sizes
    
    output:
    path "${bed_file.simpleName}.bedGraph", emit: bedgraph
    path "${bed_file.simpleName}-CutSites.bed", emit: cutsites_bed
    
    script:
    def cut_site_params = params.genomecov.cut_site != null ? params.genomecov.cut_site : [upstream: 37, downstream: 37]
    def chromosomes_regex = params.genomecov.chromosomes_regex != null ? params.genomecov.chromosomes_regex : "([1-9]|1[0-9]|X|Y)"
    def threads = task.cpus
    
    """
    module load bedtools
    
    # Calculate scale factor based on number of reads
    reads=\$(wc -l ${bed_file} | awk '{print \$1}')
    scale_factor=\$(echo "1000000/\${reads}" | bc -l)
    
    # Extract cut sites and filter by chromosomes
    awk -v OFS='\t' \
        '{ if (\$6 == "+") { start=\$2-${cut_site_params.upstream}; end=\$2+${cut_site_params.downstream} } else { start=\$3-${cut_site_params.upstream}; end=\$3+${cut_site_params.downstream} } \
        if (start >= 0 && end >= 0 && (\$1 ~ /^${chromosomes_regex}\$/)) { print \$1, start, end, \$4, \$5, \$6 } }' ${bed_file} | \
        sort -k 1,1 > ${bed_file.simpleName}-CutSites.bed
    
    # Generate genome coverage
    bedtools genomecov -i ${bed_file.simpleName}-CutSites.bed -g ${chrom_sizes} -bg -scale \${scale_factor} > ${bed_file.simpleName}.bedGraph
    """
} 