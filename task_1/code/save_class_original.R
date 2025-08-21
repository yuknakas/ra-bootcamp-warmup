# loading libraries
library("tidyverse")
library("readxl")
library("labelled")

# defining paths
path_raw <- "data/raw/学級数"
path_out <- "data/original"

# making a df list
df_list <- 
  list.files(path_raw, full.names = TRUE) %>% 
  map(read_excel) %>% 
  map(
    \(df){
      n_class <- ncol(df) - 2
      df <- set_names(
        df,
        c("prefecture", "total", 0:(n_class - 1))
        )
      base_label <- 
        list(
          prefecture = "Name of Prefecture",
          total = "Total Numbr of Schools in Prefecture"
        )
      class_label <- 
        setNames(
          paste0("NO. of Schools with ", 0:(n_class - 1), " class(es)"),
          0:(n_class - 1)
        )
      var_label(df) <- c(base_label, class_label)
      df
      }
  )

saveRDS(df_list, file = file.path(path_out, "10y_list.rds"))