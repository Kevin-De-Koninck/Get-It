//
//  openTerminalButton.swift
//  Get It
//
//  Created by Kevin De Koninck on 05/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class installButton: NSButton {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer?.backgroundColor = blueColor.cgColor
        self.layer?.cornerRadius = 15.0
        self.layer?.masksToBounds = true
        
        //text
        let style = NSMutableParagraphStyle()
        style.alignment = .center
        self.attributedTitle = NSAttributedString(string: "Install", attributes: [ NSForegroundColorAttributeName : NSColor.white,
                                                                                                 NSParagraphStyleAttributeName : style,
                                                                                                 NSFontAttributeName: NSFont(name: "Arial", size: 18)!])
    }
}
