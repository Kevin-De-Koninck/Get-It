//
//  progressView.swift
//  Get It
//
//  Created by Kevin De Koninck on 17/04/2018.
//  Copyright © 2018 Kevin De Koninck. All rights reserved.
//

import Cocoa

class progressView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        self.alphaValue = 0.7
        self.layer?.backgroundColor = NSColor.black.cgColor
        self.layer?.cornerRadius = 15.0
        self.layer?.masksToBounds = true
    }
    
}
