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
    
    init(num : CGFloat, picName : String, gameName : String, description : String, windowHeight : CGFloat, sender : NSViewController) {
        self.number = num
        self.pictureName = picName
        self.name = gameName
        self.desc = description
        self.height = windowHeight
        imageView = NSImageView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        nameField = NSTextField(frame: NSRect(x: 110, y: 60, width: 300, height: 30))
        descField = NSTextField(frame: NSRect(x: 110, y: 0, width: 300, height: 60))
        
        nameField.font = NSFont(name: "System", size: 15.0)
        nameField.stringValue = self.name
        nameField.alignment = NSTextAlignment(rawValue: 2)!
        nameField.selectable = false
        nameField.editable = false
        nameField.backgroundColor = sender.view.window?.backgroundColor
        nameField.bordered = false
        
        descField.selectable = false
        descField.editable = false
        descField.stringValue = desc
        descField.font = NSFont(name: "System", size: 11.0)
        descField.backgroundColor = NSColor.controlColor()
        descField.bordered = true
        descField.backgroundColor = sender.view.window?.backgroundColor
        
        imageView.image = NSImage(named: self.pictureName)!
        
        gameView = NSView(frame: NSRect(x: 0, y: /*height - (100 * num)*/ height - (120 * num), width: 600, height: 100))
        
        button = NSButton(frame: NSRect(x: 0, y: 0, width: 600, height: 100))
        button.tag = Int(number)
        button.action = nil
        
        var gesture = NSClickGestureRecognizer(target: sender, action: Selector("buttonPressed:"))
        gesture.numberOfClicksRequired = 1
        gesture.buttonMask = 0x1
        button.addGestureRecognizer(gesture)
        
        button.bezelStyle = NSBezelStyle(rawValue: 6)!
        button.transparent = true
        
        gameView.addSubview(nameField)
        gameView.addSubview(imageView)
        gameView.addSubview(descField)
        gameView.addSubview(button)
        
    }
    
    var number : CGFloat
    var pictureName : String
    var name : String
    var desc : String
    var height : CGFloat
    
    lazy var button : NSButton = NSButton()
    lazy var imageView : NSImageView = NSImageView()
    lazy var nameField : NSTextField = NSTextField()
    lazy var descField : NSTextField = NSTextField()
    lazy var gameView : NSView = NSView()
    
}
