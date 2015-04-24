//
//  Classes, functions and extensions.swift
//  MiniGames tests
//
//  Created by Roman Nikitin on 31.03.15.
//  Copyright (c) 2015 Roman Nikitin. All rights reserved.
//

import Foundation
import Cocoa
import AppKit
import SpriteKit


class File {
    
    class func exists (path: String) -> Bool {
        return NSFileManager().fileExistsAtPath(path)
    }
    
    class func read (path: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> String? {
        if File.exists(path) {
            return String(contentsOfFile: path, encoding: encoding, error: nil)!
        }
        
        return nil
    }
    
    class func write (path: String, content: String, encoding: NSStringEncoding = NSUTF8StringEncoding) -> Bool {
        return content.writeToFile(path, atomically: true, encoding: encoding, error: nil)
    }
}

extension String {
    func removeFromEnd(count : Int) -> String {
        let stringLength = self.length
        let substringIndex = (stringLength < count) ? 0 : stringLength - count
        return self.substringToIndex(advance(self.startIndex, substringIndex))
    }
    
    func containsAnyCase(var smth:String) -> Bool {
        var index = startIndex
        smth = smth.lowercaseString
        do {
            var sub = self[Range(start:index++, end : endIndex)]
            if sub.lowercaseString.hasSuffix(smth) {
                return true
            }
        } while index != endIndex
        return false
    }
    
    func substring(start : Int, length : Int) -> String {
        var range = Range(start: advance(self.startIndex, start), end: advance(self.startIndex, start + length))
        return self.substringWithRange(range)
    }
    
    var length : Int {
        return count(self)
    }
    
    func reverse() -> String {
        var reverseString : String = ""
        for c in self
        {
            reverseString = "\(c)" + reverseString
        }
        return reverseString
    }
    
    func addOne() -> String {
        if self.isEmpty {
            return "1"
        }
        else {
            return "\(self.toInt()! + 1)"
        }
    }
    
    func addN(n : Int) -> String {
        if self.isEmpty {
            return "\(n)"
        }
        else {
            return "\(self.toInt()! + n)"
        }
    }
    
    func isNumber() -> Bool {
        if (self.toInt() != nil) {
            return true
        }
        else {
            return false
        }
    }
}

infix operator ~~ {
associativity left
precedence 155
}

func ~~ (left: Int, right : Int) -> Int  {
    return Int(Double(left) / Double(right))
}

infix operator ~~~ {
associativity left
precedence 155
}

func ~~~(left: Int, right: Int) -> Int {
    return Int(llround(Double(left) / Double(right)))
}

extension NSEvent {
    var character: Int {
        let str = charactersIgnoringModifiers!.utf16
        return Int(str[str.startIndex])
    }
}

extension NSImage {
    class func swatchWithColor(color: NSColor, size: NSSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatchInRect(NSMakeRect(0, 0, size.width, size.height))
        image.unlockFocus()
        return image
    }
}

func contStr(ar : Array<NSTextField>, str : String) -> Bool {
    var u = false
    for el in ar {
        if el.stringValue == str {
            u = true
            break
        }
    }
    return u
}

func arContInt(ar : Array<Int>, t : Int) -> Bool {
    var u = false
    for el in ar {
        if el == t {
            u = true
            break
        }
    }
    return u
}

extension Character {
    var keyCode: Int {
        let utf16view = String(self).utf16
        return Int(utf16view[utf16view.startIndex])
    }
}

func strLocal(key : String) -> String {
    return NSLocalizedString(key, comment: "")
}

func ending(num : Int, lang : Int) -> String {
    if lang == 1 {
        if num % 10 == 0 || num ~~ 10 % 10 == 1 || (num % 10 <= 9 && num % 10 > 4) {
            return ""
        }
        else {
            if num % 10 == 1 {
                return "а"
            }
            else {
                return "ы"
            }
        }
    }
    else {
        if num == 1 {
            return ""
        }
        else {
            return "s"
        }
    }
}

func endingMale(num : Int, lang : Int) -> String {
    if lang == 1 {
        if num % 10 == 0 || num ~~ 10 % 10 == 1 || (num % 10 <= 9 && num % 10 > 4) {
            return "ов"
        }
        else {
            if num % 10 == 1 {
                return ""
            }
            else {
                return "а"
            }
        }
    }
    else {
        if num == 1 {
            return ""
        }
        else {
            return "s"
        }
    }
}

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(#min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
}

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

func abs(n : CGFloat) -> CGFloat {
    if n <= 0 {
        return n
    }
    else {
        return -n
    }
}
