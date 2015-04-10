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
                cship.append(0)
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
    func cpress(sender: NSButton) {
        sender.enabled = false
        if (sender.tag == 5) {
            sender.title = "B"
        }
    }


    func shipc () {
        
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
