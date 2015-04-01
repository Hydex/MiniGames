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
    var pgr = 0
    var rand = 0
    var tr = false, gr = false, techr = false, lightr = false, invr = false
    var grn = 0, techn = 0, lightn = 0, invn = 0
    
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
    
    @IBAction func stb(sender: AnyObject) {
        if (stb.title == "Stop") {
            pg = CGFloat(g)
            pk = CGFloat(k)
            pgr = grn
            stb.title = "Resume"
            g = 0
            k = 0
            grn = 1001
        }
        else {
            stb.title = "Stop"
            g = pg
            k = pk
            grn = pgr
            gr = true
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
            if (bita.frame.origin.x < (self.view.frame.width-100)) {
                if (invr) {
                  bita.frame.origin.x -= 69
                } else {
                    bita.frame.origin.x += 69
                }
            }
        case NSLeftArrowFunctionKey:
            if (bita.frame.origin.x > 0) {
                if (invr) {
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
        switch rand {
        case 1:
            bonalign(bigbita)
        case 2:
            bonalign(smallbita)
        case 3:
            bonalign(grav)
        case 4:
            bonalign(light)
        case 5:
            bonalign(tech)
        case 6:
            bonalign(inv)
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
        sender.hidden = true
        sender.frame.origin.x = CGFloat(100)
        sender.frame.origin.y = CGFloat(11)
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
    func gravfunc() {
        backalign(grav)
        gr = true
    }
    func lightfunc() {
        backalign(light)
        lightr = true
    }
    func techfunc() {
        backalign(tech)
        techr = true
    }
    func invfunc() {
        backalign(inv)
        invr = true
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
        checkobj(grav)
        if (tr) {
           gravfunc()
        }
        checkobj(light)
        if (tr) {
           lightfunc()
        }
        checkobj(tech)
        if (tr) {
            techfunc()
        }
        checkobj(inv)
        if (tr) {
            invfunc()
        }
        
        if (invr)&&(invn<1001) {
            invn++
        } else {
            invr = false
            invn = 0
        }
        if (gr)&&(grn<1001) {
          g = CGFloat(g - 0.175)
          grn++
        } else {
            gr = false
            grn = 0
        }
        if (techr)&&(techn<1001) {
            bita.frame.origin.x = ball.frame.midX - (bita.frame.width / 3)
            techn++
        } else {
            techr = false
            techn = 0
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
            if (lightr)&&(lightn<40) {
                g = CGFloat(10)
                lightn++
            } else {
                g = CGFloat(5)
                lightr = false
                lightn = 0
            }
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
        bon = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: select, userInfo: nil, repeats: true)
        
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
