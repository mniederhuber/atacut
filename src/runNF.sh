#! /bin/bash
#SBATCH --output=var/logs/nf-%j.out
#SBATCH --error=var/logs/nf-%j.err
#SBATCH --time=04:00:00
#SBATCH --mem=8G

mkdir -p var/logs

module load nextflow

nextflow run src/nextflow/workflows/cutsite_analysis.nf -resume -params-file config/params.yaml -c config/nextflow.config
