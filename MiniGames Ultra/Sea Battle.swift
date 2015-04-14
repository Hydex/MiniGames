//
//  Sea Battle.swift
//  MiniGames Ultra
//
//  Created by Mark Yankovskiy on 07/04/15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKIt
import Cocoa

class SeaBattle: NSViewController {
    var rand = 0
    var btnp: Array<NSButton> = []
    var btnc: Array<NSButton> = []
    var cship: Array<Int> = []
    var i = 0
    var j = 0
    var q = 0

    var selp = Selector("ppress:"), selc = Selector("cpress:")
    var tr = false
    var rd = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        fieldfunc()
    }

    func fieldfunc() {
        var x = 50
        var y = 50
        var t = 1
        for i in 1...10 {
            var lbl : Array<NSTextField> = []
            for (q = 0; q < 4; q++) {
                if (q < 2) {
                    lbl.append(NSTextField(frame: NSRect(x: q*400 + 20, y: y-5 , width: 32, height: 32)))
                    lbl[q].integerValue = Int(abs(11 - i))
                } else {
                    lbl.append(NSTextField(frame: NSRect(x: (q-2)*400 + 20 + i*30, y: 350 , width: 32, height: 32)))
                    lbl[q].integerValue = Int(i)
                }
                lbl[q].bordered = false
                lbl[q].alignment = NSTextAlignment.CenterTextAlignment
                lbl[q].backgroundColor = NSColor.controlColor()
                lbl[q].enabled = false
                self.view.addSubview(lbl[q])
            }
            for j in 1...10 {
                var btp = NSButton(frame: NSRect(x: x, y: y , width: 30, height: 32))
                var btc = NSButton(frame: NSRect(x: x+400, y: y , width: 30, height: 32))
                btp.action = selp
                btc.action = selc
                btp.title = String(btp.tag)
                btc.title = ""
                if (i == 1)|(j == 1)|(i == 10)|(j == 10) {
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
            y += 30
            x = 50
        }
    }
    func check (var t : Int, var b : Int) {
        var n = 0
        if (t == 0) {
            for i in -1...1 {
                if (btnc[i*10 + b + 1].tag != 5) {
                    n++
                }
                if (btnc[i*10 + b - 1].tag != 5) {
                    n++
                }
                if (btnc[i*10 + b].tag != 5) {
                    n++
                }
            }
        }
        if (n == 9) {tr = true}
    }
    func cpress(sender: NSButton) {
        sender.enabled = false
        if (sender.tag == 5) {
            sender.title = "B"
        }
    }
    func shipc() {
        rand = Int(arc4random_uniform(4) + 1)
        var k = 0
        for i in 0...9 {
        k++
        switch rand {
        case 1:
                if (i % 2 == 0) {
                    btnc[i].tag = 5
                    btnc[i + 10].tag = 5
                }
                if (i % 4 == 0) {
                    btnc[i + 20].tag = 5
                }
                if (i % 10 == 0) {
                    btnc[i + 30].tag = 5
                }
                if (i != 0)&&(i % 6 == 0) {
                    btnc[i + 30].tag = 5
                    btnc[i + 40].tag = 5
                }

        case 2: if (i % 2 == 0) {
                    btnc[i * 10].tag = 5
                    btnc[i * 10 + 1].tag = 5
                }
                if (i % 4 == 0) {
                    btnc[i*10 + 2].tag = 5
                }
                if (i % 10 == 0) {
                    btnc[i * 10 + 3].tag = 5
                }
                if (i != 0)&&(i % 6 == 0) {
                    btnc[i * 10 + 3].tag = 5
                    btnc[i * 10 + 4].tag = 5
                }
        case 3:
            if (i % 2 == 0) {
                btnc[90 + i].tag = 5
                btnc[80 + i].tag = 5
            }
            if (i % 4 == 0) {
                btnc[70 + i].tag = 5
            }
            if (i % 10 == 0) {
                btnc[60 + i].tag = 5
            }
            if (i != 0)&&(i % 6 == 0) {
                btnc[60 + i].tag = 5
                btnc[50 + i].tag = 5
            }
        case 4:
            if (i % 2 == 0) {
                btnc[i * 10 + 9].tag = 5
                btnc[i * 10 + 8].tag = 5
            }
            if (i % 4 == 0) {
                btnc[i*10 + 7].tag = 5
            }
            if (i % 10 == 0) {
                btnc[i * 10 + 6].tag = 5
            }
            if (i != 0)&&(i % 6 == 0) {
                btnc[i * 10 + 6].tag = 5
                btnc[i * 10 + 5].tag = 5
            }
        default: break
        }
    }

    }

    override func viewDidAppear() {
        super.viewDidAppear()
        shipc()
        while (i < 4) {
            var rd = Int(arc4random_uniform(98) + 1)
            println(rd)
            check(btnc[rd].tag, b: rd)
            if (tr) {
                tr = false
                btnc[rd].tag = 5
                i++
            }
        }
    }
}
