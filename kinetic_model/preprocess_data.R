# Preprocess the data for the kinetic model

kinetic_data <- read.csv("data/dataset.csv")

# Keep only relevant columns
columns_to_keep <- c("Study", "PFAS", "kup_nlls", "kel_nlls")
kinetic_data <- kinetic_data[columns_to_keep]

pfas_list <- unique(kinetic_data$PFAS)

# Initialize empty data frame to accumulate results
summarised_data <- data.frame(
    study = character(),
    PFAS = character(),
    mean_kup = numeric(),
    mean_kel = numeric(),
    N = integer(),
    stringsAsFactors = FALSE
)

for (congener in pfas_list){
    congener_data <- kinetic_data[kinetic_data$PFAS == congener, ]
    list_of_studies <- unique(congener_data$Study)
    for (study in list_of_studies){
        study_data <- congener_data[congener_data$Study == study, ]
        mean_kup <- mean(study_data$kup_nlls)
        mean_kel <- mean(study_data$kel_nlls)
        N <- nrow(study_data)
        cat("Study:", study, "Congener:", congener, "Mean kup:", mean_kup, "Mean kel:", mean_kel, "N:", N, "\n")

        # Append to the existing data frame
        summarised_data <- rbind(summarised_data, data.frame(
            study = study,
            PFAS = congener,
            mean_kup = mean_kup,
            mean_kel = mean_kel,
            N = N,
            stringsAsFactors = FALSE
        ))
    }
}
# sort by PFAS and study
summarised_data <- summarised_data[order(summarised_data$PFAS, summarised_data$study), ]

original_study_set <- sort(unique(kinetic_data$Study))
# Remap the study index to start from 1
summarised_data$study <- summarised_data$study - 64

print(summarised_data)

# Save the summarised data to a new CSV file
write.csv(summarised_data, "data/summarised_kinetic_data.csv", row.names = FALSE)
