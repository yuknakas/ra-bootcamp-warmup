# Loading one package into the library ----------------------------------------
library("tidyverse")
library("gt")
library("gtsummary")

# defining paths for easier access later on -----------------------------------
source_path <- "data/cleaned/cleaned.rds"

df <- readRDS(source_path)

# make the df for info that is grouped by year --------------------------------
df_sum <- 
  df %>% 
  group_by(year) %>% 
  summarise(
    n_absent = sum(n_absent),
    n_total = sum(n_total),
    .groups = "drop"
    ) %>% 
  mutate(rate = n_absent / n_total)

# 1 make the table for total absent student -----------------------------------
ggplot(df_sum, aes(x = factor(year), y = n_absent / 10000)) +
  geom_col() +
  labs(
    title = "図1: 不登校者数の推移（全体）",
    x = "年度",
    y = "合計不登校者数（万人）"
  )

# 2 plot the bar chart --------------------------------------------------------
ggplot(df_sum, aes(x = factor(year), y = rate * 100)) +
  geom_line(group = 1) +
  geom_point() +
  scale_y_continuous(limits = c(0, 10)) +
  labs(
    title = "図2: 不登校生徒割合の推移",
    x = "年度",
    y = "不登校割合（％）"
  )

# 3 plot the merged graph -----------------------------------------------------
scale_factor <- 250000 / 10
  # this is used to scale the bar chart to the left axis

ggplot(df_sum, aes(x = factor(year))) +
  geom_col(aes(y = n_absent), fill = "lightblue") +
  geom_line(aes(y = rate * 100 * scale_factor, group = 1)) +
  geom_point(aes(y = rate * 100 * scale_factor)) +
  scale_y_continuous(
    name = "合計不登校者数",
    sec.axis = sec_axis(~ . / scale_factor, name = "不登校割合")
    ) +
  labs(
    x = "年度",
    title = "図3: 合計不登校者数と不登校割合の推移")

# 4 make a histogram ----------------------------------------------------------
df_2022 <- # extract data for 2022
  df %>% 
  filter(year == 2022)

avg_rate <- mean(df_2022$fraction) # used for dotted line

ggplot(df_2022, aes(x = fraction * 100)) +
  geom_histogram(binwidth = 0.5) +
  geom_vline(
    xintercept = avg_rate * 100,
    linetype = "dashed",
    linewidth = 1
    ) +
  labs(
    title = "図4: 不登校割合の分布",
    x = "不登校割合（％）",
    y = "都道府県数",
    caption = "破線は平均値"
  )

# 5 make a vertical bar chart -------------------------------------------------
df_2022 <- 
  df_2022 %>% 
  mutate(
    highlight = ifelse(prefecture == "茨城", TRUE, FALSE),
    prefecture = fct_reorder(prefecture, fraction)
    )

ggplot(df_2022, aes(x = prefecture, y = fraction * 100, fill = highlight)) +
  geom_col() +
  scale_fill_manual(values = c("TRUE" = "pink", "FALSE" = "gray")) +
  coord_flip() +
  labs(
    title = "図5: 都道府県別不登校割合(2022)",
    y = "不登校割合（％）"
  ) +
  theme(legend.position = "none")


# this is my attempt to make a table using tbl_summary, which did not work ----
# table <- 
#   df %>% 
#   tbl_summary(
#     include = n_absent,
#     by = year,
#     type = list(n_absent = "continuous"),
#     statistic = list(all_continuous() ~ "{sum}")
#   )
