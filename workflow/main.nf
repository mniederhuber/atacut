
bam_files = Channel.fromPath(params.bams)
chrom_sizes = file(params.chrom_sizes)
znorm_script = file(params.znorm_script)

include { BAM2BED } from '../modules/bam2bed'
include { CALLPEAKS } from '../modules/callpeaks'
include { GENOMECOV } from '../modules/genomecov'
include { MAKEBWS } from '../modules/makebws'
include { AVGBWS } from '../modules/avgbws'
include { ZNORM } from '../modules/znorm'

workflow  {

    main:
    def beds = BAM2BED(bam_files)

    def bedgraphs = GENOMECOV(beds, chrom_sizes)
    def bigwigs = MAKEBWS(bedgraphs.bedgraph, chrom_sizes)
        .map { bw -> tuple(bw.simpleName.split(/_REP\d+/)[0], bw) } // extract a grouping id for averaging // this is bad with hardcode!
        .groupTuple()

    def avg_bigwigs = AVGBWS(bigwigs)

    ZNORM(avg_bigwigs, znorm_script)
    CALLPEAKS(beds)
} 
