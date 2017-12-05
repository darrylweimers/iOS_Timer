//
//  CircleView.swift
//  Achiever
//
//  Created by Darryl Weimers on 1/11/2017.
//  Copyright © 2017 DarrylWeimers. All rights reserved.
//
import UIKit

@IBDesignable class CircleView: UIView, DWTimerDelegate {
    
    // MARK: Timer delegate
   
    func timerDidUpdate(time:String){
        
        // Update label on the run
        timeLabel?.text = time
        
        // Redraw layout
        setNeedsDisplay()
    }
    
    // MARK: Timer controller
    func reset() {
        timer.reset()
    }
    
    func start() {
        timer.start()
        
    }
    
    func pause() {
        timer.pause()
    }
    
    func minus(seconds:Int) -> Int{
        return timer.minus(seconds: seconds)
    }
    
    func add(seconds:Int) -> Int {
        return timer.add(seconds: seconds)
    }
    
    // MARK: Private properties
    private var timeLabel:UILabel?
    private let timer: DWTimer = DWTimer()
    
    
    // MARK: Label properties
    // Get only property
    public var labelFont: UIFont? {
        didSet{
            timeLabel?.font = labelFont
        }
    }
    
    public var labelTextColor: UIColor? {
        didSet{
            timeLabel?.textColor = labelTextColor
        }
    }
    
    // MARK: Timer properties
    public var timeInSeconds:Int {
        get {
            return timer.secondsAcculumated
        }
    }
    
    // MARK: Circle Properties
    @IBInspectable
    var lineWidth: CGFloat = 20 {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    

    @IBInspectable
    var outterLineWidth: CGFloat = 2 {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    var innerLineWidth: CGFloat = 2 {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var fillColor: UIColor = UIColor.blue {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    var backgroudFillColor: UIColor = UIColor.blue.withAlphaComponent(0.3) {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var outterLineColor: UIColor = UIColor.blue.withAlphaComponent(0.7) {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    
    
    @IBInspectable
    var innerLineColor: UIColor = UIColor.blue.withAlphaComponent(0.7) {
        didSet{
            //the view needs to be refreshed
            setNeedsDisplay()
        }
    }
    
    private var radius:CGFloat {
        return bounds.width / 2
    }
    
    private var circleCenter:CGPoint {
        return CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
    }
   
    // MARK: Init
    func setup(){
        if (bounds.width != bounds.height){
            fatalError("Height must be equal to weight")
        }
        
        layer.cornerRadius = radius
        clipsToBounds = true
        backgroundColor = UIColor.clear
        
        
        // UILabel
        timeLabel = setupLabel()
        
        timer.delegate = self
        timer.start()
    }
    
    func setupLabel() ->UILabel {
        let label = UILabel(frame: CGRect.zero)
        label.frame.size.height = self.bounds.height / 3
        label.frame.size.width = self.bounds.width - ((lineWidth + outterLineWidth + innerLineWidth) * 3)
        label.center = CGPoint(x: self.bounds.width / 2, y: self.bounds.height / 2)
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.blue
        label.textAlignment = .center
        label.text = "00:00:00"
        label.font = UIFont(name: "HelveticaNeue", size: 50)
        label.numberOfLines = 1
        label.minimumScaleFactor = 0.25
        label.adjustsFontSizeToFitWidth = true
        self.addSubview(label)
        return label
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Convertion
    private func degreeToRadian(_ degree: CGFloat) -> CGFloat{
        return degree * CGFloat.pi / 180
    }
    
    
    // MARK: Draw a cicle
    private func drawCircle(radius:CGFloat, startAngle:CGFloat, endAngle:CGFloat, lineWidth: CGFloat, lineColor:UIColor){
        // Draw Background circle
        let path = UIBezierPath(arcCenter: circleCenter,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)
        path.lineWidth = lineWidth
        lineColor.setStroke()
        path.stroke()
    }
    
    // MARK: Circle Starting point
    private var fromAngle:CGFloat = 3 * .pi / 2
    
    

    override func draw(_ rect: CGRect) {
        
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi
        var actualRadius: CGFloat = 0
        
        // Outter outline
        actualRadius = radius - outterLineWidth / 2
        drawCircle(radius: actualRadius, startAngle: startAngle, endAngle:endAngle, lineWidth: outterLineWidth, lineColor:outterLineColor)
        
        // background
        actualRadius = radius - outterLineWidth - lineWidth / 2
        drawCircle(radius: actualRadius, startAngle: startAngle, endAngle:endAngle, lineWidth: lineWidth, lineColor: backgroudFillColor)
        
        // inner outline 
        actualRadius = radius - outterLineWidth - lineWidth - innerLineWidth / 2
        drawCircle(radius: actualRadius, startAngle: startAngle, endAngle:endAngle, lineWidth: innerLineWidth, lineColor: innerLineColor)
        
        // foreground 1
        let seconds:CGFloat = CGFloat(timer.secondsAcculumated % 61)
        let partition:CGFloat = seconds / 60 * 2 * .pi
        let startingAngle:CGFloat = 3 * .pi / 2
        let toAngle:CGFloat = startingAngle + partition
        
        //drawCircle(radius:radius - outterLineWidth - lineWidth / 2, startAngle: fromAngle, endAngle:toAngle, lineWidth: lineWidth - 2, lineColor: fillColor)
        //fromAngle = toAngle
    
        // foreground 2
        drawCircle(radius:radius - outterLineWidth - lineWidth / 2, startAngle: fromAngle, endAngle:toAngle, lineWidth: lineWidth - 2, lineColor: fillColor)
        
    }

    
}
