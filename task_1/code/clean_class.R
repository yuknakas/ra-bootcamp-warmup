# loading libraries
library("tidyverse")

# defining paths
path_src <- "data/original/10y_list.rds"
path_out <- "data/cleaned/class_sum.rds"

# read the RDS file saved beforehand
df_list <- readRDS(path_src)

# rename the title of the df
names(df_list) <- 
  map_chr(
    df_list,
    \(df) {
      wareki <- df[1, 1]
      year_nbr <- as.numeric(str_extract(wareki, "\\d+"))
      if (str_sub(wareki, 1, 2) == "平成") {
        as.character(1989 + year_nbr)
      } else if (str_sub(wareki, 1, 2) == "令和") {
        as.character(2019 + year_nbr)
      } else {
        as.character(NA)
      }
    }
    )

# removing unnecessary rows and binding them
df_class <- df_list %>% 
  map(\(df) {
    n_class <- ncol(df) - 1
    df <- df[-1, -2] %>% 
    mutate(
      prefecture = as.character(prefecture),
      pref_id = as.numeric(row_number()),
      across('0':n_class, as.numeric)
      )
  }) %>% 
  bind_rows(.id = "year") %>% 
  relocate(pref_id, .before = year) %>% 
  arrange(pref_id, year)

class_cols <- as.character(0:(n_class - 2))

df_sum <- df_class %>%
  rowwise() %>%
  mutate(
    total_classes = sum(
      c_across(all_of(class_cols)) * as.numeric(class_cols),
      na.rm = TRUE
    )
  ) %>%
  ungroup()

# saveRDS(df_sum, path_out)