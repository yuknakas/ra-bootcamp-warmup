# Loading one package into the library
library("tidyverse")

# defining paths for easier access later on
path_absent_rds <- "data/original/absent_list.rds"
path_total_rds <- "data/original/total_data.rds"
target_result <- "data/cleaned/cleaned.rds"

# reading the rds files
df_absent_list <- readRDS(path_absent_rds)
df_total <- readRDS(path_total_rds)

# removing the blank lines
df_absent_list <- df_absent_list %>% 
  map(select, -blank) # remove the blank column

# combining the data and correcting the data type
df_absent <- bind_rows(df_absent_list, .id = "year") %>% 
  mutate(
    n_absent = as.numeric(n_absent),
    year = as.numeric(year),
  )

# correcting the data type
df_total <- df_total %>% 
  mutate(
    n_total = as.numeric(n_total),
    year = as.numeric(year),
  )

#connecting the df, then reordering the header
df <- df_absent %>% 
  left_join(df_total, by = c("year", "prefecture")) %>% 
  select("prefecture", "year", "n_total", "n_absent") %>% 
  mutate(fraction = n_absent / n_total)

saveRDS(df, file = target_result)