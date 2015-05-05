//
//  Sea Battle.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 07/04/15.
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
    var i = 0, j = 0, q = 0

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
                    lbl.append(NSTextField(frame: NSRect(x: (q-2)*400 + 20 + i*30, y: 350 , width: 32, height: 32)))
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
//                btp.action = selp
//                btc.action = selc
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
    }