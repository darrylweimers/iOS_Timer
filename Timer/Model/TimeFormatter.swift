//
//  TimeFormat.swift
//  Achiever
//
//  Created by Darryl Weimers on 28/10/2017.
//  Copyright © 2017 DarrylWeimers. All rights reserved.
//

import Foundation

struct Separators{
    
    var hourSeparator:String
    var minuteSeparator:String
    var secondSeparator:String
    
    init(hour:String,minute:String,second:String) {
        self.hourSeparator = hour
        self.minuteSeparator = minute
        self.secondSeparator = second
    }
    
}

class TimeFormatter{
    
    
    // Convert to  hour, minute, seconds
    // max of int 2147483647
    // equivalent to number of hours: 596523.2352778
    private class func convertToHourMinutesSeconds(seconds:Int) -> (hours:Int, minutes:Int, seconds:Int){
        
        let h = Int(seconds) / 3600
        let m = Int(seconds) / 60 % 60
        let s = Int(seconds) % 60
        
        return (h,m,s)
    }
    
    // reply if single digit is sufficient for hour, minute or second
    private class func isSingleDigit(timeComponent:Int) -> Bool{
        
        if timeComponent <= 9 {
            return true
        }else {
            return false
        }
    }
    
    
    private class func getFormatSpecifier(timeComponent:Int) -> String{
        
        if isSingleDigit(timeComponent: timeComponent) == true{
            return "%d"
        }else {
            return "%02d"
        }
    }
    
    private class func getTimeFormatSpecifier(seconds:Int) -> (timeFormatSpecifier:String, numberOfComponents:Int){
        
        let time = convertToHourMinutesSeconds(seconds: seconds)
        var timeFormat: String = ""
        let symbolFormat:String = "%@"      // to hold Hour, Minutes, Second symbol e.g  1 H 40 M 3 S
        var numberOfComponents = 0
        
        if time.hours > 0 {
            timeFormat += getFormatSpecifier(timeComponent: time.hours)
            timeFormat += symbolFormat
            numberOfComponents += 1
        }
        
        if time.minutes > 0 {
            timeFormat += getFormatSpecifier(timeComponent: time.minutes)
            timeFormat += symbolFormat
            numberOfComponents += 1
        }
        
        timeFormat += getFormatSpecifier(timeComponent: time.seconds)
        timeFormat += symbolFormat
        numberOfComponents += 1
        
        return (timeFormat,numberOfComponents)
    }
    
    
    class func formatTime(seconds:Int, separators: Separators) -> String{
        
        
        let time = convertToHourMinutesSeconds(seconds: seconds)
        
        let formatInfo = getTimeFormatSpecifier(seconds: seconds)
        
        switch (formatInfo.numberOfComponents)
        {
            
        case 1:
            return String(format:formatInfo.timeFormatSpecifier, time.seconds, separators.secondSeparator)
            
        case 2:
            return String(format:formatInfo.timeFormatSpecifier, time.minutes, separators.minuteSeparator, time.seconds, separators.secondSeparator)
            
        case 3:
            return String(format:formatInfo.timeFormatSpecifier, time.hours, separators.hourSeparator, time.minutes, separators.minuteSeparator, time.seconds, separators.secondSeparator)
            
        default:
            return ""
            
        }
        
        
    }
    
}

