# Loading two packages into the library. readxl: for reading excel files
library("tidyverse")
library("readxl")

# defining paths for easier access later on
path_absent_dir <- "data/raw/不登校生徒数"
path_total <- "data/raw/生徒数/生徒数.xlsx"
path_target_dir <- "data/original/"

# fetching the name of all excel files of absent students
file_list <- list.files(path_absent_dir, full.names = TRUE)

file_name_list <- 
  list.files(path_absent_dir, full.names = FALSE) %>% 
  str_remove("年度_不登校生徒数.xlsx")

#creates a list of dfs by calling read_excel and mapping them, then renaming the vars
df_absent <- 
  file_list %>% 
  set_names(file_name_list) %>%
  # function(x) is called, returning the first 4 digit number in the absent file's name
  map(read_excel) %>% 
  map(
    \(path){
      rename(
        path,
        prefecture = 都道府県,
        n_absent = 不登校生徒数,
      )
    }
  )

# making a df from the total students and renaming the variables
df_total <- 
  read_excel(path_total) %>% 
  rename(
    prefecture = 都道府県,
    year = 年度,
    n_total = 生徒数,
  )

#saving each of the files
saveRDS(df_absent, file = file.path(path_target_dir, "absent_list.rds"))
saveRDS(df_total, file = file.path(path_target_dir, "total_data.rds"))