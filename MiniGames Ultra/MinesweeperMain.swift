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
    /// Time to add as highscore
    var time = 0
    var elapsedTime = 0
    var delay = 0
    var flagMoves = 0
    
    /// Hardness level
    var level = ""
    
    var timer = NSTimer()
    
    var storage = NSUserDefaults.standardUserDefaults()
    var bombImage = NSImage(named: "Bomb.png")
    var flagImage = NSImage(named: "Flag.png")
    
    var ar : Array<NSButton> = []
    
    
    /// Main timer function
    func incTime(sender : AnyObject) {
        elapsedTime++
        time = elapsedTime / 10
        delay++
    }
    
    /**
        Replace the bomb if the first button pressed is bomb
        
        :param: but The button that is pressed
    */
    
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
    
    /// One of buttons was pressed with left mouse button
    func buttonPressed(sender : NSButton) {
        curMoves++
        println(sender.tag)
        if curMoves == 1 && sender.alternateImage == bombImage {
            while sender.alternateImage == bombImage {
                replaceBomb(sender)
            }
            press(sender)
            if elapsedTime == 0 {
                timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("incTime:"), userInfo: nil, repeats: true)
            }
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
    
    /// Called when player wins
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
    
    /**
        Add flag to a button
    
        :param: sender The NSClickGestureRecognizer of clicked button
    */
    
    func addFlag(sender : NSGestureRecognizer) {
        println(delay)
        if let but = sender.view as? NSButton {
            if delay > 1 || flagMoves == 0 && but.enabled {
                if elapsedTime == 0 {
                    timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: Selector("incTime:"), userInfo: nil, repeats: true)
                }
                if but.image == flagImage {
                    deleteFlag(but)
                }
                else {
                    putFlag(but)
                }
            }
            delay = 0
            flagMoves++
        }
        
    }
    
    func putFlag(but : NSButton) {
        but.image = flagImage
        bombsLeft--
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
    
    func deleteFlag(but : NSButton) {
        but.image = nil
        println("deleteFlag")
        bombsLeft++
    }
    
    /// Start new game
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
        flagMoves = 0
    }
    
    /// Function that's called after lose
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
    
    
    /// Place bombs on field
    func placeBombs() {
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
    }
    
    /**
        Load number of mines to all buttons around button with a bomb
    
        :param: button The button with the bomb
        :param: desk Descrease number of bombs around butToDesk or not
        :param: butToDesk Button, around which the number of bombs will be descreased
    */
    
    func loadMines(button : NSButton, desk : Bool, butToDesk : NSButton?) {
        var tag = button.tag
        var deskTag = 0
        if desk {
            deskTag = butToDesk!.tag
        }
        for but in ar {
            var ifOne = (but.tag == tag + 1 && tag % width != 0) || (but.tag == tag - 1 && tag % width != 1)
            var ifTwo = (but.tag == tag + width && tag <= width * (height - 1)) || (but.tag == tag + width - 1 && tag % width != 1)
            var ifThree = (but.tag == tag + width + 1 && tag % width != 0) || (but.tag == tag - width && tag > width)
            var ifFour = (but.tag == tag - width - 1 && tag % width != 1) || (but.tag == tag - width + 1 && tag % width != 0)
            if ifOne || ifTwo || ifThree || ifFour {
                but.alternateTitle = but.alternateTitle.addOne()
            }
            if desk {
                var deskIfOne = (but.tag == deskTag + 1 && deskTag % width != 0) || (but.tag == deskTag - 1 && deskTag % width != 1)
                var deskIfTwo = (but.tag == deskTag + width) || (but.tag == deskTag + width - 1 && deskTag % width != 1)
                var deskIfThree = (but.tag == deskTag + width + 1 && deskTag % width != 0) || (but.tag == deskTag - width)
                var deskIfFour = (but.tag == deskTag - width - 1 && deskTag % width != 1) || (but.tag == deskTag - width + 1 && deskTag % width != 0)
                if deskIfOne || deskIfTwo || deskIfThree || deskIfFour {
                    but.alternateTitle = but.alternateTitle.addN(-1)
                }
            }
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}