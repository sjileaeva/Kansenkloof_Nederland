library(tidyverse)

# Function to translate certain keywords from Dutch to English
translate_en <- function(i) {
  levels(i$geslacht)[match("Totaal",levels(i$geslacht))] <- "Total"
  levels(i$geslacht)[match("Mannen",levels(i$geslacht))] <- "Men"
  levels(i$geslacht)[match("Vrouwen",levels(i$geslacht))] <- "Women"
  
  levels(i$migratieachtergrond)[match("Totaal",levels(i$migratieachtergrond))] = "Total"
  levels(i$migratieachtergrond)[match("Marokko",levels(i$migratieachtergrond))] = "Morocco"
  levels(i$migratieachtergrond)[match("Turkije",levels(i$migratieachtergrond))] = "Turkey"
  levels(i$migratieachtergrond)[match("Suriname",levels(i$migratieachtergrond))] = "Suriname"
  levels(i$migratieachtergrond)[match("Nederlandse Antillen",levels(i$migratieachtergrond))] = "Dutch Caribbean"
  levels(i$migratieachtergrond)[match("Wel migratieachtergrond",levels(i$migratieachtergrond))] = "With Migration Background"
  levels(i$migratieachtergrond)[match("Zonder migratieachtergrond",levels(i$migratieachtergrond))] = "No Migration Background"
  
  
  levels(i$huishouden)[match("Totaal",levels(i$huishouden))] <- "Total"
  levels(i$huishouden)[match("Eenoudergezin",levels(i$huishouden))] <- "Single Parent"
  levels(i$huishouden)[match("Tweeoudergezin",levels(i$huishouden))] <- "Two Parents"
  
  
  if ("opleiding_ouders" %in% names(i)) {
    levels(i$opleiding_ouders)[match("Totaal",levels(i$opleiding_ouders))] <- "Total"
  }
  
  
  levels(i$bins)[match("Totaal",levels(i$bins))] <- "Total"
  
  return(i)
}

# Retrieve the data from the Dutch data folder
csv_files <- list.files(path = "./data/nl", pattern = "*.csv", full.names = TRUE)
data_list <- csv_files %>% map(read_csv)
names(data_list) <- gsub("\\.csv$", "", basename(csv_files))

# The variable types need to be converted to factors for the translation to work!!
cols <- c("geografie", "geslacht", "migratieachtergrond", "huishouden", "bins", "uitkomst", "type", "opleiding_ouders")

translate_mutate_cols <- function(df) {
  df <- df %>%  mutate_at(cols, factor)
  df <- translate_en(df)
}

data_list <- data_list %>% map(translate_mutate_cols)

write_to_csv <- function(data) {
  for (name in names(data_list)) {
    write_csv(data_list[[name]], file.path("./data/en/", paste0(name, ".csv")))
  }
}

write_to_csv(data_list)
