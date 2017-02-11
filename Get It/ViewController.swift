//
//  ViewController.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 23/05/16.
//  Copyright © 2016 Kevin De Koninck. All rights reserved.
//


//TODO: check if youtube-dl is installed on boot up: if brew ls --versions youtube-dl > /dev/null; then echo INSTALLED; else echo NOT INSTALLED; fi
// if not, then disable all buttons except the package icon that will start a guide on how to install it.

//TODO: check if homebrew is installed: [ ! -f "`which breww`" ]  && echo NOT INSTALLED           (check on output: NOT INSTALLED)

//TODO: make a guide

//TODO: regex check for urls in input field


import Cocoa
import DJProgressHUD_OSX

class ViewController: NSViewController {

    @IBOutlet var inputURLS: NSTextView!
    @IBOutlet weak var settingsBtn: NSButton!
    @IBOutlet weak var openDestinationFolderBtn: GrayButton!
    @IBOutlet weak var downloadBtn: DownloadButton!
    @IBOutlet weak var installationGuideBtn: NSButton!
    @IBOutlet weak var refreshInstallationBtn: NSButton!
    
    
    //global variables
    var getIt = GetIt()
    var downloadingFileNr: Int = 1
    var previousProgress: CGFloat = 0.0
    var currentProgress: CGFloat = 0.0
    var downloadsDidStart: Bool = false



    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(openSettingsView), name: NSNotification.Name(rawValue: "openSettingsView"), object: nil)
    }
    func openSettingsView(notif: AnyObject) {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        getIt.checkIfSoftwareIsInstalled()
        let activate = (!getIt.isYTDLInstalled) || (!getIt.isFfmpegInstalled)
        installationGuideViewSetUp(activate: activate)
        installationGuideViewSetUp(activate: true)  //TODO - remove (is for testing purposes)
    }
    
    func installationGuideViewSetUp(activate: Bool) {
        inputURLS.isEditable = !activate
        settingsBtn.isEnabled = !activate
        openDestinationFolderBtn.isEnabled = !activate
        downloadBtn.isEnabled = !activate
        installationGuideBtn.isEnabled = activate
        installationGuideBtn.isHidden = !activate
        refreshInstallationBtn.isEnabled = activate
        refreshInstallationBtn.isHidden = !activate
    }
    
    @IBAction func refreshInstallationBtnClicked(_ sender: Any) {
        getIt.checkIfSoftwareIsInstalled()
        let activate = (!getIt.isYTDLInstalled) || (!getIt.isFfmpegInstalled)
        installationGuideViewSetUp(activate: activate)
//        installationGuideViewSetUp(activate: true)  //TODO - remove (is for testing purposes)
    }
    
    @IBAction func InstallGuideBtnClicked(_ sender: Any) {
    }
    
    @IBAction func openDestinationFolderBtnClicked(_ sender: Any) {
        _ = getIt.open(folder: UserDefaults.standard.value(forKey: OUTPUT_PATH) as! String)
    }
    

    @IBAction func downloadButton(_ sender: AnyObject) {
        //get input URLs
        let tempString = inputURLS.string!
        let urls = tempString.characters.split{$0 == "\n"}.map(String.init)
        if(urls.count > 0){
            var urlStr = " "
            for url in urls { urlStr = urlStr + url + " " }
            
            //start download
            downloadsDidStart = false
            DJProgressHUD.showStatus("Gathering information\n          Please wait", from: self.view)
            execute(commmandAsynchronous: getIt.getCommand() + " -o " + getIt.getOutputPath() + getIt.getOutputTemplate() + urlStr)
        } else {
            DJProgressHUD.showStatus("Can't download nothing", from: self.view)
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                DJProgressHUD.dismiss()
            })
        }
    }
    
    
    func execute(commmandAsynchronous: String){
        
        downloadingFileNr = 1 // reset file nr
        
        //Prepare command
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( commmandAsynchronous  )
        print( commmandAsynchronous  )
        
        //Start execution of command
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var obs1 : NSObjectProtocol!
        obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandle, queue: nil) {  notification -> Void in
            let data = outHandle.availableData
            if data.count > 0 {
                if let s = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    //RECEIVED OUTPUT
                    
                    print("RECEIVED \(s)")
                    print("--------------")
                    
                    var status: String!
                    let matchesError = [String]()
                    
                    //Received value preprocessing
                    let receivedStr = s.components(separatedBy: "\n")[0]
                    var str = receivedStr.replacingOccurrences(of: " ", with: "")
                    
                    //Get percentage using a regular expression
                    do{
                        //regex for downloadbar
                        let regex = try NSRegularExpression(pattern: REGEX_PATTERN, options: [])
                        let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
                        //regex for error
                        let regexError = try NSRegularExpression(pattern: "ERROR", options: [])
                        let matchesError = regexError.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
                        
                        if matchesError.count > 0 {
                        print(receivedStr)
                            
                        }else if matches.count > 0 {
                            let rangeOfMatch = matches[0].rangeAt(0)
                            var index = str.index(str.startIndex, offsetBy: rangeOfMatch.location + rangeOfMatch.length - 1)
                            str = str.substring(to: index)
                            index = str.index(str.startIndex, offsetBy: rangeOfMatch.location - 1)
                            str = str.substring(from: index)
                            
                            self.currentProgress = CGFloat(Double(round(100 * (str as NSString).doubleValue) / 100 ))
                            if( self.currentProgress < self.previousProgress){
                                self.currentProgress = self.previousProgress
                            } else {
                                self.previousProgress = self.currentProgress
                            }

                        } else {
                            str = "-1"
                        }
                    } catch _ { } // don't care

                    //Set and update the waiting screen based on the received percentage/data/error
                    if matchesError.count == 0 {
                        if(str == "100"){
                            self.downloadingFileNr = self.downloadingFileNr + 1
                            status = "Processing file \(self.downloadingFileNr)\n          \(self.currentProgress)%"
                            self.previousProgress = 0.0
                        } else if (str == "-1" && self.downloadingFileNr > 1){
                            status = "Processing file \(self.downloadingFileNr - 1)\n          "
                        } else if (str == "-1") {
                            status = "Downloading file \(self.downloadingFileNr)\n             \(self.currentProgress)%"
                        } else if (self.currentProgress <= 100){
                            status = "Downloading file \(self.downloadingFileNr)\n             \(self.currentProgress)%"
                            self.previousProgress = self.currentProgress
                            self.downloadsDidStart = true
                        } else {
                            status = "Processing file \(self.downloadingFileNr)\n          \(self.currentProgress)%"
                            self.previousProgress = self.currentProgress
                        }
                        if(self.downloadsDidStart) {
                            DJProgressHUD.showProgress(self.currentProgress/100.0, withStatus: status, from: self.view)
                        }
                    }
                    //error received
                    else
                    {
                        DJProgressHUD.showStatus("ERROR\n\(receivedStr)", from: self.view)
                    }
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                //EOF ON STDOUT FROM PROCESS
                NotificationCenter.default.removeObserver(obs1)
                if(self.downloadingFileNr < 2){
                    DJProgressHUD.dismiss()
                    DJProgressHUD.showStatus("          Download failed\n\n    Video not available or\nvideo format not available", from: self.view)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                        DJProgressHUD.dismiss()
                    })
                }
            }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil) { notification -> Void in
            //PROCESS TERMINATED
            NotificationCenter.default.removeObserver(obs2)
            
            DJProgressHUD.dismiss()
        }
        
        task.launch()
    }

}
