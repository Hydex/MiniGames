//
//  MinesweeperMain.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit

class MinesweeperMain: NSViewController {
    
    var height = 0
    var width = 0
    var bombAmount = 0
    var bombsLeft = 0
    var curMoves = 0
    var time = 0
    var elapsedTime = 0
    
    var level = ""
    
    var timer = NSTimer()
    
    var storage = NSUserDefaults.standardUserDefaults()
    
    var bombImage = NSImage(named: "Bomb.png")
    var flagImage = NSImage(named: "Flag.png")
    
    var ar : Array<NSButton> = []
    
    func incTime(sender : AnyObject) {
        elapsedTime++
        time = elapsedTime / 10
    }
    
    func replaceBomb(but : NSButton) {
        but.alternateImage = nil
        var l = 0
        var pos = Int(arc4random_uniform(UInt32(width * height - bombAmount)))
        for but in ar {
            if but.alternateImage != bombImage {
                l++
            }
            if l == pos + 1 {
                but.alternateImage = bombImage
                break
            }
        }
    }
    
    func buttonPressed(sender : NSButton) {
        curMoves++
        println(sender.tag)
        if curMoves == 1 && sender.alternateImage == bombImage {
            while sender.alternateImage == bombImage {
                replaceBomb(sender)
            }
            press(sender)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("incTime:"), userInfo: nil, repeats: true)
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
            var pressed = 0
            for but in ar {
                if but.alternateImage != bombImage && but.enabled == false {
                    pressed++
                }
            }
            if pressed == countElements(ar) - bombAmount {
                win()
            }
        }
    }
    
    func win() {
        var al = NSAlert()
        al.showsHelp = false
        al.messageText = "Вы победили!"
        var congr = ""
        var key = level + "mwHighscore"
        if storage.integerForKey(key) == 0 {
            storage.setInteger(time, forKey: key)
            congr = "Поздравляю! Новый Рекорд!\nВаше время - \(time) секунд!\nХотите начать новую игру или сменить уровень сложности?"
        }
        else if time < storage.integerForKey("mwHighscore") {
            congr = "Поздравляю! Новый Рекорд!\nВаше время - \(time) секунд!\nХотите начать новую игру или сменить уровень сложности?"
        }
        else {
            congr = "Вы справились за \(time) секунд, ваш рекорд - \(storage.integerForKey(key)) секунд"
        }
        
        al.informativeText = congr
        al.addButtonWithTitle("Новая игра")
        al.addButtonWithTitle("Сменить уровень сложности")
        al.addButtonWithTitle("Выйти из приложения")
        var responseTag = NSModalResponse()
        responseTag = al.runModal()
        switch responseTag {
        case NSAlertFirstButtonReturn:
            newGame()
        case NSAlertSecondButtonReturn:
            self.dismissController(MinesweeperMain)
            self.performSegueWithIdentifier("changeHardness", sender: self)
        case NSAlertThirdButtonReturn:
            exit(0)
        default:
            break
        }
    }
    
    func press(butToPress : NSButton) {
        butToPress.enabled = false
        butToPress.title = butToPress.alternateTitle
        butToPress.image = nil
        println("pressed")
    }
    
    func addFlag(sender : NSGestureRecognizer) {
        if let but = sender.view as? NSButton {
            if but.image == flagImage {
                but.image = nil
                bombsLeft++
                var res = 0
                for each in ar {
                    if each.image == flagImage && each.alternateImage == bombImage {
                        res++
                    }
                }
                if res == bombAmount {
                    win()
                }
            }
            else {
                but.image = flagImage
                bombsLeft--
            }
        }
    }
    
    func newGame() {
        for but in ar {
            but.enabled = true
            but.title = ""
            but.image = nil
            but.alternateTitle = ""
            but.alternateImage = nil
        }
        timer.invalidate()
        placeBombs()
        curMoves = 0
        time = 0
        elapsedTime = 0
        bombsLeft = bombAmount
    }
    
    func lose() {
        var al = NSAlert()
        al.showsHelp = false
        al.messageText = "Вы проиграли!"
        al.informativeText = "Вы хотите переиграть или начать новую игру?"
        al.addButtonWithTitle("Новая игра")
        al.addButtonWithTitle("Сменить уровень сложности")
        al.addButtonWithTitle("Выйти из приложения")
        var responseTag = NSModalResponse()
        responseTag = al.runModal()
        switch responseTag {
        case NSAlertFirstButtonReturn:
            newGame()
        case NSAlertSecondButtonReturn:
            self.dismissController(MinesweeperMain)
            self.performSegueWithIdentifier("changeHardness", sender: self)
        case NSAlertThirdButtonReturn:
            exit(0)
        default:
            break
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.orderFront(self)
        
        self.view.window?.title = "Сапер"
        
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
            var al = NSAlert()
            al.showsHelp = false
            al.informativeText = "Open the previous window again"
            al.messageText = "Wrong hardness choose"
            al.runModal()
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
                var but = NSButton(frame: NSRect(x: x, y: y + 78, width: 30, height: 30))
                but.tag = k
                but.title = ""
                but.action = Selector("buttonPressed:")
                but.target = self
                but.bezelStyle = NSBezelStyle(rawValue: 6)!
                
                var ges = NSClickGestureRecognizer()
                ges.target = self
                ges.buttonMask = 0x2
                ges.numberOfClicksRequired = 1
                ges.action = Selector("addFlag:")
                but.addGestureRecognizer(ges)
                
                ar.append(but)
                self.view.addSubview(but)
                x += 30
                k++
            }
            y += 30
            x = 0
        }
        placeBombs()
        bombsLeft = bombAmount
    }
    
    var i = 0
    
    func placeBombs() {
        var test = 0
        println(i)
        i++
        while test < bombAmount {
            var pos = Int(arc4random_uniform(UInt32(width * height)))
            while ar[pos].alternateImage == bombImage {
                pos = Int(arc4random_uniform(UInt32(width * height)))
            }
            ar[pos].alternateImage = bombImage
            
            var nBut = ar[pos]
            for but in ar {
                println("freezes")
                if (but.tag == nBut.tag + 1 && nBut.tag % width != 0) || (but.tag == nBut.tag - 1 && nBut.tag % width != 1) || (but.tag == nBut.tag + width) || (but.tag == nBut.tag + width - 1 && nBut.tag % width != 1) || (but.tag == nBut.tag + width + 1 && nBut.tag % width != 0) || (but.tag == nBut.tag - width) || (but.tag == nBut.tag - width - 1 && nBut.tag % width != 1) || (but.tag == nBut.tag - width + 1 && nBut.tag % width != 0) {
                    but.alternateTitle = but.alternateTitle.addOne()
                }
            }
            test++
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}