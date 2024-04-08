getwd()
dir()
setwd("C:/Users/Samsung/OneDrive/Área de Trabalho/scripts-r")

help.search('arithmetic mean')
?? 'arithmetic mean'
RSiteSearch('arithmetic mean')


temp1 <- 25.5
26.9 -> temp2
temp3 = 30.2
assing("temp4", 20.5)

(temp5 <- 19.6)

temp1

print(temp1)

temp1; temp2; temp3; temp5

ls()
remove(temp1)
ls()
rm(temp2)
ls()
remove(list = ls())
ls()



seq(from=1, to=10)
seq(from=0, to=100, by=10)
seq(from=10, to=1, by=-1)

rep(x=2, times=10)
rep(x=1:5, times=3)
rep(x=1:5, each=3)
rep(x=1:3, times=1:3)
rep(FALSE, 3)
rep(seq(0,10,2),3)


(vn <- c(2,3,6,9))
is.vector(vn)
class(vn)
length(vn)

(vc <- c('a', 'b', 'c', 'd'))
is.vector(vn)
class(vc)
length(vc)

mtx_f <-
  matrix(
    c(2,3,6,9,10,12),
    nrow = 3,
    ncol = 2,
    byrow = TRUE
  )
mtx

mtx_f <-
  matrix(
    c(2,3,6,9,10,12),
    nrow = 3,
    ncol = 2,
    byrow = FALSE
  )
mtx_f

dim(mtx)
is.matrix(mtx)

(df <- data.frame (vn, vc))

dim(df)
ncol(df)
nrow(df)
names(df)
str(df)







