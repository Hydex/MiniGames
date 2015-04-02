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
    var lfs = 0, i = 0
    var lc = 0
    var r = UInt32(0)
    var fly = NSTimer(), bon = NSTimer()
    var pg = CGFloat(-5)
    var pk = CGFloat(2)
    var pgr = 0
    var rand = 0, tr = false
    var n : Array<Int> = [], nr : Array<Bool> = [false], btn: Array<NSButton> = []
    
    @IBOutlet weak var ball: NSButton!
    @IBOutlet weak var lin: NSBox!
    @IBOutlet weak var bita: NSButton!
    @IBOutlet weak var sb: NSButton!
    @IBOutlet weak var stb: NSButton!
    @IBOutlet weak var bigbita: NSButton!
    @IBOutlet weak var smallbita: NSButton!
    @IBOutlet weak var grav: NSButton!
    @IBOutlet weak var ender: NSTextField!
    @IBOutlet weak var light: NSButton!
    @IBOutlet weak var tech: NSButton!
    @IBOutlet weak var inv: NSButton!
    @IBOutlet weak var wind: NSButton!
    @IBOutlet weak var ran: NSButton!
    
    @IBAction func stb(sender: AnyObject) {
        if (stb.title == "Stop") {
            pg = CGFloat(g)
            pk = CGFloat(k)
            pgr = n[3]
            stb.title = "Resume"
            g = 0
            k = 0
            n[3] = 1001
        }
        else {
            stb.title = "Stop"
            g = pg
            k = pk
            n[3] = pgr
            nr[3] = true
        }
    }
    
    @IBAction func sb(sender: AnyObject) {
        g = CGFloat(-5)
        k = CGFloat(2)
        stb.title = "Stop"
        sb.enabled = false
    }
    
    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSRightArrowFunctionKey:
                if (nr[6]) {
                    if (bita.frame.minX > 70) {
                        bita.frame.origin.x = CGFloat(bita.frame.origin.x - 70)
                    }
                } else {
                    bita.frame.origin.x += 69
                }
        case NSLeftArrowFunctionKey:
            if (bita.frame.origin.x > 0) {
                if (nr[6]) {
                    bita.frame.origin.x += 69
                } else {
                    bita.frame.origin.x -= 69
                }
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
        bonalign(btn[rand])
    }
    
    func checkobj(sender: NSButton) {
        if ((ball.frame.maxX > sender.frame.minX) && (sender.frame.maxX > ball.frame.minX) && (sender.frame.maxY > ball.frame.minY) && (sender.frame.minY < ball.frame.maxY)) {
            tr = true
        }
        if (tr) {
            backalign(sender)
            nr[sender.tag] = true
        }
    }
    
    
    func backalign(sender: NSButton) {
        sender.hidden = true
        sender.frame.origin.x = CGFloat(100)
        sender.frame.origin.y = CGFloat(11)
        tr = false
    }
    
    
    func timefunc(sender: NSButton) {
        var t = sender.tag
        if (nr[t])&&(n[t]<1001) {
            n[t]++
            switch t {
            case 3:
               g = CGFloat(g - 0.275)
            case 4:
               g = CGFloat(10)
            case 5:
                if ((ball.frame.minY) < CGFloat(2 + ball.frame.maxY)) {
                    bita.frame.origin.x = ball.frame.midX - (bita.frame.width / CGFloat(arc4random_uniform(30)))
                } else {
                    bita.frame.origin.x = ball.frame.midX - (bita.frame.width / 3)
                }
            case 7:
                if (((Double(n[t]) / Double(100)) - (Double(n[t]) / Double(100))) < 0.2) {
                    g = CGFloat(g*2)
                } else {
                    g = CGFloat(g/2)
                }
            default:
                break
            }
        } else {
            if (t == 4) {
                g = CGFloat(5)
            }
            nr[t] = false
            n[t] = 0
        }
        
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
        for (i=3; i < 9; i++) {
            checkobj(btn[i])
        }
        
        timefunc(inv)
        timefunc(grav)
        timefunc(tech)
        
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
            timefunc(light)
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
        for (i = 0; i<9; i++) {
            nr.append(false)
            n.append(0)
            btn.append(bigbita)
        }
        btn[2] = smallbita
        btn[3] = grav
        btn[4] = light
        btn[5] = tech
        btn[6] = inv
        btn[7] = wind
        btn[8] = ran
        fly = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: sel, userInfo: nil, repeats: true)
        bon = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: select, userInfo: nil, repeats: true)
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
