library(readxl)
library(tidyverse)
library(openxlsx)

gemeenten_alfabetisch_2023 <- read_excel("gemeenten alfabetisch 2023.xlsx", 
                                         sheet = "Gemeenten_alfabetisch")

prov_gem <- gemeenten_alfabetisch_2023 %>% select(Gemeentenaam, Provincienaam) %>%
  group_by(Provincienaam) %>% reframe(Gemeentenaam = Gemeentenaam) %>% arrange(Provincienaam)

write.xlsx(prov_gem, "prov_gem.xlsx")