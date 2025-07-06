
bam_files = Channel.fromPath(params.bams)
chrom_sizes = file(params.chrom_sizes)
znorm_script = file(params.znorm_script)


include { BAM2BED } from '../modules/bam2bed'
include { CALLPEAKS } from '../modules/callpeaks'
include { GENOMECOV } from '../modules/genomecov'
include { MAKEBWS } from '../modules/makebws'
include { BIGWIGAVG } from '../modules/bigwigavg'
include { ZNORM } from '../modules/znorm'

workflow  {

    main:
    beds = BAM2BED(bam_files)
    peaks = CALLPEAKS(beds.bed)
    bedgraphs = GENOMECOV(beds.bed, chrom_sizes)
    bigwigs = MAKEBWS(bedgraphs.bedgraph, chrom_sizes)
    avg_bigwigs = BIGWIGAVG(bigwigs.bigwig)
    znorm_avg_bigwigs = ZNORM(avg_bigwigs.avg_bigwig, znorm_script)
        
    emit:
    beds = beds.bed
    peaks_narrowPeak = peaks.peaks
    peaks_summits = peaks.summits
    cutsites = bedgraphs.cutsites_bed
    bigwigs = znorm_avg_bigwigs.znorm_bw
} 
