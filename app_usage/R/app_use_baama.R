library(httr)
commit_data <- content(GET('https://api.github.com/repos/USGS-CIDA/CIDA-Viz/stats/commit_activity'))

n_wk <- length(commit_data)
gh_data <- data.frame('Date' = vector(length = n_wk), 'commits' = vector(length = n_wk))
for (i in 1:n_wk){
  gh_data$Date[i] <- as.Date(commit_data[[i]]$week+as.POSIXct('1970-01-01'))
  gh_data$commits[i] <- commit_data[[i]]$total
}


ga_data  = read.table('../data/ga_export.tsv', header = T, sep = '\t', stringsAsFactors = F)
ga_data[,1] <- as.Date(ga_data[,1], format = '%m/%d/%y')


add_axes <- function(xlim, ylim, ylabel = pretty(ylim,10), xlabel = NA, skip_top = F, skip_bot = F){
  prc_x = 0.1 # position for text relative to axes
  prc_y = 0.07
  tick_len <- 0.15
  ext_x <- c(xlim[1]-86400, pretty(xlim,3), xlim[2]+86400)
  ext_y <- c(ylim[1]-10, ylabel, ylim[2]+10)
  ylab <- c("",ylabel,"")
  if (is.na(ylabel[1])) ylab = NA
  
  if (!skip_bot) axis(side = 1, at = ext_x, labels = xlabel, tcl = tick_len)
  axis(side = 2, at = ext_y, labels = ylab, tcl = tick_len)
  if (!skip_top) axis(side = 3, at = ext_x, labels = NA, tcl = tick_len)
  axis(side = 4, at = ext_y, labels = NA, tcl = tick_len)
  x_txt <- (xlim[2] - xlim[1])*prc_x+xlim[1]
  y_txt <- ylim[2]-(ylim[2] - ylim[1])*prc_y
}




width = 5 
height = 4
l_mar = 0.35
b_mar = 0.3
t_mar = 0.02
r_mar= 0.15
gapper = 0.15 # space between panels
xlim = as.Date(c('2014-08-24', '2015-05-15'))
ylim_1 <- c(280,6000)
ylim_2 <- c(0, ylim_1[1])
ylim_3 <- c(0,170)

# panel 1 is extended data for traffic
# panel 2 is traffic data 
# panel 3 is commit activity

png('../img/usage_fig.png', res=200, width=width, height=height, units = 'in')

layout(matrix(c(1,1,2,2,2,2,3,3,3,3),ncol=1)) # 55% on the left panel
par(mai=c(0,l_mar,t_mar,0), omi = c(0,0,0,r_mar),xpd=FALSE,
    mgp = c(1.15,.05,0))

# -- plot 1 --
plot(c(0,NA),c(0,NA), type='l', 
     axes = FALSE,
     xaxs = 'i', yaxs = 'i',
     ylim=ylim_1, 
     ylab='',
     xlab='',
     xlim=xlim[1:2])

add_axes(xlim, ylim_1, ylabel = c(2500, 5000), skip_bot = T)
keep = ga_data
use_i <- which(ga_data[,2] > ylim_1[1])
use_i <- sort(c(use_i, use_i-1, use_i+2)) # get surrounding points to draw the line
lines(keep[use_i,], col = 'dodgerblue',lwd = 3)
par(xpd=NA)
# - squiggle
offset <- 5
sq_col <- 'grey40'
polygon(x = c(xlim, rev(xlim)), y = c(ylim_1[1], ylim_1[1], 0, 0), border = NA, col = 'grey90')
curve(300*sin(1/3*x)+ylim_1[1], xlim = c(as.numeric(xlim[1])-offset, as.numeric(xlim[1])+offset), n = 101, add = T, col = sq_col)
curve(300*sin(1/3*x)+ylim_1[1], xlim = c(as.numeric(xlim[2])-offset, as.numeric(xlim[2])+offset), n = 101, add = T, col = sq_col)
curve(300*sin(1/3*x)+ylim_1[1]-400, xlim = c(as.numeric(xlim[1])-offset, as.numeric(xlim[1])+offset), n = 101, add = T, col = sq_col)
curve(300*sin(1/3*x)+ylim_1[1]-400, xlim = c(as.numeric(xlim[2])-offset, as.numeric(xlim[2])+offset), n = 101, add = T, col = sq_col)
lines(rep(xlim[1],2),c(0,ylim_1[1]), col = 'black')
lines(rep(xlim[2],2),c(0,ylim_1[1]), col = 'black')
par(xpd=F)
# -- plot 2 --
plot(c(0,NA),c(0,NA), type='l', 
     axes = FALSE,
     xaxs = 'i', yaxs = 'i',
     ylim=ylim_2, 
     ylab='                 Unique visitors per day',
     xlab='',
     xlim=xlim[1:2], cex = 2)

add_axes(xlim, ylim_2, ylabel = seq(0,400,50), skip_top = T)
lines(ga_data, col = 'dodgerblue',lwd = 3)


# -- plot 3 --
par(mai=c(b_mar,l_mar,0.1,0))
plot(c(0,NA),c(0,NA), type='l', 
     axes = FALSE,
     xaxs = 'i', yaxs = 'i',
     ylim=ylim_3, 
     ylab='Code contributions per week',
     xlab='',
     xlim=xlim[1:2])

add_axes(xlim, ylim_3, ylabel = seq(0,200,50))
for (i in 1:n_wk){
  x = gh_data$Date[i]
  y = gh_data$commits[i]
  polygon(c(x-3, x+3, x+3, x-3), c(0,0,y,y), col='firebrick', border = NA)
}
dev.off()