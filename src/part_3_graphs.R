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


# Create and Save Promoter Average Line Plot
invisible({
    png(
        "output/graph/promoter_avg_line_plot.png",
        width = 800, height = 600, units = "px", pointsize = 12, res = 96
    )
    plot(
        x_values, promoter_region_avg,
        type = "l", col = "blue",
        xlab = "Sequence Position", ylab = "Average Free Energy",
        main = "Line Graph of Promoter Region Average Free Energy"
    )
    # lines(non_promoter_region_avg, type = "l", col = "red")
    grid()
    dev.off()
})
success_message("Promoter Average Line Plot added to \033[93m 'output/graph/promoter_avg_line_plot.png")

# # Create and Save Non-Promoter Average Line Plot
invisible({
    png(
        "output/graph/non_promoter_avg_line_plot.png",
        width = 800, height = 600, units = "px", pointsize = 12, res = 96
    )
    plot(
        x_values, non_promoter_region_avg,
        type = "l", col = "red",
        xlab = "Sequence Position", ylab = "Promoter Average Free Energy",
        main = "Line Graph of Non-Promoter Region Average Free Energy"
    )
    grid()
    dev.off()
})
success_message("Non Promoter Average Line Plot added to \033[93m 'output/graph/non_promoter_avg_line_plot.png")

t_test_result <- t.test(promoter_region_avg, non_promoter_region_avg)

# Open a text file for writing (replace "output.txt" with your desired file path)
output_file <- "t-test-result.txt"
file_conn <- file(output_file, "w")

# Write t-test results to the file
cat("T-Test Results:\n", file = file_conn)
cat("--------------------------------------------------------\n", file = file_conn)
cat("t statistic: ", t_test_result$statistic, "\n", file = file_conn)
cat("degrees of freedom: ", t_test_result$parameter, "\n", file = file_conn)
cat("p-value: ", t_test_result$p.value, "\n", file = file_conn)
cat("--------------------------------------------------------\n", file = file_conn)

# Interpret the results and write to the file
alpha <- 0.05 # significance level
if (t_test_result$p.value < alpha) {
    cat("There is a statistically significant difference between promoter and non-promoter regions.\n", file = file_conn)
} else {
    cat("There is no statistically significant difference between promoter and non-promoter regions.\n", file = file_conn)
}

# Close the file connection
close(file_conn)

# Confirm that the file has been written
success_message("Results written to \033[93m 't-test-result.txt'\n")
