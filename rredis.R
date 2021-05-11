#!C:\Program Files\R\R-3.2.1\bin\x64\Rscript.exe

## DON'T USE THE CRAN VERSION, use dev version.
#devtools::install_github("bwlewis/rredis")

require(rredis)

Send_url <- function(link){
  redisConnect(host = '147.8.224.249', password = 'theonlytruthiknowistolook1nyour3y3s')
#  redisConnect(host = '104.200.24.153', password = 'theonlytruthiknowistolook1nyour3y3s')
  redisRPush('wx_urls', link)
  redisClose()
}

url <- commandArgs()[7]
print(url)
Send_url(url)

#redisRPush('wx_urls', 'http://jmsc.hku.hk')
#redisLLen('wx_urls')
#redisLPop('wx_urls') # should be hku
#redisLLen('wx_urls')
#redisRPush('wx_urls', 'http://chainsawriot.com')
#redisLLen('wx_urls')
#redisLPop('wx_urls') # should be jmsc
#redisLPop('wx_urls') # chainsawriot

