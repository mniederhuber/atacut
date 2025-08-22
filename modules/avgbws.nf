
process AVGBWS {

    publishDir "${params.outdir}/bw", mode: params.publish_mode
    clusterOptions = '-n 24'

    input:
    tuple val(grpid), path(bws)

    output:
    path "${grpid}_repAvg.bw"

    script:
    """
    module load deeptools/3.5.4
    bigwigAverage -p 24 --binSize 10 -b ${bws.join(' ')} -o ${grpid}_repAvg.bw
    """
}