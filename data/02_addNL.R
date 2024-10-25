library(tidyr)
library(dplyr)

bins <- c("bins5", "bins10", "bins20", "mean")
outcomes <- c("child_mortality", "classroom", "elementary_School", "high_school", "main", "perinatal", "students")

for (bin in bins) {
  for (outcome in outcomes) {
    main_file_path <- paste0("./data/nl/", bin, "_tab_", outcome, ".csv")
    amsterdam_file_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/nl/", bin, "_tab.rds")
    
    if (file.exists(main_file_path) & file.exists(amsterdam_file_path)) {
      kansenkloof <- read.csv(main_file_path)
      amsterdam <- readRDS(amsterdam_file_path)
    
      amsterdam_nl_relevant <- amsterdam %>%
        filter(geografie == "Nederland", uitkomst %in% unique(kansenkloof$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          type = as.integer(type),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      # Combine datasets
      combined_data <- bind_rows(kansenkloof, amsterdam_nl_relevant)
      write.csv(combined_data, main_file_path, row.names = FALSE)
    } else {
      amsterdam <- readRDS(amsterdam_file_path)
      
      amsterdam_nl_relevant <- amsterdam %>%
        filter(geografie == "Nederland", uitkomst %in% unique(kansenkloof$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          type = as.integer(type),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      write.csv(amsterdam_nl_relevant, main_file_path, row.names = FALSE)
    }
  }
}




bins <- "parents_edu"
outcomes <- c("child_mortality", "classroom", "elementary_School", "high_school", "main", "perinatal", "students")

for (bin in bins) {
  for (outcome in outcomes) {
    main_file_path <- paste0("~/Documents/GitHub/Kansenkloof_Nederland/data/nl/", bin, "_tab_", outcome, ".csv")
    amsterdam_file_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/nl/", bin, "_tab.rds")
    
    if (file.exists(main_file_path)) {
      # Load existing main file if it exists
      kansenkloof <- read.csv(main_file_path)
      
      # Load Amsterdam file and filter for Nederland only
      amsterdam <- readRDS(amsterdam_file_path)
      amsterdam_nl_relevant <- amsterdam %>%
        filter(geografie == "Nederland", uitkomst %in% unique(kansenkloof$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      
      # Combine datasets and write to main file path
      combined_data <- bind_rows(kansenkloof, amsterdam_nl_relevant)
      write.csv(combined_data, main_file_path, row.names = FALSE)
      
    } else if (file.exists(amsterdam_file_path)) {
      # If the main file is missing, create it using Nederland-only data from the Amsterdam file
      amsterdam <- readRDS(amsterdam_file_path)
      
      amsterdam_nl_relevant <- amsterdam %>%
        filter(geografie == "Nederland") %>%
        mutate(
          N = as.integer(N),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      
      # Write Nederland-only data to the main file path
      write.csv(amsterdam_nl_relevant, main_file_path, row.names = FALSE)
      
    } else {
      # If neither file exists, print a message
      message(paste("File not found for:", bin, outcome))
    }
  }
}

