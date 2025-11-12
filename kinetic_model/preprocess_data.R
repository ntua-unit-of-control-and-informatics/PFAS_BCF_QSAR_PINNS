kinetic_data <- read.csv("data/dataset.csv")

# Keep only relevant columns
columns_to_keep <- c("PFAS", "kup_nlls", "kel_nlls")
kinetic_data <- kinetic_data[columns_to_keep]

pfas_list <- unique(kinetic_data$PFAS)

# Initialize empty data frame to accumulate results
summarised_data <- data.frame(
    PFAS = character(),
    mean_kup = numeric(),
    mean_kel = numeric(),
    stringsAsFactors = FALSE
)

for(congener in pfas_list){
    congener_data <- kinetic_data[kinetic_data$PFAS == congener, ]
    mean_kup <- mean(congener_data$kup_nlls)
    mean_kel <- mean(congener_data$kel_nlls)
    cat("Congener:", congener, "Mean kup:", mean_kup, "Mean kel:", mean_kel, "\n")

    # Append to the existing data frame
    summarised_data <- rbind(summarised_data, data.frame(
        PFAS = congener,
        mean_kup = mean_kup,
        mean_kel = mean_kel,
        stringsAsFactors = FALSE
    ))
}

# Save the summarised data to a new CSV file
write.csv(summarised_data, "data/summarised_kinetic_data.csv", row.names = FALSE)
