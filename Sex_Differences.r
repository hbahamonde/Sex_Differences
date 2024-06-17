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
wvs.d <- read_dta("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/wvs.dta") # encoding = "UTF-8"

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

p_load(tidyverse)
wvs.ts.d = wvs.ts.d %>%  select(
  V1, V2, V7, V61, V95, V96, V97, V114, V139, V151) # V43_07



## https://www.worldvaluessurvey.org/WVSContents.jsp
p_load(foreign)
#  saveold WVS7, replace  version(12)
WVS_W5 <- read_dta("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/WVS5.dta")
WVS_W6 <- read_dta("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/WVS6.dta", encoding = "UTF-8")
WVS_W7 <- read.dta("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/WVS7.dta")

# assign labels
p_load(haven)
WVS_W5 <- haven::as_factor(WVS_W5, levels="labels"); names(WVS_W5) <- paste0(names(WVS_W5), "_label")
WVS_W6 <- haven::as_factor(WVS_W6, levels="labels"); names(WVS_W6) <- paste0(names(WVS_W6), "_label")

# remove "label" from col names
names(WVS_W5) <- sub("_label", "", names(WVS_W5))
names(WVS_W6) <- sub("_label", "", names(WVS_W6))

# ls()
rm(`sex.diff.d.wide`)
rm(`sex.diff.long.id.d`)
rm(`sex.diff.wide.id.d`)

# Questions to keep from the WVS
## V7 Politics important
## V43_07 Neighbours: Political Extremists
## V61 Men make better political leaders
## V95 Interested in politics
## V96 Political action: signing a petition
## V97 Political action: joining in boycotts
## V114 Self positioning in political scale
## V139 Confidence: The Political Parties
## V151 Having a democratic political system

p_load(tidyverse)
WVS_W5 = WVS_W5 %>%  select(V1, V2, V7, V61, V95, V96, V97, V114, V139, V151) # V43_07
WVS_W6 = WVS_W6 %>%  select(V1, V2, V7, V61, V95, V96, V97, V114, V139, V151) # V43_07
WVS_W7 = WVS_W7 %>%  select(A_YEAR, B_COUNTRY , Q7, Q61, Q95, Q96, Q97, Q114, Q139, Q151) # Q43_07

# rename WVS_W7 colnames
p_load("dplyr")
WVS_W7 <- WVS_W7 %>% rename(
  "V1" = "A_YEAR",
  "V2" = "B_COUNTRY",
  "V7" =  "Q7" , 
  "V61" =  "Q61" , 
  "V95" =  "Q95" , 
  "V96" =  "Q96" , 
  "V97" =  "Q97" , 
  "V114" =  "Q114" , 
  "V139" =  "Q139" , 
  "V151" = "Q151"
  )

# append all df's
p_load(dplyr)
wvs.d = dplyr::bind_rows(WVS_W5, WVS_W6, WVS_W7)
rownames(wvs.d) <- NULL
# table(wvs.d$V1) gives that years 2005-2007 N: 83975 obs. Next are 
# individual years with data available between 2017 and 2023.
# I will drop everything else to have individual-year data to merge with the sex.diff.d
wvs.d  = wvs.d %>% filter(V1 == 2017 | V1 == 2018  | V1 == 2019 | V1 == 2019 | V1 == 2020 | V1 == 2021 | V1 == 2022 | V1 == 2023 )

p_load(dplyr)
wvs.d <- wvs.d %>% rename("Country" = "V2",
                          "Year" = "V1",
                          #
                          "politics.important" = "V7", # Politics is important
                          "men.better.pol.leaders" = "V61", ## V61 Men make better political leaders
                          "interested.in.politics" = "V95", #  Interested in politics
                          "sign.petition" = "V96", ## V96 Political action: signing a petition
                          "joining.boycotts" =  "V97", # ## V97 Political action: joining in boycotts
                          "left.right" = "V114", ## V114 Self positioning in political scale
                          "conf.pol.parties" =  "V139", ## V139 Confidence: The Political Parties
                          "having.dem.system" = "V151" ## V151 Having a democratic political system
                          )

wvs.d$Year = as.numeric(as.character(wvs.d$Year)) 

#
p_load(dplyr)
sex.diff.d = sex.diff.d %>% arrange(Country, Year)
sex.diff.d$Year = as.numeric(as.character(sex.diff.d$Year)) 

# merge 
dat = merge(sex.diff.d, wvs.d, by = c("Country", "Year"))

