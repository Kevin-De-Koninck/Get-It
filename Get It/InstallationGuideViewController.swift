//
//  InstallationGuideViewController.swift
//  Get It
//
//  Created by Kevin De Koninck on 05/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class InstallationGuideViewController: NSViewController {
    
    var getIt = GetIt()
    
    /* 
     * Dictoinary title  ("intro" : "introduction", "brew" : "Homebrew", ...)
                  bodyText ("intro : "welcome to ..." , "brew" : "we will ...", ...)
                  ...
     
     * variabele page: Int = 0
       variable pages = ["intro", "brew", ...]
     
     * bodytext = bodyTextDict(pages[page])
     
     * if clicked previeous: page = page - 1 (if page > 0)
     
     etc
     */

    @IBOutlet weak var nextPageBtn: NSButton!
    @IBOutlet weak var previousPageBtn: NSButton!
    @IBOutlet weak var bodyText: NSTextField!
    @IBOutlet weak var commandTextField: optionsTextfield!
    @IBOutlet weak var titleText: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true

//TODO remove
        print(getIt.isYTDLInstalled)
        print(getIt.isBrewInstalled)
        print(getIt.isFfmpegInstalled)
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }

    @IBAction func openTerminalBtnClicked(_ sender: Any) {
        _ = getIt.execute(commandSynchronous: "open /Applications/Utilities/Terminal.app")
    }
    
    @IBAction func nextPageBtnClicked(_ sender: Any) {
        print("next")
    }
    
    @IBAction func previousPageBtnClicked(_ sender: Any) {
        print("prev")
    }
    
    
    
}
