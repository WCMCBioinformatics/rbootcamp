
library(tidyverse)
library(stringr)

fpkm = read_csv("../datasets/stratton_fpkm.csv")

glimpse(fpkm)

# Let's get rid of X9 and X13, these are averages
fpkm = fpkm %>% select(-X9, -X13)

# and pull out the "Blood Aged" column, but we'll keep this in case we need it later
blood = fpkm %>% select(`Blood Aged`)
fpkm = fpkm %>% select(-`Blood Aged`)


# Now we can get rid of the first row
fpkm = fpkm %>% slice(-1)

# Now we need to extract our variable information from the column names
col_names = colnames(fpkm)[-1]

# get the day variable
day = str_extract(col_names, "day_\\d+")

# now the age variable
age = str_extract(col_names, "young|aged")

# we'll need a sample_ID variable for later
sample_ID = paste0("S", 1:length(age))

# we'll create a new dataframe to hold our sample information, including a sample ID variable
samples = data_frame(day, age, sample_ID)

# now we rename our columns with the new sample ID, and renaming our gene column at the same time
colnames(fpkm) = c("gene", sample_ID)


# Now for the grand finale, joining the tables, first gathering the sample columns in the fpkm table and converting the expression column to numeric

fpkm = fpkm %>% gather(sample_ID, expression, -gene) %>% mutate(expression = as.numeric(expression))
final = left_join(samples, fpkm)

# Tada!