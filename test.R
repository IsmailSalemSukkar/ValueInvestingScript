#Attempt to use alphavantage
#APIKEY = 6Q43TQDW8RR12XZT
library(alphavantager)
av_api_key("6Q43TQDW8RR12XZT")



test = av_get(symbol = "AAPL",av_fun = "BALANCE_SHEET",
              outputsize = "full",datatype="json")



test = av_get(symbol = c("MSFT","AAPL"), av_fun = "OVERVIEW")
