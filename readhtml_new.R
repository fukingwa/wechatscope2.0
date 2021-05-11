#!C:\Program Files\R\R-3.6.1\bin\Rscript.exe

### Read Front page
require(XML)
require(xml2)
require(rredis)
require(stringr)
require(reticulate)

Sys.setlocale(category = "LC_ALL", locale = "cht")

py_run_string("from jaraco import clipboard; x = clipboard.paste_html()")

working_path <- "C:/Users/kwfu.JMSC/Desktop/WeChat/Files/"

read_wechat_front <- function(fname, work_dir=""){
  #rawHTML <- read_html("C:/Users/kwfu.JMSC/Desktop/WeChat/wechat_front.html", fileEncoding = 'UTF-8', encoding = 'UTF-8')
#  rawHTML <- read_html(paste0(work_dir,fname), fileEncoding = 'UTF-8', encoding = 'UTF-8')
  rawHTML <- read_html(fname, fileEncoding = 'UTF-8', encoding = 'UTF-8')
  doc.html <- htmlTreeParse(rawHTML, useInternal = TRUE, encoding = 'UTF-8')
  ptitle <- unlist(xpathApply(doc.html, '//h4[@class="weui_media_title"]', xmlValue))
  url <- unlist(xpathApply(doc.html, '//h4[@class="weui_media_title"]/@hrefs'))
  url <- gsub('^[ :space: ]+|[ :space: ]+$','',url)
  url <- str_extract(url,"mp.weixin.qq.com/s\\?__biz=[^&]+?&mid=[^&]+?&idx=[^&]+&sn=[a-z0-9]+")
  date <- unlist(xpathApply(doc.html, '//p[@class="weui_media_extra_info"]', xmlValue))
  return(cbind(ptitle,url,date))
}

#redisConnect(host = '147.8.142.3', password = 'theonlytruthiknowistolook1nyour3y3s')
#redisConnect(host = '104.200.24.153', password = 'theonlytruthiknowistolook1nyour3y3s')

wd <- "E:/Wechat"

#c <- tryCatch(redisConnect(host = '104.200.24.153', password = 'theonlytruthiknowistolook1nyour3y3s', 
c <- tryCatch(redisConnect(host = '147.8.224.249', password = 'theonlytruthiknowistolook1nyour3y3s', 
                           returnRef = T, timeout = 60L),
              error = function(e) {
                cat(paste("Error: ", e, "\n"))
                NULL
              })
if (!is.null(c)) { ## go ahead only if we got a connection
  Send_url <- function(link){
#    redisConnect(host = '104.200.24.153', password = 'theonlytruthiknowistolook1nyour3y3s',
    redisConnect(host = '147.8.224.249', password = 'theonlytruthiknowistolook1nyour3y3s',
                 returnRef = T, timeout = 60L)
    redisRPush('wx_urls_new', link)
    redisClose()
  }
  
  fname <- py$x
#  fname <- commandArgs()[7]
#  print(fname)
  
  nlink <- 10
  x <- read_wechat_front(fname)
  for (l in x[1:nlink,"url"]) {Send_url(l)}
} else {
  sink(paste0(wd, "/redischeck.txt"))
  cat(print(Sys.time()), "\n")
  sink()
}
