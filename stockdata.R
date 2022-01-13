library(tidyverse)
library(tidyquant)
library(yfinance)

################All Data########

data = read.csv("stock_raw.csv")

PB_Ratio = data$Market.Capitalization / data$netTangibleAssets
InversePE = 1/data$P.E.Ratio
BookPrice = data$netTangibleAssets / data$Shares.Outstanding

dataF = cbind(data,PB_Ratio,InversePE,BookPrice)


dataF = relocate(dataF,"Price/Book Ratio" = PB_Ratio, .after = 4)
dataF = relocate(dataF,"P.E.Ratio", .after = 5)
dataF = relocate(dataF,"Inverse P/E Ratio" =InversePE, .after = 6)
dataF = relocate(dataF,BookPrice, .after = 7)



write.csv(dataF, "stocks_all.csv")

dataFinal = filter(dataF, dataF$`Price/Book Ratio` > 0 & 
                     dataF$`Price/Book Ratio` < 1 & dataF$Earnings.Share>0)



write.csv(dataFinal, "stocks_filtered.csv")




#####US Only####

stock1 = tq_exchange(("NASDAQ"))
stock2 = tq_exchange(("NYSE"))
stock3 = tq_exchange(("AMEX"))

stocks = rbind(stock1,stock2,stock3)

dataFUS = filter(dataF, Symbol %in% stocks$symbol[stocks$country == "United States"])

write.csv(dataFUS,"stocks_US.csv")

dataFinalUS = filter(dataFinal, Symbol %in% stocks$symbol[stocks$country == "United States"])

write.csv(dataFinalUS, "stocks_filteredUS.csv")
