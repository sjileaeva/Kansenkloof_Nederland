library(tidyr)
library(dplyr)

bins <- c("bins5", "bins10", "bins20", "mean")
outcomes <- c("child_mortality", "classroom", "elementary_School", "high_school", "perinatal", "students", "main")

for (bin in bins) {
  for (outcome in outcomes) {
    nl_file_path <- paste0("/Users/lilsonea/Documents/GitHub/Kansenkloof_Nederland/data/nl/", bin, "_tab_", outcome, ".csv")
    en_file_path <- paste0("/Users/lilsonea/Documents/GitHub/Kansenkloof_Nederland/data/en/", bin, "_tab_", outcome, ".csv")
    amsterdam_nl_file_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/nl/", bin, "_tab.rds")
    amsterdam_en_file_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/en/", bin, "_tab.rds")
    
    if (file.exists(nl_file_path) & file.exists(en_file_path) & file.exists(amsterdam_nl_file_path) & file.exists(amsterdam_en_file_path)) {
      kansenkloof <- read.csv(nl_file_path)
      opportunitygap <- read.csv(en_file_path)
      amsterdam_nl <- readRDS(amsterdam_nl_file_path)
      amsterdam_en <- readRDS(amsterdam_en_file_path)
      
      amsterdam_nl_relevant <- amsterdam_nl %>%
        filter(geografie == "Nederland", uitkomst %in% unique(kansenkloof$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          type = as.integer(type),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      amsterdam_en_relevant <- amsterdam_en %>%
        filter(geografie == "The Netherlands", uitkomst %in% unique(kansenkloof$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          type = as.integer(type),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      
      # Combine datasets
      combined_data_nl <- bind_rows(kansenkloof, amsterdam_nl_relevant)
      write.csv(combined_data_nl, nl_file_path, row.names = FALSE)
      combined_data_en <- bind_rows(opportunitygap, amsterdam_en_relevant)
      write.csv(combined_data_en, en_file_path, row.names = FALSE)
    } else if (!file.exists(nl_file_path)){
      # If neither file exists, print a message
      message(paste("NL file not found for:", bin, outcome))
    } else if (!file.exists(en_file_path)){
      message(paste("EN file not found for:", bin, outcome))
    }
  }
}



#For data by parental education
#*Only elementary school and perinatal outcomes are available
outcomes <- c("elementary_School", "perinatal")


for (outcome in outcomes) {
    nl_file_path <- paste0("~/Documents/GitHub/Kansenkloof_Nederland/data/nl/parents_edu_tab_", outcome, ".csv")
    amsterdam__nl_file_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/nl/parents_edu_tab.rds")
    en_file_path <- paste0("~/Documents/GitHub/Kansenkloof_Nederland/data/en/parents_edu_tab_", outcome, ".csv")
    amsterdam_en_file_path <- paste0("/Users/lilsonea/Documents/GitHub/kenniscentrumongelijkheid/data/en/parents_edu_tab.rds")
    
    if (file.exists(en_file_path) & file.exists(nl_file_path) & file.exists(amsterdam_en_file_path) & file.exists(amsterdam_nl_file_path)) {
      # Load existing main file if it exists
      kansenkloof <- read.csv(main_file_path)
      opportunitymap <- read.csv(en_file_path)
      
      # Load Amsterdam file and filter for Nederland only
      amsterdam_nl <- readRDS(amsterdam_file_path)
      amsterdam_nl_relevant <- amsterdam %>%
        filter(geografie == "Nederland", uitkomst %in% unique(kansenkloof$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      amsterdam_en <- readRDS(amsterdam_en_file_path)
      amsterdam_en_relevant <- amsterdam_en %>%
        filter(geografie == "The Netherlands", uitkomst %in% unique(opportunitymap$uitkomst)) %>%
        mutate(
          N = as.integer(N),
          uitkomst_NL = as.character(uitkomst_NL)
        )
      
      # Combine datasets and write to main file path
      combined_data_nl <- bind_rows(kansenkloof, amsterdam_nl_relevant)
      write.csv(combined_data_nl, nl_file_path, row.names = FALSE)
      combined_data_en <- bind_rows(opportunitymap, amsterdam_en_relevant)
      write.csv(combined_data_en, en_file_path, row.names = FALSE)
    } else {
      # If neither file exists, print a message
      message(paste("File not found for:", bin, outcome))
    }
}
