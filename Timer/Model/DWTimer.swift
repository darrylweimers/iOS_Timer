//
//  WTimer.swift
//  Achiever
//
//  Created by Darryl Weimers on 15/10/2017.
//  Copyright © 2017 DarrylWeimers. All rights reserved.
//

import Foundation
import UIKit


protocol DWTimerDelegate {
    
    func timerDidUpdate(time:String)
}


class DWTimer {
    
    
    // MARK: Private properties
    private var timer: Timer?
    private let tick:TimeInterval = 1
    private var seconds: Int = 0
    
    // MARK: Public properties
    public var secondsAcculumated: Int  {
        get {
            return seconds
        }
    }
    
    // MARK: Delegate
    var delegate: DWTimerDelegate?
    
    // MARK: Event 
    @objc func timerUpdate(){
        // Update time
        self.seconds += 1
    
        // format time
       
        //let timeFormatted = formatTime(seconds: t, separators: .init(hour: " H ", minute: " M ", second: " S"))
        
        let separators: Separators = Separators(hour: " H ", minute: " M ", second: " S")
        let timeFormatted = TimeFormatter.formatTime(seconds: self.seconds, separators: separators)
        
        self.delegate?.timerDidUpdate(time:timeFormatted)
    }
    
    // MARK: controls
    
    func reset() {
        self.seconds = 0
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: tick, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
    }
    
    func pause() {
        timer?.invalidate()
    }
    
    func minus(seconds:Int) -> Int{
        if seconds < self.seconds {
            return self.seconds - seconds
        }else {
            return 0
        }
    }
    
    func add(seconds:Int) -> Int {
        // if greater than absolute max fatal error
        return self.seconds + seconds
    }
}
