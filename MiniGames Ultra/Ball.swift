//
//  ViewController.swift
//  Ball
//
//  Created by Mark Yankovskiy on 27/03/15.
//  Copyright (c) 2015 Mark Yankovskiy. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class BallGame: NSViewController {
    
    var g = CGFloat(0)
    var k = CGFloat(0)
    var lfs = 0
    var lc = 0
    var r = UInt32(0)
    var fly = NSTimer(), bon = NSTimer()
    var pg = CGFloat(-5)
    var pk = CGFloat(2)
    var rand = 0
    var tr = false, gr = true
    
    @IBOutlet weak var ball: NSButton!
    @IBOutlet weak var lin: NSBox!
    @IBOutlet weak var bita: NSButton!
    @IBOutlet weak var sb: NSButton!
    @IBOutlet weak var stb: NSButton!
    @IBOutlet weak var bigbita: NSButton!
    @IBOutlet weak var smallbita: NSButton!
    
    @IBOutlet weak var ender: NSTextField!
    
    @IBAction func stb(sender: AnyObject) {
        if (stb.title == "Stop") {
            pg = CGFloat(g)
            pk = CGFloat(k)
            stb.title = "Resume"
            g = 0
            k = 0
        }
        else {
            stb.title = "Stop"
            g = pg
            k = pk
        }
    }
    
    @IBAction func sb(sender: AnyObject) {
        g = CGFloat(-4)
        k = CGFloat(2)
        stb.title = "Stop"
        sb.enabled = false
    }
    
    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSRightArrowFunctionKey:
            if (bita.frame.origin.x < (self.view.frame.width-100)) {
                bita.frame.origin.x += 69
            }
        case NSLeftArrowFunctionKey:
            if (bita.frame.origin.x > 0) {
                bita.frame.origin.x -= 70
            }
        default:
            super.mouseDown(theEvent)
        }
    }
    
    func bonalign(sender: NSButton) {
        sender.hidden = false
        sender.frame.origin.x = CGFloat(arc4random_uniform(500) + 100)
        sender.frame.origin.y = CGFloat(arc4random_uniform(350)+100)
    }
    
    func bonfunc(timer: AnyObject?) {
        rand = Int(arc4random_uniform(8) + 1)
        switch rand {
        case 1:
            bonalign(bigbita)
        case 2:
            bonalign(smallbita)
        default:
            break
        }
    }
    
    func checkobj(sender: AnyObject) {
        if ((ball.frame.maxX > sender.frame.minX) && (sender.frame.maxX > ball.frame.minX) && (sender.frame.maxY > ball.frame.minY) && (sender.frame.minY < ball.frame.maxY)) {
            tr = true
        }
        
    }
    
    
    func backalign(sender: NSButton) {
        sender.hidden = false
        sender.frame.origin.x = CGFloat(arc4random_uniform(500) + 100)
        sender.frame.origin.y = CGFloat(arc4random_uniform(350)+100)
        tr = false
    }
    
    
    func bigbitafunc() {
        backalign(bigbita)
        bita.frame = NSRect(x: bita.frame.origin.x, y: bita.frame.origin.y, width: 175, height: bita.frame.height)
    }
    
    func smallbitafunc() {
        backalign(smallbita)
        bita.frame = NSRect(x: bita.frame.origin.x, y: bita.frame.origin.y, width: 75, height: bita.frame.height)
    }
    
    func flyfunc(timer : NSTimer) {
        
        checkobj(bigbita)
        if (tr) {
            bigbitafunc()
        }
        checkobj(smallbita)
        if (tr) {
            smallbitafunc()
        }
        
        if (gr) {
          g = CGFloat(g - 0.125)
        }
        
        lin.frame.size = CGSize(width: self.view.frame.width, height: lin.frame.origin.y-65)
        bita.frame.origin.y = 60
        lin.frame.origin.y = 70
        sb.frame.origin.y = 9
        stb.frame.origin.y = 9
        sb.frame.origin.x = (self.view.frame.width - 120)
        stb.frame.origin.x = (self.view.frame.width - 230)
        if (ball.frame.origin.y > (self.view.frame.height-29)) {
            g = CGFloat(-g)
        }
        if ((bita.frame.minX < ball.frame.maxX)&&(bita.frame.maxX > ball.frame.minX)&&(bita.frame.maxY > ball.frame.minY)) {
            g = CGFloat(4)
            k = CGFloat(-((bita.frame.origin.x+((bita.frame.width)/3)-ball.frame.origin.x)/3.5))
        }
        if ((ball.frame.origin.x)<0)||((ball.frame.origin.x+39) > self.view.frame.width) {
            k = CGFloat(-k)
        }
        if ((ball.frame.origin.y)<65) {
            ball.frame.origin.x = self.view.frame.width / 2
            ball.frame.origin.y = self.view.frame.height / 2
            k = 0
            g = 0
            sb.enabled = true
            
        }
        ball.frame.origin.y = ball.frame.origin.y + CGFloat(g)
        ball.frame.origin.x = ball.frame.origin.x + CGFloat(k)
    }
    
    var sel = Selector("flyfunc:")
    var select = Selector("bonfunc:")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fly = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: sel, userInfo: nil, repeats: true)
        bon = NSTimer.scheduledTimerWithTimeInterval(3.0, target: self, selector: select, userInfo: nil, repeats: true)
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
