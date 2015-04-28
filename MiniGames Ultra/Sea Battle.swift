//
//  Sea Battle.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 07/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit
import Cocoa

class SeaBattle: NSViewController {

    var rand1 = 0, rand2 = 0
    var btnp: Array<NSButton> = []
    var btnc: Array<NSButton> = []
    var pp1: Array<NSButton> = [], pc1: Array<NSButton> = []
    var pp2: Array<NSButton> = [], pc2: Array<NSButton> = []
    var pp3: Array<NSButton> = [], pc3: Array<NSButton> = []
    var pp4: Array<NSButton> = [], pc4: Array<NSButton> = []
    var p1 = true, p2 = true, p3 = true, p4 = true
    var c1 = 0, c2 = 0, c3 = 0
    var ps: Array<NSButton> = []
    var cship: Array<Array<NSButton>> = [], pship: Array<Array<NSButton>> = []
    var sh: Array<Array<Array<NSButton>>> = [], bt: Array<Array<NSButton>> = []
    var i = 0
    var j = 0
    var q = 0, g = 0, gs = false
    var b1 = NSButton(), b2 = NSButton()
    var p = 0
    var k1 = 0, k2 = 0
    var selp = Selector("ppress:"), selc = Selector("cpress:"), chksel = Selector("chkf:")
    var tr = false
    var rd = 0
    var kr = true
    var chk = NSTimer()
    override func viewDidLoad() {
        super.viewDidLoad()
        start()
    }
    func start() {
        fieldfunc()
        cship.append(pc1)
        cship.append(pc2)
        cship.append(pc3)
        cship.append(pc4)
        pship.append(pp1)
        pship.append(pp2)
        pship.append(pp3)
        pship.append(pp4)
        sh.append(cship)
        sh.append(pship)
        bt.append(btnc)
        bt.append(btnp)
        chk = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: chksel, userInfo: nil, repeats: true)
    }
    func shipc() {
        var rd = 0

        while (btnc[rd].tag == 2)||(btnc[rd].tag == 6)||(btnc[rd].tag == 5)||(btnc[rd+1].tag == 2)||(btnc[rd+1].tag == 6)||(btnc[rd+1].tag == 5)||(btnc[rd+2].tag == 2)||(btnc[rd+2].tag == 6)||(btnc[rd+2].tag == 5)||(btnc[rd+3].tag == 2)||(btnc[rd+3].tag == 6)||(btnc[rd+3].tag == 5) {
            rd = Int(arc4random_uniform(144))
        }
        scheck(0, b: (rd), a: (rd+3))
        for j in 0...3 {
            pc4.append(btnc[rd + j])
            btnc[rd + j].tag = 5
            for q in -1...4 {
                btnc[rd + q + 12].tag = 6
                btnc[rd + q - 12].tag = 6
            }
        }
        btnc[rd - 1].tag = 6
        btnc[rd + 4].tag = 6

        for i in 1...2 {
            while (btnc[rd].tag == 2)||(btnc[rd].tag == 6)||(btnc[rd].tag == 5)||(btnc[rd+12].tag == 2)||(btnc[rd+12].tag == 6)||(btnc[rd+12].tag == 5)||(btnc[rd+24].tag == 2)||(btnc[rd+24].tag == 6)||(btnc[rd+24].tag == 5) {
                rd = Int(arc4random_uniform(144))
            }
            scheck(0, b: (rd), a: (rd+24))
            for j in 0...2 {
                pc3.append(btnc[rd + j*12])
                btnc[rd + j*12].tag = 5
                for q in -1...3 {
                    btnc[rd + q*12 - 1].tag = 6
                    btnc[rd + q*12 + 1].tag = 6
                }
            }
            btnc[rd - 12].tag = 6
            btnc[rd + 36].tag = 6
        }

        for i in 1...3 {
            while (btnc[rd].tag == 2)||(btnc[rd].tag == 6)||(btnc[rd].tag == 5)||(btnc[rd+1].tag == 2)||(btnc[rd+1].tag == 6)||(btnc[rd+1].tag == 5) {
                rd = Int(arc4random_uniform(144))
            }
            scheck(0, b: (rd), a: (rd+1))
            for j in 0...1 {
                btnc[rd + j].tag = 5
                pc2.append(btnc[rd + j])
                for q in -1...1 {
                    btnc[rd + j + q + 12].tag = 6
                    btnc[rd + j + q - 12].tag = 6
                }
            }
            btnc[rd - 1].tag = 6
            btnc[rd + 2].tag = 6
        }


        for i in 1...4 {
            while (btnc[rd].tag == 2)||(btnc[rd].tag == 6)||(btnc[rd].tag == 5) {
                rd = Int(arc4random_uniform(144))
            }
            scheck(0, b: (rd), a: (rd))
            btnc[rd].tag = 5
            pc1.append(btnc[rd])
            for i in -1...1 {
                btnc[rd + i + 12].tag = 6
                btnc[rd + i - 12].tag = 6
            }
            btnc[rd + 1].tag = 6
            btnc[rd - 1].tag = 6
        }
    }
    var n1 = true, n2 = true, n3 = true, n4 = true
    var t1 = 0, t2 = 0, t3 = 0
    func fieldfunc() {
        var x = 50
        var y = 50
        var t = 1
        for i in 1...12 {
            var bt = NSButton()
            bt.tag = 2
            btnc.append(bt)
            btnp.append(bt)
        }
        for i in 1...10 {
            var lbl : Array<NSTextField> = []
            for (q = 0; q < 4; q++) {
                if (q < 2) {
                    lbl.append(NSTextField(frame: NSRect(x: q*400 + 20, y: y-5 , width: 32, height: 32)))
                    lbl[q].integerValue = Int(abs(11 - i))
                } else {
                    lbl.append(NSTextField(frame: NSRect(x: (q-2)*350 + 20 + i*30, y: 400 , width: 32, height: 32)))
                    lbl[q].integerValue = Int(i)
                }
                lbl[q].bordered = false
                lbl[q].alignment = NSTextAlignment.CenterTextAlignment
                lbl[q].backgroundColor = NSColor.controlColor()
                lbl[q].enabled = false
                self.view.addSubview(lbl[q])
            }
            var bt = NSButton()
            bt.tag = 2
            btnc.append(bt)
            btnp.append(bt)
            for j in 1...10 {
                var btp = NSButton(frame: NSRect(x: x, y: y , width: 30, height: 32))
                var btc = NSButton(frame: NSRect(x: x+400, y: y , width: 30, height: 32))
                btp.action = selp
                btc.action = selc
                btc.enabled = false
                btp.title = ""
                btc.title = ""
                btc.image = NSImage.swatchWithColor(NSColor.whiteColor(), size: NSSize(width: 29, height: 29))
                btp.image = NSImage.swatchWithColor(NSColor.whiteColor(), size: NSSize(width: 29, height: 29))
                if (i == 1)||(j == 1)||(i == 10)||(j == 10) {
                    btc.tag = 1
                } else {btc.tag = 0}
                btc.bezelStyle = NSBezelStyle(rawValue: 10)!
                btp.bezelStyle = NSBezelStyle(rawValue: 10)!
                btnp.append(btp)
                btnc.append(btc)
                self.view.addSubview(btp)
                self.view.addSubview(btc)
                x += 30
            }
            bt.tag = 2
            btnc.append(bt)
            btnp.append(bt)
            y += 30
            x = 50
        }
        for i in 1...12 {
            var bt = NSButton()
            bt.tag = 2
            btnc.append(bt)
            btnp.append(bt)
        }
    }
    func ppress (sender: NSButton) {
        if (k1 == 0) {
            for i in 0...143 {
                if (sender == btnp[i])&&(sender.tag != 6)&&(sender.tag != 5) {
                    sender.image = NSImage.swatchWithColor(NSColor.lightGrayColor(), size: NSSize(width: 29, height: 29))
                    k1 = i
                    k2 = 0
                }
            }
        } else {
            for i in 0...143 {
                if (sender == btnp[i])&&(sender.tag != 5)&&(sender.tag != 6)&&((abs(k1-i) <= 3)||(abs(k1-i) == 12)||(abs(k1-i) == 24)||(abs(k1-i) == 36)) {
                    k2 = i
                }
            }
            if (k2 == 0) {btnp[k1].image = NSImage.swatchWithColor(NSColor.whiteColor(), size: NSSize(width: 29, height: 29))}

            if (k2 < k1) {
                var tmp = k1
                k1 = k2
                k2 = tmp
            }
            var x = (k2 - k1)/12
            var y = k2 - k1
            if (k1 != 0)&&(k2 != 0)&&((p1&&(k1 == k2))||(p2&&((x == 1)||(y == 1)))||(p3&&((x == 2)||(y == 2)))||(p4&&((x == 3)||(y == 3)))) {
                scheck(1, b: k1, a: k2)
                if ((k2 - k1) % 12 == 0) {
                    for i in 0...((k2 - k1)/12) {
                        if ((k2 - k1) % 12 == 0) {
                            btnp[k1 + i*12].image = NSImage.swatchWithColor(NSColor.darkGrayColor(), size: NSSize(width: 29, height: 29))
                            btnp[k1 + i*12].tag = 5
                            btnp[k1 + i*12 + 1].tag = 6
                            btnp[k1 + i*12 - 1].tag = 6
                        }
                        for j in -1...1 {
                            btnp[k1 - 12 - j].tag = 6
                            btnp[k2 + 12 - j].tag = 6
                        }
                    }
                } else{
                    for i in 0...(k2 - k1) {
                        btnp[k1 + i].image = NSImage.swatchWithColor(NSColor.darkGrayColor(), size: NSSize(width: 29, height: 29))
                        btnp[k1 + i].tag = 5
                        btnp[k1 + i - 12].tag = 6
                        btnp[k1 + i + 12].tag = 6
                    }
                    for j in -1...1 {
                        btnp[k1 - j*12 - 1].tag = 6
                        btnp[k2 + j*12 + 1].tag = 6
                    }
                }
            } else {
                btnp[k1].image = NSImage.swatchWithColor(NSColor.whiteColor(), size: NSSize(width: 29, height: 29))
                btnp[k2].image = NSImage.swatchWithColor(NSColor.whiteColor(), size: NSSize(width: 29, height: 29))
            }
            k1 = 0
        }
    }
    func ai() {
        var rnd = Int(arc4random_uniform(120) + 13), tr = true
        while (tr) {
            rnd = Int(arc4random_uniform(120) + 12)
            while (rnd % 12 == 0)||((rnd+1) % 12 == 0)||(btnp[rnd].tag == 3)||(btnp[rnd].tag == 1) {
                rnd = Int(arc4random_uniform(120) + 12)
            }
            if (btnp[rnd].tag == 5) {
                btnp[rnd].tag = 3
                btnp[rnd].image = NSImage(named: "cross.png")
                for i in 0...3 {
                    if btnp[rnd] == sh[1][0][i] {
                        sh[1][0][i].image = NSImage(named: "cross-2.png")
                        around(1, r1: 1, r2: i)
                    }
                }
            } else {
                btnp[rnd].image = NSImage(named: "dot.png")
                tr = false
                btnp[rnd].tag = 1
            }
            btnp[rnd].enabled = false
        }
    }
    func cpress(sender: NSButton) {
        var n = 0
        sender.enabled = false
        if (sender.tag == 5) {
            sender.tag = 3
            sender.image = NSImage(named: "cross.png")
            for i in 0...3 {
                if (sender == pc1[i]) {
                    sender.image = NSImage(named: "cross-2.png")
                    around(0, r1: 1, r2: i)
                }
            }
        }   else {
            sender.image = NSImage(named: "dot.png")
            sender.enabled = false
            ai()
        }
    }
    func scheck(r : Int, b : Int, a : Int) {
        if ((a - b) % 12 != 0) {
            for i in 0...(a - b) {
                sh[r][a-b].append(bt[r][b+i])
            }
            if ((a - b) == 3)&&(r == 1) {
                p4 = false
            }
            if (r == 1) {
                switch (a - b) {
                case 0:
                    c1++
                    if (c1 == 4) {
                        p1 = false
                    }
                case 1:
                    c2++
                    if (c2 == 3) {
                        p2 = false
                    }
                case 2:
                    c3++
                    if (c3 == 2) {
                        p3 = false
                    }
                default: break
                }
            }
        } else{
            if (r == 1) {
                switch (a - b)/12 {
                case 0:
                    c1++
                    if (c1 == 4)&&(r == 1) {
                        p1 = false
                    }
                case 1:
                    c2++
                    if (c2 == 3)&&(r == 1) {
                        p2 = false
                    }
                case 2:
                    c3++
                    if (c3 == 2)&&(r == 1) {
                        p3 = false
                    }
                default: break
                }
            }
            for i in 0...((a - b)/12) {
                sh[r][(a-b)/12].append(bt[r][b + i*12])
            }
        }
    }
    func around (r : Int, r1 : Int, r2: Int) {
        var n = 0
        for i in 0...143 {
            if (bt[r][i] == sh[r][r1-1][r2]) {
                n = i
            }
        }
        if (bt[r][n + 1].tag == 3) {
            for i in -1...1 {
                bt[r][n - 1 + i*12].image = NSImage(named: "dot.png")
                bt[r][n - 1 + i*12].tag = 2
                bt[r][n - 1 + i*12].enabled = false
                bt[r][n + r1 + i*12].image = NSImage(named: "dot.png")
                bt[r][n + r1 + i*12].tag = 2
                bt[r][n + r1 + i*12].enabled = false
            }
            for i in 0...(r1 - 1) {
                bt[r][n + i + 12].image = NSImage(named: "dot.png")
                bt[r][n + i - 12].image = NSImage(named: "dot.png")
                bt[r][n + i + 12].tag = 2
                bt[r][n + i - 12].tag = 2
                bt[r][n + i + 12].enabled = false
                bt[r][n + i - 12].enabled = false
            }
        } else {
            for i in -1...1 {
                bt[r][n - 12 + i].image = NSImage(named: "dot.png")
                bt[r][n - 12 + i].tag = 2
                bt[r][n - 12 + i].enabled = false
                bt[r][n + r1*12 + i].image = NSImage(named: "dot.png")
                bt[r][n + r1*12 + i].tag = 2
                bt[r][n + r1*12 + i].enabled = false
            }
            for i in 0...(r1 - 1) {
                bt[r][n + i*12 + 1].image = NSImage(named: "dot.png")
                bt[r][n + i*12 - 1].image = NSImage(named: "dot.png")
                bt[r][n + i*12 + 1].tag = 2
                bt[r][n + i*12 - 1].tag = 2
                bt[r][n + i*12 + 1].enabled = false
                bt[r][n + i*12 - 1].enabled = false
            }

        }
    }
    func chkf(sender: NSTimer) {
        var g = 0
        var k = 0
        var n = 0
        var h = 0

        k = 0
        if (gs) {
            for q in 0...1 {
                for i in 0...3 {
                    if (gs)&&(sh[q][3][i].tag == 3) {
                        k++
                    }
                }
                if (k == 4) {
                    around(q, r1: 4, r2: 0)
                    k = 0
                    for i in 0...3 {
                        sh[q][3][i].image = NSImage(named: "cross-2.png")
                    }
                }
                k = 0
            }


            for q in 0...1 {
                for j in 0...1 {
                    for i in 0...2 {
                        if (gs)&&(sh[q][2][i + j*3].tag == 3) {
                            k++
                        }
                    }
                    if (k == 3) {
                        around(q, r1: 3, r2: j*3)
                        k = 0
                        for i in 0...2 {
                            sh[q][2][i + j*3].image = NSImage(named: "cross-2.png")
                        }
                    }
                    k = 0
                }
            }

            for q in 0...1 {
                for j in 0...2 {
                    for i in 0...1 {
                        if (gs)&&(sh[q][1][i + j*2].tag == 3) {
                            k++
                        }
                    }
                    if (k == 2) {
                        around(q, r1: 2, r2: j*2)
                        k = 0
                        for i in 0...1 {
                            sh[q][1][i + j*2].image = NSImage(named: "cross-2.png")
                        }
                    }
                    k = 0
                }
            }
        }

        for i in 0...143 {
            if (btnc[i].tag == 3) {
                k++
            }
            if (btnp[i].tag == 5) {
                h++
            }
            if (btnp[i].tag == 3) {
                g++
            }
        }

        if (h == 20)&&(kr) {
            kr = false
            gs = true
            for i in 0...143 {
                btnc[i].enabled = true
                btnp[i].enabled = false
            }
        }
        if (k == 20)||(g == 20) {
            var al = NSAlert()
            al.showsHelp = false
            if (k == 20) {
                al.messageText = strLocal("Congratulations! You won!")
            } else {
                al.messageText = strLocal("Try again...")
            }
            al.addButtonWithTitle(strLocal("quit"))
            al.addButtonWithTitle(strLocal("anGame"))
            var responseTag = NSModalResponse()
            responseTag = al.runModal()
            switch responseTag {
            case NSAlertFirstButtonReturn:
                exit(0)
            default:
                self.view.window?.close()
            }
        }
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        shipc()
    }
}