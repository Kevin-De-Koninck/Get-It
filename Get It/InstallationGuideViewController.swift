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
    @IBOutlet weak var refreshImage: NSButton!
    @IBOutlet weak var openTerminalButton: openTerminalButton!
    
    var currentPage: Int = 0 //intro
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true

        previousPageBtn.isHidden = true
        refreshImage.isHidden = true
        currentPage = 0
        displayPage()
        
//TODO remove
//
//        print(getIt.isXcodeInstalled)
//        print(getIt.isBrewInstalled)
//        print(getIt.isPythonInstalled)
//        print(getIt.isYTDLInstalled)
//        
//        getIt.isXcodeInstalled = true
//        getIt.isPythonInstalled = false
//        getIt.isBrewInstalled = true
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    
    func displayPage() {
        switch currentPage {
        case 0:
            previousPageBtn.isHidden = true
            nextPageBtn.isHidden = false
            commandTextField.isHidden = true
            refreshImage.isHidden = true
            openTerminalButton.isHidden = false
        case 5:
            previousPageBtn.isHidden = false
            nextPageBtn.isHidden = true
            commandTextField.isHidden = true
            refreshImage.isHidden = false
            openTerminalButton.isHidden = true
        default:
            previousPageBtn.isHidden = false
            nextPageBtn.isHidden = false
            commandTextField.isHidden = false
            refreshImage.isHidden = true
            openTerminalButton.isHidden = false
        }
        
        titleText.stringValue = TITLE[PAGES[currentPage]]!
        bodyText.stringValue = BODY[PAGES[currentPage]]!
        commandTextField.stringValue = INSTALLATION_COMMANDS[PAGES[currentPage]]!
    }

    @IBAction func openTerminalBtnClicked(_ sender: Any) {
        _ = getIt.execute(commandSynchronous: "open /Applications/Utilities/Terminal.app")
    }
    
    @IBAction func nextPageBtnClicked(_ sender: Any) {

        if(currentPage == 0 && getIt.isXcodeInstalled && getIt.isBrewInstalled && getIt.isPythonInstalled) { currentPage = 4 }
        else if(currentPage == 0 && getIt.isXcodeInstalled && getIt.isBrewInstalled) { currentPage = 3 }
        else if(currentPage == 0 && getIt.isXcodeInstalled) { currentPage = 2 }
        else if(currentPage == 1 && getIt.isBrewInstalled && getIt.isPythonInstalled) { currentPage = 4 }
        else if(currentPage == 1 && getIt.isBrewInstalled) { currentPage = 3 }
        else if(currentPage == 2 && getIt.isPythonInstalled) { currentPage = 4 }
        else{ currentPage = currentPage + 1 }

        displayPage()
    }
    
    @IBAction func previousPageBtnClicked(_ sender: Any) {

        if(currentPage == 4 && getIt.isXcodeInstalled && getIt.isBrewInstalled && getIt.isPythonInstalled) { currentPage = 0 }
        else if(currentPage == 4 && getIt.isPythonInstalled && getIt.isBrewInstalled) { currentPage = 1 }
        else if(currentPage == 4 && getIt.isPythonInstalled) { currentPage = 2 }
        else if(currentPage == 3 && getIt.isXcodeInstalled && getIt.isBrewInstalled) { currentPage = 0 }
        else if(currentPage == 3 && getIt.isBrewInstalled) { currentPage = 1 }
        else if(currentPage == 2 && getIt.isXcodeInstalled) { currentPage = 0 }
        else{ currentPage = currentPage - 1 }
        
        displayPage()
    }
    
    
    
}
