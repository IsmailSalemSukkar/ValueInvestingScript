library(tidyverse)
library(tidyquant)
library(yfinance)


dataOGG = getQuote(AAPL,
                   what = yahooQF(c("Name","Ask","Market Capitalization",
                                    "Earnings/Share","P/E Ratio","Price/Book", 
                                    "Shares Outstanding")))

dataOG = rownames_to_column(dataOGG, "Symbol")

dataO = get_bs(stocks$symbol,report_type = "quarterly")


dataOO = dataO %>% group_by((ticker)) %>% slice_max(date)

data = inner_join(dataOG,dataOO,by = c("Symbol" = "ticker"))

write.csv(data,"custom_stock_raw.csv")