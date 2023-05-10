library(tidyverse)
library(tidyquant)
library(yfinance)
options(scipen = 100)

################All Data########

data <- read.csv("Data/stock500_raw.csv")

data[1] <- NULL

PB_Ratio <- data$Market.Capitalization / data$netTangibleAssets
BookPrice <- data$netTangibleAssets / data$Shares.Outstanding
CurrentRatio <- data$totalCurrentAssets / data$totalCurrentLiabilities
NetCurrentRatio <- data$totalCurrentAssets / data$totalLiab
Beta <- data$Beta 
allStocks <- cbind(data, PB_Ratio, BookPrice, CurrentRatio, NetCurrentRatio)
allStocks$P.E.Ratio[is.na(allStocks$P.E.Ratio)] <- -1

allStocks <- relocate(allStocks, "Price/Book Ratio" = PB_Ratio, .after = 1)
allStocks <- relocate(allStocks, CurrentRatio, .after = 2)
allStocks <- relocate(allStocks, NetCurrentRatio, .after = 3)
allStocks <- relocate(allStocks, P.E.Ratio, .after = 4)
allStocks <- relocate(allStocks, Ask, .after = 5)
allStocks <- relocate(allStocks, BookPrice, .after = 6)
allStocks <- relocate(allStocks, Beta, .after = 7)
allStocks <- relocate(allStocks, Name, .after = 8)



write.csv(allStocks, "Data/stocks_500.csv")

allStocksFiltered <- filter(allStocks, allStocks$`Price/Book Ratio` > 0 &
                          allStocks$`Price/Book Ratio` < .6666666 &
                          (allStocks$CurrentRatio > 2 |
                          allStocks$CurrentRatio < 0) & 
                            allStocks$P.E.Ratio < 15)




write.csv(allStocksFiltered, "Data/stocks_500_filtered.csv")
