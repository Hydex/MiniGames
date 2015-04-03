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
    var k = CGFloat(0), kp = Int(0)
    var lfs = 0, i = 0, lst = 0
    var lc = 0
    var r = UInt32(0)
    var fly = NSTimer(), bon = NSTimer(), bmove = NSTimer(), cbitat = NSTimer()
    var pg = CGFloat(-5)
    var pk = CGFloat(2)
    var pgr = 0
    var rand = 0, tr = false, kt = false
    var n : Array<Int> = [], nr : Array<Bool> = [], el : Array<Bool> = [], btn: Array<NSButton> = []
    
    @IBOutlet weak var ball: NSButton!
    @IBOutlet weak var lin: NSBox!
    @IBOutlet weak var bita: NSButton!
    @IBOutlet weak var cbita: NSButton!
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
    @IBOutlet weak var player: NSTextField!
    @IBOutlet weak var ran: NSButton!
    @IBOutlet weak var comp: NSTextField!
    @IBOutlet weak var result: NSTextField!
    
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

    var leftDown = false
    var rightDown = false
    
    override func keyDown(theEvent: NSEvent) {
        switch theEvent.character {
        case NSRightArrowFunctionKey:
            rightDown = true
        case NSLeftArrowFunctionKey:
            leftDown = true
        default:
            super.mouseDown(theEvent)
        }
    }

    override func keyUp(theEvent: NSEvent) {
        super.keyUp(theEvent)
        switch theEvent.character {
        case NSRightArrowFunctionKey:
            rightDown = false
        case NSLeftArrowFunctionKey:
            leftDown = false
        default:
            super.mouseDown(theEvent)
        }
    }


    func bmovefunc(sender : AnyObject) {
        var al = bita.frame.origin.x
        if (rightDown)&&(bita.frame.maxX < (self.view.frame.width - 10)) {
                bita.frame.origin.x = al + 10
        }
        if (leftDown)&&(bita.frame.minX > 10) {
                bita.frame.origin.x = al - 10
        }
    }

    func cbitafunc(sender: AnyObject) {
        //write a.i moving
    }

    func bonalign(sender: NSButton) {
        sender.hidden = false
        sender.frame.origin.x = CGFloat(arc4random_uniform(500) + 100)
        sender.frame.origin.y = CGFloat(arc4random_uniform(350)+100)
    }
    
    func bonfunc(timer: AnyObject?) {
        rand = Int(arc4random_uniform(7) + 1)
        bonalign(btn[rand])
    }
    
    func checkobj(sender: NSButton) {
        if ((ball.frame.maxX > sender.frame.minX) && (sender.frame.maxX > ball.frame.minX) && (sender.frame.maxY > ball.frame.minY) && (sender.frame.minY < ball.frame.maxY)) {
            tr = true
        }
        if (tr) {
            backalign(sender)
            nr[sender.tag] = true
            el[sender.tag] = true
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
            case 1:
                bita.frame = NSRect(x: bita.frame.origin.x, y: bita.frame.origin.y, width: 175, height: bita.frame.height)
            case 2:
                bita.frame = NSRect(x: bita.frame.origin.x, y: bita.frame.origin.y, width: 75, height: bita.frame.height)
            case 3:
               g = CGFloat(g - 0.275)
            case 4:
               g = CGFloat(10)
            case 5:
                if ((ball.frame.minY) < CGFloat(2 + bita.frame.maxY)) {
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
            if (t == 4)&&(el[4]) {
                g = CGFloat(5)
            }
            if ((t == 1)&&(el[1]))|((t == 2)&&(el[2])) {
                bita.frame = NSRect(x: bita.frame.origin.x, y: bita.frame.origin.y, width: 125, height: bita.frame.height)
            }
            nr[t] = false
            n[t] = 0
        }
        
    }
    
    func flyfunc(timer : NSTimer) {

        for (i=1; i < 9; i++) {
            checkobj(btn[i])
            timefunc(btn[i])
        }


        if (ball.frame.maxY > (self.view.frame.height - 10)) {
            if (player.integerValue < 4) {
                player.stringValue = String(player.integerValue + 1)
            } else {
                result.stringValue = "WINNER"
                player.stringValue = "5"
            }
            ball.frame.origin.x = self.view.frame.width / 2
            ball.frame.origin.y = self.view.frame.height / 2
            k = 0
            g = 0
            sb.enabled = true
        }
        if ((bita.frame.minX < ball.frame.maxX)&&(bita.frame.maxX > ball.frame.minX)&&(bita.frame.maxY > ball.frame.minY)) {
            timefunc(light)
            k = CGFloat(-((bita.frame.origin.x+((bita.frame.width)/3)-ball.frame.origin.x)/3.5))
            g = CGFloat(-g)
        }
        if ((ball.frame.origin.x)<0)||((ball.frame.origin.x+39) > self.view.frame.width) {
            k = CGFloat(-k)
        }
        if ((ball.frame.minY) < (bita.frame.maxY - 7)) {
            if (comp.integerValue < 4) {
                comp.stringValue = String(comp.integerValue + 1)
            } else {
                result.stringValue = "LOOSER"
                comp.stringValue = "5"
            }
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
    var bsel = Selector("bmovefunc:")
    var cbsel = Selector("cbitafunc:")

    override func viewDidLoad() {
        super.viewDidLoad()
        for (i = 0; i<9; i++) {
            nr.append(false)
            n.append(0)
            btn.append(bigbita)
            el.append(false)
        }
        btn[2] = smallbita
        btn[3] = grav
        btn[4] = light
        btn[5] = tech
        btn[6] = inv
        btn[7] = wind
        btn[8] = ran
        cbitat = NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: cbsel, userInfo: nil, repeats: true)
        fly = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: sel, userInfo: nil, repeats: true)
        bon = NSTimer.scheduledTimerWithTimeInterval(6.0, target: self, selector: select, userInfo: nil, repeats: true)
        bmove = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: bsel, userInfo: nil, repeats: true)
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}
