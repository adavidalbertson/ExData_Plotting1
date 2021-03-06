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

par(col = 'black', pty = 's', mar = c(2, 4, 2, 2), mfrow = c(2, 2))

with(hpc, plot(
    x = Date_time,
    y = Global_active_power,
    type = 'l',
    ylab = 'Global active power (kW)',
    xlab = ''
))

with(hpc, plot(
    x = Date_time,
    y = Voltage,
    type = 'l',
    xlab = ''
))

with(hpc, plot(
    x = Date_time,
    y = Sub_metering_1,
    type = 'l',
    ylab = 'Energy sub metering (Wh)',
    xlab = ''
))

with(hpc, lines(
    x = Date_time,
    y = Sub_metering_2,
    col = 'red'
))

with(hpc, lines(
    x = Date_time,
    y = Sub_metering_3,
    col = 'blue'
))

legend(
    x = 'topright',
    legend = names(hpc)[6:8],
    lwd = 1,
    col = c('black', 'blue', 'red'),
    cex = 0.5,
    bty = 'n'
)

with(hpc, plot(
    x = Date_time,
    y = Global_reactive_power,
    type = 'l',
    ylab = 'Global reactive power (kW)',
    xlab = ''
))

dev.copy(png, file = 'plot4.png', width = 480, height = 480)
dev.off()