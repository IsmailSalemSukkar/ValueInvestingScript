library(tidyverse)
library(tidyquant)
library(yfinance)

###Data Obtaining###
#######Pull Data from yahoo##########
stock1 = tq_exchange(("NASDAQ"))
stock2 = tq_exchange(("NYSE"))
stock3 = tq_exchange(("AMEX"))

stocks = rbind(stock1,stock2,stock3)

dataOGG = getQuote(unique(stocks$symbol),
                   what = yahooQF(c("Name","Ask","Market Capitalization",
                                    "Earnings/Share","P/E Ratio","Price/Book", 
                                    "Shares Outstanding","Currency")))

dataOG = rownames_to_column(dataOGG, "Symbol")

dataO = get_financials(stocks$symbol,report_type = "quarterly")


dataOO = dataO %>% group_by((ticker)) %>% slice_max(date)

data = inner_join(dataOG,dataOO,by = c("Symbol" = "ticker"))

write.csv(data,"stock_raw.csv")



#######
###Data Obtaining###
#######Single Stocks##########



