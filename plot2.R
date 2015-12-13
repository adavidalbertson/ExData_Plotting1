library(data.table)
library(dplyr)
library(lubridate)

if(!exists('hpc')) {
    if (!file.exists('household_power_consumption.txt')) {
        download.file('https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip', 
                      'household_power_consumption.zip', method='curl')
        unzip('household_power_consumption.zip')
    }
    
    
    startLine = 66638L
    endLine = 69517
    ## Don't believe me?
    # startLine <- grep('1/2/2007', readLines('household_power_consumption.txt'))[1]
    # endLine <- grep('3/2/2007', readLines('household_power_consumption.txt'))[1] - 1
    
    hpc <- fread(
        'household_power_consumption.txt',
        header = FALSE,
        skip = startLine,
        nrows = endLine - startLine,
        na.strings = '?'
    )
    
    names(hpc) <- unlist(fread(
        'household_power_consumption.txt',
        header = FALSE,
        nrows = 1,
        stringsAsFactors = FALSE
    ))
    
    hpc <- hpc %>%
        mutate(Date_time = as.POSIXct(paste(Date, Time), format="%d/%m/%Y %H:%M:%S")) %>%
        select(Date_time, Global_active_power:Sub_metering_3)
    
    rm(startLine)
    rm(endLine)
}

par(col = 'black', pty = 's', mar = c(4, 4, 2, 2), mfrow = c(1,1))

with(hpc, plot(
    x = Date_time,
    y = Global_active_power,
    type = 'l',
    ylab = 'Global active power (kilowatts)',
    xlab = ''
))

dev.copy(png, file = 'plot2.png', width = 480, height = 480)
dev.off()