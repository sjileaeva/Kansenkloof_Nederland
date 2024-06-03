library(readxl)
# library(tidytable)

# Change wd
setwd("~/Documents/GitHub/kansenkloof_NL")
cohort_vec <- c("child_mortality", "classroom", "elementary_school", "perinatal", "high_school", "main", "students")
outcomes <- read_excel("data/nl/outcome_table.xlsx")
# cols_fact <- c("geografie", "geslacht", "migratieachtergrond", "huishouden", "bins", "opleiding_ouders", "uitkomst",
               # "type")


# bins20_tab <- tibble()
# bins10_tab <- tibble()
# bins5_tab <- tibble()
# mean_tab <- tibble()

for (cohort in cohort_vec) {
  bins20_cohort <- read_excel(paste0("~/Downloads/8151_dpsz/kansenkloof_NL/kansenkloof_", cohort, ".xlsx"), 
                              sheet = "bins20") %>% select(-c(subgroep, sd, sample)) %>% 
    mutate(migratieachtergrond = ifelse(migratieachtergrond == "Nederland", "Zonder migratieachtergrond", migratieachtergrond),
           migratieachtergrond = ifelse(migratieachtergrond == "Nederlandse Antillen (oud)", "Nederlandse Antillen", migratieachtergrond)) %>%
    inner_join(outcomes %>% select(analyse_outcome, "uitkomst_NL" = "outcome_name"), by = c("uitkomst" = "analyse_outcome")) 
  
  bins10_cohort <- read_excel(paste0("~/Downloads/8151_dpsz/kansenkloof_NL/kansenkloof_", cohort, ".xlsx"), 
                              sheet = "bins10") %>% select(-c(subgroep, sd, sample)) %>% 
    mutate(migratieachtergrond = ifelse(migratieachtergrond == "Nederland", "Zonder migratieachtergrond", migratieachtergrond),
           migratieachtergrond = ifelse(migratieachtergrond == "Nederlandse Antillen (oud)", "Nederlandse Antillen", migratieachtergrond)) %>%
    inner_join(outcomes %>% select(analyse_outcome, "uitkomst_NL" = "outcome_name"), by = c("uitkomst" = "analyse_outcome")) 
  
  bins5_cohort <- read_excel(paste0("~/Downloads/8151_dpsz/kansenkloof_NL/kansenkloof_", cohort, ".xlsx"), 
                             sheet = "bins5") %>% select(-c(subgroep, sd, sample)) %>% 
    mutate(migratieachtergrond = ifelse(migratieachtergrond == "Nederland", "Zonder migratieachtergrond", migratieachtergrond),
           migratieachtergrond = ifelse(migratieachtergrond == "Nederlandse Antillen (oud)", "Nederlandse Antillen", migratieachtergrond)) %>%
    inner_join(outcomes %>% select(analyse_outcome, "uitkomst_NL" = "outcome_name"), by = c("uitkomst" = "analyse_outcome")) 
  
  mean_cohort <- read_excel(paste0("~/Downloads/8151_dpsz/kansenkloof_NL/kansenkloof_", cohort, ".xlsx"), 
                            sheet = "mean") %>% select(-c(subgroep, sd, sample)) %>% 
    mutate(migratieachtergrond = ifelse(migratieachtergrond == "Nederland", "Zonder migratieachtergrond", migratieachtergrond),
           migratieachtergrond = ifelse(migratieachtergrond == "Nederlandse Antillen (oud)", "Nederlandse Antillen", migratieachtergrond)) %>%
    inner_join(outcomes %>% select(analyse_outcome, "uitkomst_NL" = "outcome_name"), by = c("uitkomst" = "analyse_outcome")) 

  # bins20_tab <- bind_rows(bins20_tab, bins20_cohort)
  # bins10_tab <- bind_rows(bins10_tab, bins10_cohort)
  # bins5_tab <- bind_rows(bins5_tab, bins5_cohort)
  # mean_tab <- bind_rows(mean_tab, mean_cohort)
  # setwd("data/nl")
  write_csv(bins20_cohort, paste0("data/nl/bins20_tab_", cohort, ".csv"))
  write_csv(bins10_cohort, paste0("data/nl/bins10_tab_", cohort, ".csv"))
  write_csv(bins5_cohort, paste0("data/nl/bins5_tab_", cohort, ".csv"))
  write_csv(mean_cohort, paste0("data/nl/mean_tab_", cohort, ".csv"))
}

# setwd("data/nl")
# write_rds(bins20_tab, "bins20_tab.rds")
# write_rds(bins10_tab, "bins10_tab.rds")
# write_rds(bins5_tab, "bins5_tab.rds")
# write_rds(mean_tab, "mean_tab.rds")


# Change wd
setwd("~/Documents/GitHub/kansenkloof_NL")
cohort_vec <- c("perinatal", "elementary_school")
# parents_edu_tab <- tibble()
# cols_fact <- c("geografie", "geslacht", "migratieachtergrond", "huishouden", "bins", "opleiding_ouders", "uitkomst",
#                "type")

for (cohort in cohort_vec) {
  edu_cohort <- read_excel(paste0("~/Downloads/8151_dpsz/kansenkloof_NL/kansenkloof_edu_", cohort, ".xlsx"), 
                              sheet = "education") %>% select(-c(sd, subgroep, sample)) %>% 
    mutate(migratieachtergrond = ifelse(migratieachtergrond == "Nederland", "Zonder migratieachtergrond", migratieachtergrond),
           migratieachtergrond = ifelse(migratieachtergrond == "Nederlandse Antillen (oud)", "Nederlandse Antillen", migratieachtergrond)) %>%
    inner_join(outcomes %>% select(analyse_outcome, "uitkomst_NL" = "outcome_name"), by = c("uitkomst" = "analyse_outcome")) %>% 
    relocate(geografie, geslacht, migratieachtergrond, huishouden, bins, uitkomst, 
             N, mean, parents_income,opleiding_ouders, type, uitkomst_NL)
  
  # parents_edu_tab <- bind_rows(parents_edu_tab, edu_cohort)
  
  # setwd("data/nl")
  write_csv(edu_cohort, paste0("data/nl/parents_edu_tab_", cohort, ".csv"))
}

# setwd("data/nl")
# write_rds(parents_edu_tab, "parents_edu_tab.rds")

