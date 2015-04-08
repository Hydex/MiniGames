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
    var btnp: Array<NSButton> = [], btnc: Array<NSButton> = []
    var i = 0, j = 0, q = 0
    var selp = Selector("ppress:"), selc = Selector("cpress:")

    override func viewDidAppear() {
        super.viewDidAppear()
        fieldfunc()
    }

    func fieldfunc() {
        var x = 50
        var y = 50
        var t = 1
        for i in 1...10 {
            var lbl : Array<NSTextField> = []
            for q in 0...3 {
                if (q < 2) {
                    lbl.append(NSTextField(frame: NSRect(x: q*430 + 20, y: y-5 , width: 32, height: 32)))
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
                if (i == 1) {
                    btp.tag = 1
                    btc.tag = 1
                }
                if (j == 1) {
                    btp.tag = 2
                    btc.tag = 2
                }
                if (i == 10) {
                    btp.tag = 3
                    btc.tag = 3
                }
                if (j == 10) {
                    btp.tag = 4
                    btc.tag = 4
                }
                btp.action = selp
                btc.action = selc
                btp.title = ""
                btc.title = ""
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

    func check(var a: Int, b: Int, c : Int) {

    }
    func shipc() {
        var st = Int(arc4random_uniform(4) + 1)
        var stx = Int(arc4random_uniform(10) + 1)
        var sty = Int(arc4random_uniform(10) + 1)
        for i in 1...4 {

        }
    }
    func bship(var a: Int) {
        
    }
}