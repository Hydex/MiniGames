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

    var invrs = CGFloat(10), j = 0
    var g = CGFloat(0)
    var k = CGFloat(0), kp = Int(0), w = 0
    var lfs = 0, i = 0, lst = 0
    var lc = 0
    var r = UInt32(0)
    var fly = NSTimer(), bon = NSTimer(), bmove = NSTimer(), cbitat = NSTimer()
    var pg = CGFloat(-5)
    var pk = CGFloat(2)
    var pgr = 0, bv = 3, cg = CGFloat(1.7)
    var rand = 0, kt = false, tf = false, tr = false
    var n : Array<Int> = [], nr : Array<Bool> = [], btn: Array<NSButton> = [], bts: Array<NSButton> = [], lns: Array<NSBox> = [], scr: Array<NSTextField!> = []
    



    @IBOutlet weak var rstart: NSButton!
    @IBAction func rstart(sender: AnyObject) {
        result.stringValue = ""
        comp.integerValue = 0
        player.integerValue = 0
        sb.enabled = true
    }

    @IBOutlet weak var you: NSTextField!
    @IBOutlet weak var computer: NSTextField!
    @IBOutlet weak var clin: NSBox!
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
    @IBOutlet weak var ran: NSButton!
    @IBOutlet weak var result: NSTextField!
    @IBOutlet weak var player: NSTextField!
    @IBOutlet weak var comp: NSTextField!
    
    @IBAction func stb(sender: AnyObject) {
        if (stb.title == "Stop") {
            stb.title = "Resume"
            cbitat.invalidate()
            fly.invalidate()
            bmove.invalidate()
            bon.invalidate()
        }
        else {
            stb.title = "Stop"
            cbitat = NSTimer.scheduledTimerWithTimeInterval(0.0009, target: self, selector: cbsel, userInfo: nil, repeats: true)
            fly = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: sel, userInfo: nil, repeats: true)
            bon = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: select, userInfo: nil, repeats: true)
            bmove = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: bsel, userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func sb(sender: AnyObject) {
        g = CGFloat(-6)
        k = CGFloat(3)
        ball.frame.origin.x = CGFloat(10)
        ball.frame.origin.y = CGFloat(450)
        stb.title = "Stop"
        sb.enabled = false
        cbitat = NSTimer.scheduledTimerWithTimeInterval(0.0009, target: self, selector: cbsel, userInfo: nil, repeats: true)
        fly = NSTimer.scheduledTimerWithTimeInterval(0.025, target: self, selector: sel, userInfo: nil, repeats: true)
        bon = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: select, userInfo: nil, repeats: true)
        bmove = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: bsel, userInfo: nil, repeats: true)
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
        if (rightDown)&&(((bita.frame.maxX < (self.view.frame.width - 10))&&(invrs > 0))|((bita.frame.minX > 10)&&(invrs<0))) {
                bita.frame.origin.x = CGFloat(al + invrs)
        }
        if (leftDown)&&(((bita.frame.maxX < (self.view.frame.width - 10))&&(invrs < 0))|((bita.frame.minX > 10)&&(invrs>0))) {
                bita.frame.origin.x = CGFloat(al - invrs)
        }
    }

    func bonfunc(timer: AnyObject?) {
        rand = Int(arc4random_uniform(7) + 1)
        btn[rand].hidden = false
        btn[rand].frame.origin.x = CGFloat(arc4random_uniform(500) + 100)
        btn[rand].frame.origin.y = CGFloat(arc4random_uniform(350)+100)
    }

    func timefunc(sender: NSButton) {
        var t = sender.tag
        for i in 0...1 {
            if (nr[i*10 + t])&&(n[i*10 + t] < 601) {
                n[i*10 + t]++
                switch t{
                case 1:
                    bts[i].frame = NSRect(x: bts[i].frame.origin.x, y: bts[i].frame.origin.y, width: 175, height: bts[i].frame.height)
                case 2:
                    bts[i].frame = NSRect(x: bts[i].frame.origin.x, y: bts[i].frame.origin.y, width: 75, height: bts[i].frame.height)
                case 3:
                    g = CGFloat(g + (0.35 * ((CGFloat(i) * 2) - 1)))
                case 4:
                    cg = CGFloat(13)
                case 5:
                    bts[i].frame.origin.x = CGFloat(ball.frame.origin.x - 48 - CGFloat(arc4random_uniform(5)))
                case 6:
                    if (i == 0) {
                        invrs = CGFloat(-10)
                    }
                case 7:
                    if (scr[abs(i - 1)].integerValue > 0)&&(n[i*10 + t] < 2) {
                        scr[abs(i - 1)].integerValue -= 1
                    }
                case 8:
                    if (n[i*10 + t] < 2) {
                        ball.frame = NSRect(x: ball.frame.origin.x, y: ball.frame.origin.y, width: ball.frame.width * 1.5, height: ball.frame.height * 1.5)
                    }
                default: break
                }
            } else {
                if (n[i*10 + t] > 600) {
                n[i*10 + t] = 1
                nr[i*10 + t] = false
                switch t {
                case 1...2: bts[i].frame = NSRect(x: bts[i].frame.origin.x, y: bts[i].frame.origin.y, width: 125, height: bts[i].frame.height)
                case 4: cg = CGFloat(0)
                case 6: invrs = CGFloat(10)
                case 8: ball.frame = NSRect(x: ball.frame.origin.x, y: ball.frame.origin.y, width: CGFloat(25), height: CGFloat(25))
                default: break
                }
                }
            }
        }
    }

    func checkobj(sender: AnyObject) {
        if ((ball.frame.maxX > sender.frame.minX) && (sender.frame.maxX > ball.frame.minX) && (sender.frame.maxY > ball.frame.minY) && (sender.frame.minY < ball.frame.maxY)) {
            tr = true
        }
    }

    func cbitafunc(sender: AnyObject) {
        var cbx = cbita.frame.origin.x
        if ((cbita.frame.maxX)<(ball.frame.maxX)) {
            cbita.frame.origin.x = CGFloat(cbx + 3)
        }
        if ((cbita.frame.minX)>(ball.frame.minX)) {
            cbita.frame.origin.x = CGFloat(cbx - 3)
        }
    }

    func flyfunc(timer : NSTimer) {
        for i in 1...8 {
            checkobj(btn[i])
            if (tr) {
            btn[i].hidden = true
            btn[i].frame.origin.x = CGFloat(100)
            btn[i].frame.origin.y = CGFloat(11)
            tr = false
            nr[w*10 + i] = true
            }
            timefunc(btn[i])
        }
        for (i=0; i<2; i++) {
            checkobj(bts[i])
            if (tr) {
                w = i
                if (cg != CGFloat(0))&&(nr[i*10 + 4]) {
                    g = CGFloat(-((CGFloat(i) * 2 - 1) * cg))
                } else {g = CGFloat(-((CGFloat(i) * 2 - 1) * 6))}
                k = CGFloat(-(bts[i].frame.midX - ball.frame.midX)/3.5)
                tr = false
            }
            checkobj(lns[i])
            if (tr) {
                tr = false
                ball.frame.origin.x = CGFloat(10)
                ball.frame.origin.y = CGFloat(450)
                k = 0
                g = 0
                sb.enabled = true
                if (scr[abs(i - 1)].integerValue < 4) {
                    scr[abs(i - 1)].integerValue += 1
                } else {
                    scr[abs(i - 1)].integerValue = 5
                    result.stringValue = "WINNER: " + scr[abs(i - 1)+2].stringValue
                    sb.enabled = false
                    cbitat.invalidate()
                    fly.invalidate()
                    bmove.invalidate()
                    bon.invalidate()

                }
        }
        }
        if ((ball.frame.minX) <= 0)||((ball.frame.maxX) >= self.view.frame.width) {
            k = CGFloat(-k)
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
        for i in 1...19 {
            n.append(0)
            btn.append(bigbita)
            nr.append(false)
        }
        btn[2] = smallbita
        btn[3] = grav
        btn[4] = light
        btn[5] = tech
        btn[6] = inv
        btn[7] = wind
        btn[8] = ran
        bts.append(bita)
        bts.append(cbita)
        lns.append(lin)
        lns.append(clin)
        scr.append(player)
        scr.append(comp)
        scr.append(you)
        scr.append(computer)
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
