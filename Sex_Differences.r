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
## https://www.worldvaluessurvey.org/WVSContents.jsp
load("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/WVS_W5.rdata")
load("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/WVS_W6.rdata")
load("/Users/hectorbahamonde/Seafile/GGGI/Sex_Differences/WVS_data/WVS_W7.rdata")

# rename df's and remove heavy datasets
WVS_W5 = WV5_Data_r_v_2015_04_18 ; rm("WV5_Data_r_v_2015_04_18")
WVS_W6 = WV6_Data_R_v20201117 ; rm("WV6_Data_R_v20201117")
WVS_W7 = `WVS_Cross-National_Wave_7_v5_0` ; rm(`WVS_Cross-National_Wave_7_v5_0`)


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