library(yfinance)
test75=get_bs(c('AVTR','AAPL'),report_type = "quarterly")

library(dplyr)
test76 = test75 %>% group_by((ticker)) %>% slice_max(date)


dataOG = getQuote(c('AVTR','AAPL'),
                  what=yahooQF(c("Symbol","Name","Ask", "Market Capitalization","Earnings/Share","P/E Ratio",
                                 "Shares Outstanding")))


test77 = inner_join(dataOG,test76,by = c("Symbol" = "ticker"))

?get_cf

test = get_financials('AAPL',report_type = "quarterly")
write.csv(test,"test.csv")

library(alphavantager)

tq_get("AAPL", get = av_get(av_fun = "OVERVIEW"))
