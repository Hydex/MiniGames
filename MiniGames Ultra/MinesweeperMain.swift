//
//  MinesweeperMain.swift
//  MiniGames Ultra
//
//  Created by Nik on 29.03.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import AppKit

func /(left: Int, right : Int) -> Int {
    return Int(Double(left) / Double(right))
}

extension String {
    func addOne() -> String {
        if self.isEmpty {
            return "1"
        }
        else {
            return "\(self.toInt()! + 1)"
        }
    }
}

class MinesweeperMain: NSViewController {
    
    var height = 0
    var width = 0
    var bombAmount = 0
    var bombsLeft = 0
    var curMoves = 0
    
    var bombImage = NSImage(named: "Bomb.png")
    
    var ar : Array<NSButton> = []
    
    var storage = NSUserDefaults.standardUserDefaults()
    
    func buttonPressed(sender : NSButton) {
        curMoves++
        println(sender.tag)
        if curMoves == 1 && sender.alternateImage == bombImage {
            while sender.alternateImage == bombImage {
                placeBombs()
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
        }
    }
    
    func press(butToPress : NSButton) {
        butToPress.enabled = false
        butToPress.title = butToPress.alternateTitle
    }
    
    func addFlag(sender : NSGestureRecognizer) {
        if let but = sender.view as? NSButton {
            but.image = NSImage(named: "Flag.png")
        }
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
            for but in ar {
                but.enabled = true
                but.title = ""
                but.image = nil
                but.alternateTitle = ""
                but.alternateImage = nil
            }
            placeBombs()
            curMoves = 0
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
        case 1:
            k = 5
        case 2:
            k = 3
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
    }
    
    func placeBombs() {
        var test = 0
        println(bombAmount)
        while test < bombAmount {
            var pos = Int(arc4random_uniform(UInt32(width * height)))
            while ar[pos].alternateImage == bombImage {
                pos = Int(arc4random_uniform(UInt32(width * height)))
            }
            ar[pos].alternateImage = bombImage
            println(bombAmount)
            
            var nBut = ar[pos]
            for but in ar {
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