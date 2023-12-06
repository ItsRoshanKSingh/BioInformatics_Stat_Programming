# ANSI escape codes for colors
tick <- "\u2713"
red <- "\033[31m"
green <- "\033[32m"
reset <- "\033[0m"

success_message <- function(message) {
    cat(
        green, tick, message, reset, "\n"
    )
}

# Read Promoter and Non Promoter free engery region file
promoter_regions <- read.csv(
    "output/files/promoter_regions.csv",
    header = FALSE
)

non_promoter_regions <- read.csv(
    "output/files/non_promoter_regions.csv",
    header = FALSE
)

# Calculate the Mean of column for both Promoter and NOn-Promoter
promoter_region_avg <- colMeans(promoter_regions)
non_promoter_region_avg <- colMeans(non_promoter_regions)

# Create and Store the Average Free Energy value of Promoter and Non-Promoter
write.csv(
    promoter_region_avg,
    file = "output/files/promoter_avg.csv",
    row.names = FALSE,
)
success_message(
    "Promoter avg Free Energy value added in \033[93m 'output/files/promoter_avg.csv'"
)
write.csv(
    non_promoter_region_avg,
    file = "output/files/non_promoter_avg.csv",
    row.names = FALSE
)
success_message(
    "Non_Promoter avg free value added in \033[93m 'output/files/non_promoter_avg.csv'"
)

# x_values <- seq_len(length(promoter_region_avg))
x_values <- seq(-150, 49, by = 1)


# Create and Save Promoter/Non-Promoter Average Line Plot
invisible({
    png(
        "output/graph/PromoterVsNonPromoter_Avg_LinePlot.png",
        width = 1200, height = 750, units = "px", pointsize = 12, res = 96
    )

    par(mfrow = c(1, 2))

    plot(
        x_values, promoter_region_avg,
        type = "l", col = "blue",
        xlab = "Sequence Position", ylab = "Average Free Energy",
        main = "Promoter VS NonPromoter Average Free Energy",
        ylim = c(-1.48, -1.15)
    )

    grid(col = "gray")
    lines(
        x_values, non_promoter_region_avg,
        type = "l", col = "red"
    )

    plot(
        x_values, non_promoter_region_avg,
        type = "l", col = "red",
        xlab = "Sequence Position", ylab = "Non-Promoter Average Free Energy",
        main = "Line Graph of Non-Promoter Region Average Free Energy"
    )

    grid()
    dev.off()
})
success_message("Promoter/Non-Promoter Average Line Plot added to \033[93m 'output/graph/PromoterVsNonPromoter_Avg_LinePlot.png")

# Perform independent samples t-test
t_test_result <- t.test(promoter_region_avg, non_promoter_region_avg)

output_file <- "output/files/t-test-result.txt"
file_conn <- file(output_file, "w")

cat("--------------------------------------------------------\n", file = file_conn)
cat("--------------------------------------------------------\n", file = file_conn)
cat("Null Hypothesis (H0): There is no significant difference between the means of the promoter and non-promoter regions.\n", file = file_conn)
cat("Alternative Hypothesis (H1): There is a significant difference between the means of the promoter and non-promoter regions.\n", file = file_conn)
# # Write t-test results to the file
cat("--------------------------------------------------------\n", file = file_conn)
cat("T-Test Results:\n", file = file_conn)
cat("--------------------------------------------------------\n", file = file_conn)
cat("t statistic(t): ", t_test_result$statistic, "\n", file = file_conn)
cat("degrees of freedom(dm): ", t_test_result$parameter, "\n", file = file_conn)
cat("p-value: ", t_test_result$p.value, "\n", file = file_conn)
cat("Promoter mean: ", t_test_result$estimate[1], "\n", file = file_conn)
cat("Non-Promoter mean: ", t_test_result$estimate[2], "\n", file = file_conn)
cat("--------------------------------------------------------\n", file = file_conn)

# Interpret the results and write to the file
if (t_test_result$p.value > 0.05) {
    cat("Fail To Reject Null Hypothesis\n", file = file_conn)
} else {
    cat("Null Hypothesis is Reject. And Alternate Hypothesis is Accepted.\n", file = file_conn)
}

# Close the file connection
close(file_conn)

# Confirm that the file has been written
success_message("Results written to \033[93m 'output/files/t-test-result.txt'\n")
