//
//  GameClass.swift
//  MiniGames Ultra
//
//  Created by Roman Nikitin on 01.04.15.
//  Copyright (c) 2015 TheUnbelievable. All rights reserved.
//

import Foundation
import Cocoa
import AppKit

class Game {
    
    required init(num : CGFloat, picName : String, gameName : String, description : String) {
        self.number = num
        self.pictureName = picName
        self.name = gameName
        self.desc = description
    }
    
    var number : CGFloat
    var pictureName : String
    var name : String
    var desc : String
    
    var image : NSImage {
        return NSImage(named: pictureName)!
    }
    
    var imageView : NSImageView {
        return NSImageView(frame: NSRect(x: 0, y: 100 * (number - 1), width: 100, height: 100))
    }
    
    var nameField : NSTextField {
        return NSTextField(frame: NSRect(x: 110, y: 100 * (number - 1), width: 300, height: 30))
    }
    
    var descField : NSTextField {
        return NSTextField(frame: NSRect(x: 110, y: 100 * (number - 1) - 40, width: 300, height: 60))
    }
    
    
    func setImage() {
        imageView.image = image
    }
    
    func setNameField() {
        nameField.font = NSFont(name: "System", size: 15.0)
        nameField.stringValue = "Name"
        nameField.alignment = NSTextAlignment(rawValue: 2)!
        nameField.selectable = false
        nameField.editable = false
    }
    
    func setDescField() {
        descField.selectable = false
        descField.editable = false
        descField.stringValue = desc
        descField.font = NSFont(name: "System", size: 11.0)
    }
    
}
