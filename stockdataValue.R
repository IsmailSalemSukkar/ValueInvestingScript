library(tidyverse)
library(tidyquant)
library(yfinance)
options(scipen = 999)

################All Data########

data = read.csv("stock_test_raw.csv")

data[1] = NULL

#InversePE = 1/data$P.E.Ratio
BookPrice = data$netTangibleAssets / data$Shares.Outstanding
NetBookPrice = (data$totalCurrentAssets - data$totalLiab) / data$Shares.Outstanding
CurrentRatio = data$totalCurrentAssets/data$totalCurrentLiabilities
NetCurrentRatio = data$totalCurrentAssets/data$totalLiab 
PB_Ratio = data$Market.Capitalization / data$netTangibleAssets
Net_PB_Ratio = data$Market.Capitalization/(data$totalCurrentAssets - data$totalLiab)
PriceEarningRatio = data$Ask/data$Earnings.Share
NetBookPriceEarningRatio = (data$totalCurrentAssets - data$totalLiab) / (data$Earnings.Share * data$Shares.Outstanding)
allStocks = cbind(data,BookPrice,NetBookPrice,CurrentRatio,NetCurrentRatio,PB_Ratio,Net_PB_Ratio,NetBookPriceEarningRatio,PriceEarningRatio)


allStocks = relocate(allStocks,Ask, .after = 1)
allStocks = relocate(allStocks,BookPrice, .after = 2)
allStocks = relocate(allStocks,NetBookPrice, .after = 3)
allStocks = relocate(allStocks,CurrentRatio, .after = 4)
allStocks = relocate(allStocks,NetCurrentRatio, .after = 5)
allStocks = relocate(allStocks,"Price/Book Ratio" = PB_Ratio, .after = 6)
allStocks = relocate(allStocks,"Net Price/Book Ratio" = Net_PB_Ratio, .after = 7)
allStocks = relocate(allStocks,PriceEarningRatio, .after = 8)
allStocks = relocate(allStocks,NetBookPriceEarningRatio, .after = 9)
allStocks = relocate(allStocks,Name, .after = 10)






write.csv(allStocks, "stocks_all.csv")

allStocksFiltered = filter(allStocks, 
                             allStocks$`Net Price/Book Ratio` > 0 & 
                             allStocks$`Net Price/Book Ratio` < .75 
                             &  
                             #(allStocks$CurrentRatio > 2 | allStocks$CurrentRatio < 0) &
                             #allStocks$NetBookPrice > 0 &
                             allStocks$PriceEarningRatio > 0
                           )



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

stocksInterest = c("AESE","SSY","ACR","SOS")

portfolio = filter(allStocks, Symbol %in% 
                          stocksInterest)

write.csv(portfolio, "portfolio.csv")
