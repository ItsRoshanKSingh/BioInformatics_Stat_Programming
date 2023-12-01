suppressMessages({
    suppressWarnings(library(BiocGenerics, quietly = TRUE, warn.conflicts = FALSE))
    suppressWarnings(library(S4Vectors, quietly = TRUE, warn.conflicts = FALSE))
    suppressWarnings(library(IRanges, quietly = TRUE, warn.conflicts = FALSE))
    suppressWarnings(library(Biostrings, quietly = TRUE, warn.conflicts = FALSE))
    suppressWarnings(library(seqLogo, quietly = TRUE, warn.conflicts = FALSE))
})

fasta_seq <- readLines("resources/ecoli_k12.fna", warn = FALSE)[-1] |> paste(collapse = "")
lines <- readLines("resources/ecoli_k12_tss.txt", warn = FALSE)

promoter_sequences <- character(0)

for (line in grep("forward", lines, value = TRUE)[1:99]) {
    promoter_index <- as.numeric(strsplit(line, "\t")[[1]][2])
    if (!is.na(promoter_index)) {
        promoter_sequences <- c(promoter_sequences, substr(fasta_seq, promoter_index - 35, promoter_index + 1))
    } else {
        cat("Warning: Failed to convert promoter index to numeric. Line:", line, "\n")
    }
}

sequence_set <- DNAStringSet(promoter_sequences)

pdf("output/graph/sequence_logo.pdf", width = 8, height = 6)



# Create a DNA frequency matrix
frequency_matrix <- consensusMatrix(sequence_set)

# Create a PWM from the frequency matrix
pwm <- PWM(frequency_matrix)

# Explicitly normalize the PWM columns to ensure they add up to 1.0
pwm_normalized <- t(t(pwm) / colSums(pwm))
pwm_normalized[pwm_normalized < 0] <- 0

# Generate a sequence logo
invisible({
    suppressWarnings({
        logo <- seqLogo(pwm_normalized, ic.scale = TRUE)
    })
    cat("\033[32m", "\u2713", "Consensus Mortif Saved to: \033[93m 'output/graph/sequence_logo.pdf'", "\033[0m", "\n")

    consensus_seq <- paste(apply(frequency_matrix, 2, function(col) names(col)[which.max(col)]), collapse = "")
    writeLines(consensus_seq, "output/files/consensus_seq.txt")
    cat("\033[32m", "\u2713", "Consensus Sequence Saved to: \033[93m 'output/files/consensus_seq.txt'", "\033[0m", "\n")
})
