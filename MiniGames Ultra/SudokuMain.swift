//
//  SudokuMain.swift
//  MiniGames Ultra
//
//  Created by Nik on 06.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Cocoa

class SudokuMain: NSViewController {
    
    var ar : Array<Array<NSTextField>> = []

    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window?.styleMask = NSClosableWindowMask | NSMiniaturizableWindowMask | NSTitledWindowMask
        var frame = self.view.window?.frame
        var newHeight = CGFloat(470)
        var newWidth = CGFloat(450)
        frame?.size = NSMakeSize(newWidth, newHeight)
        self.view.window?.setFrame(frame!, display: true)
        
        var x = CGFloat(0)
        var y = CGFloat(400)
        var tag = 0
        for var i = 0; i < 9; i++ {
            var tmpar : Array<NSTextField> = []
            for var j = 0; j < 9; j++ {
                var cell = NSTextField(frame: NSRect(x: x, y: y, width: 50, height: 50))
                cell.selectable = false
                cell.editable = false
                cell.alignment = NSTextAlignment(rawValue: 2)!
                cell.font = NSFont(name: "Helvetica", size: 30)
                cell.stringValue = "\((i * 3 + i ~~ 3 + j) % 9 + 1)"
                cell.tag = tag
                tmpar.append(cell)
                
                x += 50
                tag++
            }
            ar.append(tmpar)
            x = 0
            y -= 50
        }
        
        swapColsBig(0, num2: 1)
        
        for each in ar {
            for element in each {
                self.view.addSubview(element)
            }
        }
    }
    
    func transposeField() {
        var tmparr : Array<Array<NSTextField>> = ar
        for var i = 0; i < 9; i++ {
            for var j = 0; j < 9; j++ {
                tmparr[i][j].stringValue = ar[j][i].stringValue
            }
        }
        ar = tmparr
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
    
    func checkForWin() -> Bool {
        var m = true
        for var i = 0; i < 9; i++ {
            for var j = 0; j < 9; j++ {
                if !ar.containsStr("\(j + 1)") {
                    m = false
                }
            }
        }
        return m
    }
}
