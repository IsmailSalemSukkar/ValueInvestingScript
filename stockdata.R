library(tidyverse)
library(tidyquant)
library(yfinance)

################All Data########

data = read.csv("stock_raw.csv")

data[1] = NULL

PB_Ratio = data$Market.Capitalization / data$netTangibleAssets
#InversePE = 1/data$P.E.Ratio
BookPrice = data$netTangibleAssets / data$Shares.Outstanding
CurrentRatio = data$totalCurrentAssets/data$totalCurrentLiabilities
NetCurrentRatio = data$totalCurrentAssets/data$totalLiab 
allStocks = cbind(data,PB_Ratio,BookPrice,CurrentRatio,NetCurrentRatio)


allStocks = relocate(allStocks,"Price/Book Ratio" = PB_Ratio, .after = 1)
allStocks = relocate(allStocks,CurrentRatio, .after = 2)
allStocks = relocate(allStocks,NetCurrentRatio, .after = 3)
allStocks = relocate(allStocks,"P.E.Ratio", .after = 4)
allStocks = relocate(allStocks,Ask, .after = 5)
allStocks = relocate(allStocks,BookPrice, .after = 6)
allStocks = relocate(allStocks,Name, .after = 7)




write.csv(allStocks, "stocks_all.csv")

allStocksFiltered = filter(allStocks, allStocks$`Price/Book Ratio` > 0 & 
                          allStocks$`Price/Book Ratio` < .6666666 &  
                          (allStocks$CurrentRatio > 2 | allStocks$CurrentRatio < 1))



write.csv(allStocksFiltered, "stocks_filtered.csv")



#####US Only####

stock1 = tq_exchange(("NASDAQ"))
stock2 = tq_exchange(("NYSE"))
stock3 = tq_exchange(("AMEX"))

stocks = rbind(stock1,stock2,stock3)

usStocks = filter(allStocks, Symbol %in% stocks$symbol[stocks$country == "United States"])

write.csv(usStocks,"stocks_US.csv")

usStocksFiltered = filter(allStocksFiltered, Symbol %in% stocks$symbol[stocks$country == "United States"])

write.csv(usStocksFiltered, "stocks_filteredUS.csv")
