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
        let stringLength = countElements(self)
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
        return countElements(self)
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

func /(left: Int, right : Int) -> Int {
    return Int(Double(left) / Double(right))
}

extension NSEvent {
    var character: Int {
        return Int(charactersIgnoringModifiers!.utf16[0])
    }
}

extension Character {
    var keyCode: Int {
        return Int(String(self).utf16[0])
    }
}
