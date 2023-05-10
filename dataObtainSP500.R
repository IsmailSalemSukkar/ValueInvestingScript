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

dataO <- get_bs(stocks$symbol)

dataOO <- dataO %>% group_by((ticker)) %>% slice_max(date)



data <- inner_join(dataOG, dataOO, by = c("Symbol" = "ticker"))



######Beta Calculation####
Market <- as.data.frame(getSymbols("^GSPC", auto.assign=FALSE))
Market <- cbind(Date = rownames(Market), Market)

betaCalc <- data.frame(matrix(ncol=2,nrow=0))
colnames(betaCalc) <- c("Symbol","Beta")

for (i in stocks$symbol) {
  Stock <- as.data.frame(getSymbols(i, auto.assign=FALSE))
  Stock <- cbind(Date = rownames(Stock), Stock)
  joinedStocks <- inner_join(Stock, Market, by = c("Date"))
  marketReturn <- diff(log(joinedStocks$GSPC.Adjusted))
  stockReturn <- diff(log(joinedStocks[,paste0(i,".Adjusted")]))
  fit <- lm(stockReturn~marketReturn)
  beta = fit$coefficients[2]
  append_row <- cbind(i,beta)
  colnames(append_row) <- c("Symbol","Beta")
  betaCalc <- rbind(betaCalc,append_row)
}


data <- inner_join(data, betaCalc, by= c("Symbol"))


write.csv(data, "Data/stock500_raw.csv")
setwd("../")


getwd()
