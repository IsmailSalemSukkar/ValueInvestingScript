library(tidyverse)
library(tidyquant)
library(yfinance)

###Data Obtaining###
#######Pull Data from yahoo##########
stocks <- tq_index("SP500")

dataOGG <- getQuote(unique(stocks$symbol),
                    what = yahooQF(c("Name", "Ask", "Market Capitalization",
                                     "Earnings/Share", "P/E Ratio",
                                     "Price/Book", "Shares Outstanding",
                                     "Currency")))

dataOG <- rownames_to_column(dataOGG, "Symbol")

dataO <- get_bs(stocks$symbol, report_type = "quarterly")


dataOO <- dataO %>% group_by((ticker)) %>% slice_max(date)

data <- inner_join(dataOG, dataOO, by = c("Symbol" = "ticker"))

write.csv(data, "stock500_raw.csv")
