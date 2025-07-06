# ATACUT -- Pipeline for caling Tn5 Cutsite peaks

Common practices is to call ATAC-seq peaks from fragment pileups, but fragments represent *2* independent Tn5 cut events - one at either end of the fragment - and can obscure biologically relevant details about chromatin accessibility.

This is a simple Nextflow pipeline to...
1. Convert Bam files to bed
2. Call peaks on bed files with `Macs2` and settings to shift peak calling around cut sites instead of fragments
3. Generate bigWig coverage files with small estimated cut site fragments
4. Apply z-normalization to bigwigs

>[!WARNING]
> I initially wrote this workflow as part of a larger analysis and deployed on our university HPC. I plan to get this set up for running on GCP as well - but for now it should be ready to go for systems using slurm or LSF.  