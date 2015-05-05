//
//  2048Main.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 16.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa
import AppKit
import Foundation

class _048Main: NSViewController {

    var ar : Array<NSTextField> = []
    var left = 0
    
    var dict : Dictionary<Int, Col> = [:]
    
    var timer = NSTimer()
    var moves = 0
    
    @IBOutlet weak var leftBut: NSButton!
    @IBOutlet weak var rightBut: NSButton!
    @IBOutlet weak var upBut: NSButton!
    @IBOutlet weak var downBut: NSButton!
    
    
    var pic0 = Col.lightGrayColor()
    var pic2 = Col.redColor()
    var pic4 = Col.whiteColor()
    var pic8 = Col.orangeColor()
    var pic16 = Col.magentaColor()
    var pic32 = Col.blueColor()
    var pic64 = Col.purpleColor()
    var pic128 = Col.yellowColor()
    var pic256 = Col.brownColor()
    var pic512 = Col.cyanColor()
    var pic1024 = Col.greenColor()
    var pic2048 = Col()
    
    func moveTile(del : Int, down : Int, up : Int, mod : Int) {
        var tmp = ar;
        for var i = 0; i < 3; i++ {
            for each in ar {
                for e in ar {
                    if each.tag == e.tag + del && each.tag % 4 != mod && e.tag < up && e.tag > down {
                        if each.stringValue == e.stringValue {
                            e.backgroundColor = dict[each.integerValue * 2]
                            if each.integerValue == 0 {
                                e.stringValue = ""
                            }
                            else {
                                e.integerValue = each.integerValue * 2
                            }
                            each.backgroundColor = Col.lightGrayColor()
                            each.stringValue = ""
                            if e.stringValue != "" {
                                left++
                            }
                            if e.integerValue > 100 {
                                e.font = NSFont(name: "Helvetica", size: 50)
                            }
                            else {
                                e.font = NSFont(name: "Helvetica", size: 75)
                            }
                        }
                        else if e.stringValue == "" {
                            e.backgroundColor = each.backgroundColor
                            if each.integerValue == 0 {
                                e.stringValue = ""
                            }
                            else {
                                e.integerValue = each.integerValue
                            }
                            each.backgroundColor = Col.lightGrayColor()
                            each.stringValue = ""
                            e.font = each.font
                            each.font = NSFont(name: "Helvetica", size: 75)
                        }
                    }
                }
            }
        }
        if left > 0 {
            generateTile()
        }
        if left == 0 {
            lose()
        }
        moves++
        var lang = 1
        var mo = strLocal("moves")
        if mo == "move" {
            lang = 2
        }
        self.view.window?.title = "2048 - " + "\(moves) " + "\(mo)" + endingMale(moves, lang)
    }
    
    func lose() {
        var d = false
        var ifOne : Bool
        var ifTwo : Bool
        var ifThree : Bool
        var ifFour : Bool
        for each in ar {
            for e in ar {
                ifOne = e.tag == each.tag + 1 && each.tag % 4 != 0 && each.backgroundColor == e.backgroundColor
                ifTwo = e.tag == each.tag - 1 && each.tag % 4 != 1 && each.backgroundColor == e.backgroundColor
                ifThree = e.tag == each.tag + 4  && each.backgroundColor == e.backgroundColor
                ifFour = e.tag == each.tag - 4  && each.backgroundColor == e.backgroundColor
                println("\(each.tag) \(e.tag) \(ifOne) \(ifTwo) \(ifThree) \(ifFour)\n\n")
                if (ifOne || ifTwo || ifThree || ifFour) {
                    d = true
                }
            }
        }
        if !d {
            var al = NSAlert()
            al.showsHelp = false
            al.messageText = strLocal("lost")
            al.informativeText = strLocal("replay")
            al.addButtonWithTitle(strLocal("newGame"))
            al.addButtonWithTitle(strLocal("quit"))
            al.addButtonWithTitle(strLocal("anGame"))
            var responseTag = NSModalResponse()
            responseTag = al.runModal()
            switch responseTag {
            case NSAlertFirstButtonReturn:
                for i in ar {
                    i.removeFromSuperview()
                }
                ar.removeAll(keepCapacity: false)
                viewDidLoad()
            case NSAlertSecondButtonReturn:
                exit(0)
            default:
                self.view.window?.close()
            }

        }
    }
    
    @IBAction func rightArrowPressed(sender: AnyObject) {
        moveTile(-1, down: -1000, up: 1000, mod: 0)
    }
    @IBAction func leftArrowPressed(sender: AnyObject) {
        moveTile(1, down: -100, up: 100, mod: 1)
    }
    @IBAction func downArrowPressed(sender: AnyObject) {
        moveTile(4, down: -1000, up: 13, mod: 100)
    }
    @IBAction func upArrowPressed(sender: AnyObject) {
        moveTile(-4, down: 4, up: 17, mod: 100)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dict[0] = pic0
        dict[2] = pic2
        dict[4] = pic4
        dict[8] = pic8
        dict[16] = pic16
        dict[32] = pic32
        dict[64] = pic64
        dict[128] = pic128
        dict[256] = pic256
        dict[512] = pic512
        dict[1024] = pic1024
        dict[2048] = pic2048
        
        var x = CGFloat(0)
        var y = CGFloat(0)
        var tag = 1
        
        for var i = 0; i < 4; i++ {
            for var j = 0; j < 4; j++ {
                var tile = NSTextField(frame: NSRt(x: x, y: y, width: 100, height: 100))
                tile.enabled = false
                tile.stringValue = ""
                tile.font = NSFont(name: "Helvetica", size: 75)
                tile.backgroundColor = Col.lightGrayColor()
                tile.editable = false
                tile.selectable = false
                tile.drawsBackground = true
                tile.alignment = NSTextAlignment(rawValue: 2)!
                tile.tag = tag
                x += 105
                ar.append(tile)
                self.view.addSubview(tile)
                tag++
            }
            x = 0
            y += 105
        }
        left = 16
        generateTile()
        generateTile()
        moves = 0
    }
    
    func generateTile() {
        var r = Int(arc4random_uniform(UInt32(left)))
        var tmp = 0
        for var i = 0; i < 16; i++ {
            if ar[i].stringValue == "" {
                if tmp == r {
                    var t = Int(arc4random_uniform(10))
                    switch t {
                    case 0...1:
                        ar[i].stringValue = "4"
                        ar[i].backgroundColor = pic4
                    default:
                        ar[i].stringValue = "2"
                        ar[i].backgroundColor = pic2
                    }
                    break
                }
                tmp++
            }
        }
        left--
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
        var frame = self.view.window?.frame
        var newHeight = CGFloat(438)
        var newWidth = CGFloat(415)
        frame?.size = NSMakeSize(newWidth, newHeight)
        self.view.window?.setFrame(frame!, display: true)
        self.view.window?.backgroundColor = Col.darkGrayColor()
        self.view.window?.title = "2048"
        self.view.window?.center()
    }
}
