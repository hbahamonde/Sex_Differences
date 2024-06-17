cat("\014")
rm(list=ls())
setwd("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/")

# Pacman
if (!require("pacman")) install.packages("pacman"); library(pacman) 

# import data
p_load("readxl")
sex.diff.d.wide <- read_excel("/Users/hectorbahamonde/Seafile/GGGI/GGGI.xlsx")

# change variable names
p_load("dplyr")
sex.diff.wide.id.d <- sex.diff.d.wide %>% rename(
  "Country" = "Country Name",
  "ISO" = "ISO 3166-1",
  "ISO3" = "Country ISO3",
  "year2006" = "2006",
  "year2007" = "2007",
  "year2008" = "2008",
  "year2009" = "2009",
  "year2010" = "2010",
  "year2011" = "2011",
  "year2012" = "2012",
  "year2013" = "2013",
  "year2014" = "2014",
  "year2015" = "2015",
  "year2016" = "2016",
  "year2017" = "2017",
  "year2018" = "2018",
  "year2020" = "2020",
  "year2021" = "2021",
  "year2022" = "2022"
  )

# subset variables
sex.diff.d.wide = subset(sex.diff.wide.id.d, select = -c(ISO,ISO3) )
sex.diff.long.id.d = subset(sex.diff.wide.id.d, select = -c(year2006,
                                                            year2007,
                                                            year2008,
                                                            year2009,
                                                            year2010,
                                                            year2011,
                                                            year2012,
                                                            year2013,
                                                            year2014,
                                                            year2015,
                                                            year2016,
                                                            year2017,
                                                            year2018,
                                                            year2020,
                                                            year2021,
                                                            year2022) )

# reshape data
p_load(data.table)
sex.diff.d <- melt(setDT(sex.diff.d.wide), id.vars = c("Country"), variable.name = "year")

# change variable value
sex.diff.d$year <- gsub("year", "", sex.diff.d$year)

# change variable names
p_load("dplyr")
sex.diff.d <- sex.diff.d %>% rename(
  "SexDiff" = "value",
  "Year" = "year"
  )

# order
sex.diff.d = sex.diff.d[order(sex.diff.d$Country, decreasing = F),]  

# merge with sex.diff.id.d
sex.diff.d = merge(sex.diff.long.id.d, sex.diff.d, by = c("Country"))

# Import WVS data
p_load(foreign)
#  saveold wvs, replace
wvs.d <- read.csv("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/wvs.csv") # encoding = "UTF-8"

# S020 Year
# COUNTRY_NUM Country
# COUNTRY_ALPHA Country
# E069_12.- Confidence: The Political Parties
# A004.- Important in life: Politics
# A124_18.- Neighbours: Political Extremists
# D059.- Men make better political leaders than women do
# E023.- Interest in politics
# E025.- Political action: Signing a petition
# E026.- Political action: joining in boycotts
# E033.- Self positioning in political scale
# E069_12.- Confidence: The Political Parties
# E117.- Political system: Having a democratic political system

# rename WVS_W7 colnames
p_load("dplyr")
wvs.d <- wvs.d %>% rename(
  "Year" = "S020",
  "Country_Num" = "COW_ALPHA",
  "Country" = "COW_NUM",
  "politics.important" = "A004",  #Important in life: Politics
  "neig.pol.extrem" = "A124_18", # Neighbours: Political Extremists
  "men.better.pol.leaders" = "D059", # Men make better political leaders than women do
  "interested.in.politics" = "E023", # Interest in politics
  "sign.petition" = "E025", # Political action: Signing a petition
  "joining.boycotts" = "E026", # Political action: joining in boycotts
  "left.right" = "E033", # "Self positioning in political scale"
  "conf.pol.parties" = "E069_12", # Confidence: The Political Parties
  "having.dem.system" = "E117" # Political system: Having a democratic political system
  )


wvs.d$Year = as.numeric(as.character(wvs.d$Year)) 

#
p_load(dplyr)
sex.diff.d = sex.diff.d %>% arrange(Country, Year)
sex.diff.d$Year = as.numeric(as.character(sex.diff.d$Year)) 

# merge 
dat = merge(sex.diff.d, wvs.d, all = FALSE, by = c("Country", "Year"))

#
p_load(dplyr)
dat = dat %>% arrange(Country, Year)
