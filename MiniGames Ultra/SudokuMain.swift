//
//  SudokuMain.swift
//  MiniGames Ultra
//
//  Created by Nik on 06.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa
import CoreWLAN

class SudokuMain: NSViewController {
    
    var ar : Array<Array<NSTextField>> = []
    var but = NSButton()
    var solution : Array<Array<Int>> = []
    var testArr = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    var tarrr : Array<Array<NSTextField>> = []
    var storage = NSUserDefaults.standardUserDefaults()
    var level = ""
    var timer = NSTimer()
    var interval : Double = 5
    var time = 0
    var elapsedTime = 0
    var won = true
    
    override func viewDidAppear() {
        super.viewWillAppear()
        activeGame = "sudoku"
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
        var frame = self.view.window?.frame
        var newHeight = CGFloat(550)
        var newWidth = CGFloat(460)
        frame?.size = NSMakeSize(newWidth, newHeight)
        self.view.window?.setFrame(frame!, display: true)
        self.view.window?.title = strLocal("sudoku")
        var color = Col()
        if let data = storage.objectForKey("sudokuColor") as? NSData {
            if let col = NSUnarchiver.unarchiveObjectWithData(data) as? Col {
                color = col
            }
        }
        self.view.window?.backgroundColor = color
        self.view.window?.center()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var x = CGFloat(0)
        var y = CGFloat(410)
        var tag = 0
        var b = 0
        elapsedTime = 0
        won = true
        
        if storage.boolForKey("isContinuation") {
            storage.setBool(false, forKey: "continueSudoku")
            storage.synchronize()
            if let data = storage.objectForKey("sudokuArray") as? NSData {
                if let a = NSUnarchiver.unarchiveObjectWithData(data) as? Array<Array<NSTextField>> {
                    ar = a
                }
            }
            if let data = storage.objectForKey("sudokuSolution") as? NSData {
                if let s = NSUnarchiver.unarchiveObjectWithData(data) as? Array<Array<Int>> {
                    solution = s
                }
            }
            time = storage.integerForKey("sudokuTime")
        }
        else {
            for var i = 0; i < 9; i++ {
                b++
                var tmpar : Array<NSTextField> = []
                var c = 0
                for var j = 0; j < 9; j++ {
                    c++
                    tag++
                    var cell = NSTextField(frame: NSRect(x: x, y: y + 69, width: 50, height: 50))
                    cell.selectable = false
                    cell.editable = false
                    cell.alignment = NSTextAlignment(rawValue: 2)!
                    cell.font = NSFont(name: "Helvetica", size: 30)
                    cell.stringValue = "\((i * 3 + i ~~ 3 + j) % 9 + 1)"
                    cell.tag = tag
                    tmpar.append(cell)
                    if c % 3 == 0 {
                        x += 55
                    }
                    else {
                        x += 50
                    }
                }
                ar.append(tmpar)
                x = 0
                if b % 3 == 0 {
                    y -= 55
                }
                else {
                    y -= 50
                }
            }
        }
        
        for each in ar {
            for element in each {
                self.view.addSubview(element)
            }
        }
        
        but = NSButton(frame: NSRect(x: 0, y: -0.5, width: 460, height: 70))
        but.action = Selector("solutionFunc:")
        but.alignment = NSTextAlignment(rawValue: 2)!
        but.font = NSFont(name: "Helvetica", size: 30)
        but.image = NSImage.swatchWithColor(Col.whiteColor(), size: but.frame.size)
        but.bezelStyle = NSBezelStyle(rawValue: 10)!
        but.title = "Solution"
        but.target = self
        self.view.addSubview(but)
        if !storage.boolForKey("isContinuation") {
        
            var r = Int(arc4random_uniform(120)) + 200
            for var i = 0; i < r; i++ {
                var a = Int(arc4random_uniform(4))
                switch a {
                case 1:
                    var bl = Int(arc4random_uniform(3))
                    var n1 = Int(arc4random_uniform(3)) + 3 * bl
                    var n2 = 3 * bl
                    while n1 == n2 {
                        n2 = Int(arc4random_uniform(3)) + 3 * bl
                    }
                    swapRowsSmall(n1, num2: n2)
                case 2:
                    var n1 = Int(arc4random_uniform(3))
                    var n2 = 0
                    while n1 == n2 {
                        n2 = Int(arc4random_uniform(3))
                    }
                    swapRowsSmall(n1, num2: n2)
                case 3:
                    var bl = Int(arc4random_uniform(3))
                    var n1 = Int(arc4random_uniform(3)) + 3 * bl
                    var n2 = 3 * bl
                    while n1 == n2 {
                        n2 = Int(arc4random_uniform(3)) + 3 * bl
                    }
                    swapColsSmall(n1, num2: n2)
                default:
                    var n1 = Int(arc4random_uniform(3))
                    var n2 = 0
                    while n1 == n2 {
                        n2 = Int(arc4random_uniform(3))
                    }
                    swapColsBig(n1, num2: n2)
                }
            }
            
            for var i = 0; i < 9; i++ {
                var tmpAr : Array<Int> = []
                for var j = 0; j < 9; j++ {
                    tmpAr.append(ar[i][j].integerValue)
                }
                solution.append(tmpAr)
            }
        
            var k = 0
            switch storage.integerForKey("sudokuHardness") {
            case 0:
                level = "easy"
                k = Int(arc4random_uniform(7)) + 38
            case 1:
                level = "medium"
                k = Int(arc4random_uniform(7)) + 45
            case 2:
                level = "hard"
                k = Int(arc4random_uniform(7)) + 52
            default:
                level = "extreme"
                k = Int(arc4random_uniform(7)) + 59
            }
        
            for var i = 0; i < k; i++ {
                r = Int(arc4random_uniform(9))
                tag = Int(arc4random_uniform(9))
                while ar[r][tag].stringValue == "" {
                    var tmp = Int(arc4random_uniform(2))
                    if tmp == 1 {
                        r = Int(arc4random_uniform(9))
                    }
                    else {
                        tag = Int(arc4random_uniform(9))
                    }
                }
                ar[r][tag].stringValue = ""
                ar[r][tag].editable = true
                ar[r][tag].backgroundColor = Col.whiteColor()
                if storage.integerForKey("highlight") != 0 {
                    ar[r][tag].textColor = Col.blueColor()
                }
                ar[r][tag].tag = 1
            }
        }
        
        if storage.boolForKey("isContinuation") {
            storage.setBool(false, forKey: "isContinuation")
        }
        timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: Selector("checkForWin:"), userInfo: nil, repeats: true)
    }
    
    func swapRowsSmall(num1 : Int, num2 : Int) {
        for var i = 0; i < 9; i++ {
            var tmp = ar[num1][i].stringValue
            ar[num1][i].stringValue = ar[num2][i].stringValue
            ar[num2][i].stringValue = tmp
        }
    }
    
    func swapColsSmall(num1 : Int, num2 : Int) {
        for var i = 0; i < 9; i++ {
            var tmp = ar[i][num1].stringValue
            ar[i][num1].stringValue = ar[i][num2].stringValue
            ar[i][num2].stringValue = tmp
        }
    }
    
    func swapRowsBig(num1 : Int, num2 : Int) {
        swapRowsSmall(num1 * 3, num2: num2 * 3)
        swapRowsSmall(num1 * 3 + 1, num2: num2 * 3 + 1)
        swapRowsSmall(num1 * 3 + 2, num2: num2 * 3 + 2)
    }
    
    func swapColsBig(num1 : Int, num2 : Int) {
        swapColsSmall(num1 * 3, num2: num2 * 3)
        swapColsSmall(num1 * 3 + 1, num2: num2 * 3 + 1)
        swapColsSmall(num1 * 3 + 2, num2: num2 * 3 + 2)
    }
    
    func checkForWin(sender : AnyObject?) {
        var m = true
        elapsedTime++
        var timeStr = strLocal("time")
        var lang = 1
        if timeStr == "second" {
            lang = 2
        }
        self.view.window?.title = strLocal("sudoku") + " - " + strLocal("elapsed") + " \(time + (elapsedTime ~~ 2)) " + strLocal("time") + ending(time + (elapsedTime ~~ 2), lang)
        var opened = 0
        var nar = [0, 0, 0, 0, 0, 0, 0, 0, 0]
        for var i = 0; i < 9; i++ {
            for var j = 0; j < 9; j++ {
                if !contStr(ar[i], "\(j + 1)") {
                    m = false
                }
                if !arContInt(testArr, j + 1) {
                    m = false
                }
                if ar[i][j].stringValue.toInt() == nil || ar[i][j].integerValue == 0 {
                    ar[i][j].stringValue = ""
                }
                else if ar[i][j].integerValue > 9 || ar[i][j].integerValue < 1 {
                    ar[i][j].stringValue = ar[i][j].stringValue.substring(0, length: 1)
                }
                else {
                    nar[ar[i][j].integerValue - 1]++
                }
            }
        }
        if storage.integerForKey("highlight") != 0 {
            var k = 0
            for el in nar {
                if el == 9 {
                    k++
                    for e in ar {
                        for each in e {
                            if each.integerValue == k {
                                each.textColor = Col.greenColor()
                            }
                        }
                    }
                }
                else {
                    k++
                    for e in ar {
                        for each in e {
                            if each.integerValue == k {
                                if !each.editable {
                                    each.textColor = Col.blackColor()
                                }
                                else {
                                    each.textColor = Col.blueColor()
                                }
                            }
                        }
                    }
                }
            }
        }
        if m {
            timer.invalidate()
            println(storage.boolForKey("isContinuation"))
            won = false
            var al = NSAlert()
            al.showsHelp = false
            al.messageText = strLocal("won")
            al.informativeText = strLocal("replay")
            al.runModal()
            for el in ar {
                for each in el {
                    each.removeFromSuperview()
                }
            }
            ar.removeAll(keepCapacity: false)
            viewDidLoad()
        }
        tarrr = ar
    }
    
    func solutionFunc(sender : NSButton) {
        if sender.title == "Solution" {
            timer.invalidate()
            for var i = 0; i < 9; i++ {
                for var j = 0; j < 9; j++ {
                    ar[i][j].stringValue = "\(solution[i][j])"
                    if ar[i][j].editable {
                        ar[i][j].textColor = Col.blueColor()
                    }
                    else {
                        ar[i][j].textColor = Col.blackColor()
                    }
                }
            }
            sender.title = "New game"
            won = false
        }
        else {
            for each in ar {
                for e in each {
                    e.removeFromSuperview()
                }
            }
            ar.removeAll(keepCapacity: false)
            solution.removeAll(keepCapacity: false)
            but.removeFromSuperview()
            viewDidLoad()
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        activeGame = ""
        if won {
            var al = NSAlert()
            al.showsHelp = false
            al.messageText = "Do you want to save game?"
            al.informativeText = "You'll be able to continue this game the next time you'll open Sudoku"
            al.addButtonWithTitle("Save and exit")
            al.addButtonWithTitle("Quit without saving")
            var response = al.runModal()
            if response == NSAlertFirstButtonReturn {
                var curAr = NSArchiver.archivedDataWithRootObject(ar)
                var solAr = NSArchiver.archivedDataWithRootObject(solution)
                storage.setObject(curAr, forKey: "sudokuArray")
                storage.setObject(solAr, forKey: "sudokuSolution")
                storage.setInteger(time, forKey: "sudokuTime")
                storage.setBool(true, forKey: "continueSudoku")
            }
        }
        else {
            storage.setBool(false, forKey: "isContinuation")
            storage.setBool(false, forKey: "continueSudoku")
        }
        storage.synchronize()
    }
}