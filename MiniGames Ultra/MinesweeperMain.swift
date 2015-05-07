//
//  MinesweeperMain.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit

class MinesweeperMain: NSViewController, NSSpeechRecognizerDelegate {
    var height = 0
    var width = 0
    var bombAmount = 0
    var bombsLeft = 0
    var curMoves = 0
    /// Time to add as highscore
    var time = 0
    var elapsedTime = 0
    var delay = 1
    var flagMoves = -1
    /// Hardness level
    var level = ""
    var timer = NSTimer()
    var flagTimer = NSTimer()
    var storage = NSUD.standardUserDefaults()
    var bombImage = NSImage(named: "Button bomb.png")!
    var flagImage = NSImage(named: "Flag.png")!
    var ar : Array<NSB> = []
    ///Label that show current time
    var curTime = NSTextField()
    var locale = NSBundle.mainBundle()
    var indicator = NSProgressIndicator()
    var recognizer = NSSpeechRecognizer()
    
    /// Main timer function
    func incTime(sender : AnyObject) {
        elapsedTime++
        time = elapsedTime ~~~ 10
        delay++
        curTime.stringValue = "\(time)"
        if width > 7 {
            var name = strLocal("ms")
            var lang = 1
            if name == "Minesweeper" {
                lang = 2
            }
            self.view.window?.title = name + " - "  + strLocal("left") + " \(bombsLeft) " + strLocal("bomb") + "\(ending(bombsLeft, lang))"
        }
    }
    
    func replaceBomb(button : NSB) {
        button.alternateImage = nil
        var l = 0
        var pos = Int(arc4random_uniform(UInt32(width * height - bombAmount)))
        for but in ar {
            if but.alternateImage != bombImage {
                l++
            }
            if l == pos + 1 {
                but.alternateImage = bombImage
                loadMines(but, desk: true, butToDesk: button)
                break
            }
        }
    }
    
    /// One of buttons was pressed with left mouse button
    func buttonPressed(sender : NSB) {
        if sender.image != flagImage {
            curMoves++
            if curMoves == 1 && sender.alternateImage == bombImage {
                while sender.alternateImage == bombImage {
                    replaceBomb(sender)
                }
                press(sender)
                if elapsedTime == 0 {
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("incTime:"), userInfo: nil, repeats: true)
                }
            }
            else if elapsedTime == 0 && curMoves == 1 {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("incTime:"), userInfo: nil, repeats: true)
                press(sender)
            }
            else if sender.alternateImage == bombImage {
                for button in ar {
                    if button.alternateImage == bombImage {
                        button.image = button.alternateImage
                    }
                }
                lose()
            }
            else {
                press(sender)
                checkForWin()
            }
        }
    }
    
    func checkForWin() {
        var pressed = 0
        var flags = 0
        var corFlags = 0
        for but in ar {
            if !but.enabled {
                pressed++
            }
            if but.image == flagImage {
                flags++
            }
            if but.image == flagImage && but.alternateImage == bombImage {
                corFlags++
            }
        }
        if pressed == height * width - bombAmount || (flags == bombAmount && flags == corFlags) {
            win()
        }
    }
    
    /// Called when player wins
    func win() {
        var al = NSAlert()
        al.showsHelp = false
        al.messageText = strLocal("won")
        var congr = strLocal("time")
        var lang = 1
        if congr == "second" {
            lang = 2
        }
        var key = level + "mwHighscore" + "\(height)" + "x" + "\(width)"
        if storage.integerForKey(key) == 0 || time < storage.integerForKey(key) {
            storage.setInteger(time, forKey: key)
            congr = strLocal("congrPart1") + "\(time) " + "\(congr + ending(time, lang))" + strLocal("congrPart2")
        }
        else {
            congr = strLocal("succP1") +  "\(time) \(congr + ending(time, lang)), " + strLocal("succP2") + "\(storage.integerForKey(key)) \(congr + ending(storage.integerForKey(key), lang))"
        }
        storage.synchronize()
        
        al.informativeText = congr
        al.addButtonWithTitle(strLocal("newGame"))
        al.addButtonWithTitle(strLocal("changeHardness"))
        al.addButtonWithTitle(strLocal("quit"))
        al.addButtonWithTitle(strLocal("anGame"))
        var responseTag = NSModalResponse()
        responseTag = al.runModal()
        switch responseTag {
        case NSAlertFirstButtonReturn:
            newGame()
        case NSAlertSecondButtonReturn:
            clearView()
            self.view.window?.close()
            self.performSegueWithIdentifier("changeHardness", sender: self)
        case NSAlertThirdButtonReturn:
            exit(0)
        default:
            clearView()
            self.view.window?.close()
        }
        flagTimer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("delImages:"), userInfo: nil, repeats: false)
    }
    
    func delImages(sender : AnyObject) {
        for but in ar {
            but.image = nil
        }
        timer.invalidate()
    }
    
    func press(butToPress : NSB) {
        if butToPress.enabled {
            butToPress.enabled = false
            var color = NSColor()
            switch butToPress.alternateTitle {
            case "":
                color = NSColor.greenColor()
            case "1":
                color = NSColor.brownColor()
            case "2":
                color = NSColor.redColor()
            case "3":
                color = NSColor.magentaColor()
            case "4":
                color = NSColor.orangeColor()
            case "5":
                color = NSColor.cyanColor()
            case "6":
                color = NSColor.purpleColor()
            case "7":
                color = NSColor.blueColor()
            default:
               color = NSColor.yellowColor()
            }
            butToPress.image = NSImage.swatchWithColor(color, size: NSSize(width: 30, height: 30))
            butToPress.title = butToPress.alternateTitle
            if butToPress.title == "" {
                self.view.addSubview(indicator)
                indicator.startAnimation(nil)
                recOpen(butToPress)
                indicator.stopAnimation(nil)
                indicator.removeFromSuperview() 
            }
        }
    }
    
    func recOpen(button : NSB) {
        var tag = button.tag
        for but in ar {
            if checkerUn(tag: tag, but: but) {
                press(but)
            }
        }
    }
    
    func addFlag(sender : NSGestureRecognizer) {
        if let but = sender.view as? NSB {
            if (delay > 1 || flagMoves == 0) && but.enabled {
                if elapsedTime == 0 {
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("incTime:"), userInfo: nil, repeats: true)
                }
                if but.image == flagImage {
                    deleteFlag(but)
                }
                else {
                    putFlag(but)
                }
                checkForWin()
            }
            delay = 0
            flagMoves++
        }
        
    }
    
    func putFlag(but : NSB) {
        if but.enabled {
            but.image = flagImage
            bombsLeft--
        }
    }
    
    func deleteFlag(but : NSB) {
        but.image = nil
        bombsLeft++
    }
    
    /// Start new game
    func newGame() {
        clearView()
        placeBombs()
    }
    
    /// Function that's called after lose
    func lose() {
        var al = NSAlert()
        al.showsHelp = false
        al.messageText = strLocal("lost")
        al.informativeText = strLocal("replay")
        al.addButtonWithTitle(strLocal("newGame"))
        al.addButtonWithTitle(strLocal("changeHardness"))
        al.addButtonWithTitle(strLocal("quit"))
        al.addButtonWithTitle(strLocal("anGame"))
        var responseTag = NSModalResponse()
        responseTag = al.runModal()
        switch responseTag {
        case NSAlertFirstButtonReturn:
            newGame()
        case NSAlertSecondButtonReturn:
            clearView()
            self.view.window?.close()
            self.performSegueWithIdentifier("changeHardness", sender: self)
        case NSAlertThirdButtonReturn:
            exit(0)
        default:
            clearView()
            self.view.window?.close()
        }
    }
    
    func clearView() {
        for but in ar {
            but.enabled = true
            but.title = ""
            but.image = nil
            but.alternateTitle = ""
            but.alternateImage = nil
        }
        timer.invalidate()
        curMoves = 0
        time = 0
        elapsedTime = 0
        bombsLeft = bombAmount
        flagMoves = -1
        delay = 0
        curTime.stringValue = "0"
        self.view.window?.title = strLocal("ms")
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        activeGame = "bomb"
        self.view.window?.makeKeyAndOrderFront(nil)
        self.view.window?.title = strLocal("ms")
        self.view.window?.styleMask = NSClosableWindowMask | NSTitledWindowMask | NSMiniaturizableWindowMask
        height = storage.integerForKey("mwHeight")
        width = storage.integerForKey("mwWidth")
        
        var k = 0
        switch storage.integerForKey("mwHardness") {
        case 0:
            k = 8
            level = "easy"
        case 1:
            k = 5
            level = "meduim"
        case 2:
            k = 3
            level = "hard"
        case 3:
            k = 2
            level = "extreme"
        default:
            break
        }
        bombAmount = height * width / k
        
        var frame = self.view.window?.frame
        var newHeight = CGFloat(height * 30 + 100)
        var newWidth = CGFloat(width * 30)
        frame?.size = NSMakeSize(newWidth, newHeight)
        self.view.window?.setFrame(frame!, display: true)
        
        var x = 0
        var y = 0
        k = 1
        for i in 1...height {
            for j in 1...width {
                var but = NSB(frame: NSRect(x: x, y: y + 78, width: 30, height: 32))
                but.tag = k
                but.title = ""
                but.action = Selector("buttonPressed:")
                but.target = self
                but.bezelStyle = NSBezelStyle(rawValue: 10)!
                
                var ges = NSClickGestureRecognizer(target: self, action: Selector("addFlag:"))
                ges.buttonMask = 0x2
                ges.numberOfClicksRequired = 1
                but.addGestureRecognizer(ges)
                
                ar.append(but)
                self.view.addSubview(but)
                x += 30
                k++
            }
            y += 30
            x = 0
        }
        
        curTime = NSTextField(frame: NSRect(x: (width * 30) ~~ 2 - 60, y: 0, width: 120, height: 70))
        curTime.font = NSFont(name: "Helvetica", size: 30.0)
        curTime.stringValue = "0"
        curTime.alignment = NSTextAlignment(rawValue: 2)!
        curTime.editable = false
        curTime.selectable = false
        curTime.backgroundColor = self.view.window?.backgroundColor
        curTime.bordered = false
        self.view.addSubview(curTime)
        
        indicator = NSProgressIndicator(frame: NSRect(x: self.view.frame.size.width / 2 - 25, y: self.view.frame.size.height / 2 - 25, width: 50, height: 50))
        indicator.style = NSProgressIndicatorStyle.SpinningStyle
        indicator.usesThreadedAnimation = true
        indicator.bezeled = true
        indicator.controlTint = NSControlTint.BlueControlTint
        placeBombs()
        bombsLeft = bombAmount
        
        var but = NSB(frame: NSRt(x: 0, y: 0, width: 0, height: 0))
        but.keyEquivalent = " "
        but.target = self
        but.action = Selector("speechFunc:")
        self.view.addSubview(but)
        recognizer.commands = ["pause", "play", "exit", "пауза", "продолжить", "выйти"]
        recognizer.blocksOtherRecognizers = true
        recognizer.delegate = self
        
        self.view.window?.center()
    }
    
    /// Place bombs on field
    func placeBombs() {
        self.view.addSubview(indicator)
        indicator.startAnimation(nil)
        var test = 0
        while test < bombAmount {
            var pos = Int(arc4random_uniform(UInt32(width * height)))
            while ar[pos].alternateImage == bombImage {
                pos = Int(arc4random_uniform(UInt32(width * height)))
            }
            ar[pos].alternateImage = bombImage
            loadMines(ar[pos], desk: false, butToDesk: nil)
            test++
        }
        indicator.stopAnimation(nil)
        indicator.removeFromSuperview()
    }
    
    ///Load number of bombs to all buttons around `button`
    func loadMines(button : NSB, desk : Bool, butToDesk : NSB?) {
        var tag = button.tag
        var deskTag = 0
        if desk {
            deskTag = butToDesk!.tag
        }
        for but in ar {
            if checkerUn(tag: tag, but: but) {
                but.alternateTitle = but.alternateTitle.addOne()
            }
            if desk {
                if checkerUn(tag: deskTag, but: but) {
                    but.alternateTitle = but.alternateTitle.addN(-1)
                }
                if but.alternateTitle == "0" {
                    but.alternateTitle = ""
                }
            }
        }
    }
    
    func checkerUn(#tag : Int, but : NSB) -> Bool {
        var ifOne = (but.tag == tag + 1 && tag % width != 0) || (but.tag == tag - 1 && tag % width != 1)
        var ifTwo = (but.tag == tag + width && tag <= width * (height - 1)) || (but.tag == tag + width - 1 && tag % width != 1)
        var ifThree = (but.tag == tag + width + 1 && tag % width != 0) || (but.tag == tag - width && tag > width)
        var ifFour = (but.tag == tag - width - 1 && tag % width != 1) || (but.tag == tag - width + 1 && tag % width != 0)
        return ifOne || ifTwo || ifThree || ifFour
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        activeGame = ""
    }
    
    var listening = false
    
    func speechFunc(sender : AnyObject) {
        if !listening {
            recognizer.startListening()
            listening = true
        }
        else {
            recognizer.stopListening()
            listening = false
        }
    }
    
    func speechRecognizer(sender: NSSpeechRecognizer, didRecognizeCommand command: AnyObject?) {
        let com = command as! String
        if com == "pause" || com == "пауза" {
            println("pause")
        }
        if com == "play" || com == "продолжить" {
            println("play")
        }
        if com == "exit" || com == "выйти" {
            println("exit")
        }
    }
}