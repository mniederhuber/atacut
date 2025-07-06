FROM bioconductor/r-ver:3.21-R-4.5.1

RUN R -e "BiocManager::install('rtracklayer')"