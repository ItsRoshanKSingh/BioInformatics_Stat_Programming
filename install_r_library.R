options(repos = c(CRAN = "https://cran.r-project.org"))

if (!requireNamespace("BiocManager", quietly = TRUE)) {
    install.packages("BiocManager")
}

BiocManager::install("seqLogo")
# BiocManager::install("Biostrings")
BiocManager::install("Biostrings",force = TRUE, dependencies = TRUE)