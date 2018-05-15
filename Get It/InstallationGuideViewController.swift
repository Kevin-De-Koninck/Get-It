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

    @IBOutlet weak var nextPageBtn: NSButton!
    @IBOutlet weak var bodyText: NSTextField!
    @IBOutlet weak var commandTextField: optionsTextfield!
    @IBOutlet weak var titleText: NSTextField!
    @IBOutlet weak var refreshImage: NSButton!
    @IBOutlet weak var openTerminalButton: NSButton!
    @IBOutlet weak var installButton: installButton!
    
    @IBOutlet weak var progressV: progressView!
    @IBOutlet weak var progressTitle: NSTextField!
    
    
    var currentPage: Int = 0 //intro
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true

        refreshImage.isHidden = true
        progressTitle.isHidden = true
        progressV.isHidden = true
        currentPage = 0
        displayPage()
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    func displayPage() {
        installButton.isEnabled = true
        nextPageBtn.isEnabled = false
        switch currentPage {
        case 0:
            nextPageBtn.isEnabled = true
            nextPageBtn.isHidden = false
            commandTextField.isHidden = true
            refreshImage.isHidden = true
            openTerminalButton.isHidden = true
            installButton.isHidden = true
        case 2:
            nextPageBtn.isHidden = false
            commandTextField.isHidden = false
            refreshImage.isHidden = true
            openTerminalButton.isHidden = false
            installButton.isHidden = true
        case 5:
            nextPageBtn.isHidden = true
            commandTextField.isHidden = true
            refreshImage.isHidden = false
            openTerminalButton.isHidden = true
            installButton.isHidden = true
        default:
            nextPageBtn.isHidden = false
            commandTextField.isHidden = true
            refreshImage.isHidden = true
            openTerminalButton.isHidden = true
            installButton.isHidden = false
        }
        
        titleText.stringValue = TITLE[PAGES[currentPage]]!
        bodyText.stringValue = BODY[PAGES[currentPage]]!
        commandTextField.stringValue = INSTALLATION_COMMANDS[PAGES[currentPage]]!
    }
    
    func showInProgressView(title: String) {
        nextPageBtn.isEnabled = false
        installButton.isEnabled = false
        
        progressV.isHidden = false
        progressTitle.isHidden = false
        progressTitle.stringValue = title
    }
    
    func dismissProgressView() {
        nextPageBtn.isEnabled = true
        installButton.isEnabled = true
        
        progressV.isHidden = true
        progressTitle.isHidden = true
    }
    
    @IBAction func openTerminalButtonClicked(_ sender: Any) {
        _ = getIt.execute(commandSynchronous: "open /Applications/Utilities/Terminal.app")
    }

    @IBAction func installBtnClicked(_ sender: Any) {
        var cmd = EXPORT_PATH + " && "
        
        switch currentPage {
            case 1: cmd += INSTALLATION_COMMANDS["xcode"]!
            case 3: cmd += INSTALLATION_COMMANDS["python"]!
            default: cmd += INSTALLATION_COMMANDS["ytdl"]!
        }
        
        showInProgressView(title: "Please wait...")
        let debug = getIt.execute(commandSynchronous: cmd)
        print ("\(debug)")
        dismissProgressView()
        installButton.isEnabled = false
        nextPageBtn.isEnabled = true
    }
    
    @IBAction func nextPageBtnClicked(_ sender: Any) {

        if(currentPage == 0 && getIt.isXcodeInstalled && getIt.isBrewInstalled && getIt.isPythonInstalled && getIt.isPycryptoInstalled) { currentPage = 4 }
        else if(currentPage == 0 && getIt.isXcodeInstalled && getIt.isBrewInstalled) { currentPage = 3 }
        else if(currentPage == 0 && getIt.isXcodeInstalled) { currentPage = 2 }
        else if(currentPage == 1 && getIt.isBrewInstalled && getIt.isPythonInstalled && getIt.isPycryptoInstalled) { currentPage = 4 }
        else if(currentPage == 1 && getIt.isBrewInstalled) { currentPage = 3 }
        else if(currentPage == 2 && getIt.isPythonInstalled && getIt.isPycryptoInstalled) { currentPage = 4 }
        else if(currentPage == 3 && getIt.isBrewInstalled) { currentPage = 5 }
        else{ currentPage = currentPage + 1 }

        displayPage()
    }
    
}
