#Attempt to use alphavantage
#APIKEY = 6Q43TQDW8RR12XZT
#library(alphavantager)
#av_api_key("6Q43TQDW8RR12XZT")
stock1 = tq_exchange(("NASDAQ"))
stock2 = tq_exchange(("NYSE"))
#stock3 = tq_exchange(("AMEX"))

stocks = rbind(stock1,stock2)
stocks = filter(stocks, stocks$country == "United States")

library(httr)
base_url <- "https://www.alphavantage.co"
myquery <- list("function"="BALANCE_SHEET",
                "symbol" = stocks$symbol,
                "apikey"="6Q43TQDW8RR12XZT") # Remember to fill in your key

resp = GET(base_url, path = "query", query = myquery)
jsonRespParsed<-content(resp,as="parsed") 
View(as.data.frame(jsonRespParsed))

fromJSON(jsonRespText)
modJson<-jsonRespParsed$data #. Access data element of whole list and ignore other vectors
modJson

test = av_get(symbol = "AAPL",av_fun = "BALANCE_SHEET",
              outputsize = "full",datatype="json")



test = av_get(symbol = c("MSFT","AAPL"), av_fun = "OVERVIEW")
