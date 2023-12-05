options(repos = c(CRAN = "https://cran.r-project.org"))

if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}
install.packages("GenomeInfoDb")
BiocManager::install("seqLogo")
BiocManager::install("Biostrings")