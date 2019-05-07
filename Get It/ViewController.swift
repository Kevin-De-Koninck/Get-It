//
//  ViewController.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 23/05/16.
//  Copyright © 2016 Kevin De Koninck. All rights reserved.
//


//TODO: check if youtube-dl is installed on boot up: if brew ls --versions youtube-dl > /dev/null; then echo INSTALLED; else echo NOT INSTALLED; fi
// if not, then disable all buttons except the package icon that will start a guide on how to install it.

//TODO: regex check for urls in input field


import Cocoa

class ViewController: NSViewController {

    @IBOutlet var inputURLS: NSTextView!
    @IBOutlet weak var settingsBtn: NSButton!
    @IBOutlet weak var openDestinationFolderBtn: GrayButton!
    @IBOutlet weak var downloadBtn: DownloadButton!
    @IBOutlet weak var progressV: progressView!
    @IBOutlet weak var progressTitle: NSTextField!
    @IBOutlet weak var progressDetails: NSTextField!
    
    
    //global variables
    var getIt = GetIt()
    var logger = Logger()
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
    @objc func openSettingsView(notif: AnyObject) {
        self.performSegue(withIdentifier: "settingsSegue", sender: self)
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        dismissProgressView()
    }
    
    func activateComponents(activate: Bool) {
        inputURLS.isEditable = activate
        settingsBtn.isEnabled = activate
        openDestinationFolderBtn.isEnabled = activate
        downloadBtn.isEnabled = activate
    }
    
    func dismissProgressView() {
        self.activateComponents(activate: true)
        progressV.isHidden = true
        progressTitle.isHidden = true
        progressDetails.isHidden = true
    }
    
    func showInProgressView(title: String, details: String) {
        self.activateComponents(activate: false)
        progressV.isHidden = false
        progressTitle.isHidden = false
        progressDetails.isHidden = false
        progressTitle.stringValue = title
        progressDetails.stringValue = details
        logger.log(tag: "[PROGRESS VIEW]", str: "\(title): \(details)")
    }
    
    @IBAction func openDestinationFolderBtnClicked(_ sender: Any) {
        _ = getIt.open(folder: UserDefaults.standard.value(forKey: OUTPUT_PATH) as! String)
    }

    @IBAction func downloadButton(_ sender: AnyObject) {
        logger.reset()
        
        //get input URLs
        let tempString = inputURLS.string
        let urls = tempString.split{$0 == "\n"}.map(String.init)
        if(urls.count > 0){
            var urlStr = " "
            for url in urls { urlStr = urlStr + url + " " }
            
            //start download
            downloadsDidStart = false
            self.showInProgressView(title: "Gathering information", details: "Please wait")
            execute(commmandAsynchronous: getIt.getCommand() + " -o " + getIt.getOutputPath() + getIt.getOutputTemplate() + urlStr)
        } else {
            self.showInProgressView(title: "Whoops", details: "Can't download nothing")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                self.dismissProgressView()
            })
        }
    }
    
    func execute(commmandAsynchronous: String){
        
        var receivedStr = ""  // variable to keep the received string (usefull to display it at the end)
        downloadingFileNr = 1 // reset file nr
        
        //Prepare command
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append(commmandAsynchronous + " 2>&1")
        logger.log(tag: "[COMMAND]", str: "\(commmandAsynchronous) 2>&1")
        
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
                    self.logger.log(tag: "[RECEIVED]", str: "\(s)")
                    
                    var status: String!
                    let matchesError = [String]()
                    
                    //Received value preprocessing
                    receivedStr = s.components(separatedBy: "\n")[0]
                    var str = receivedStr.replacingOccurrences(of: " ", with: "")
                    
                    //Get percentage using a regular expression
                    do{
                        //regex for downloadbar
                        let regex = try NSRegularExpression(pattern: REGEX_PATTERN, options: [])
                        let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
                        //regex for error
                        let regexError = try NSRegularExpression(pattern: "ERROR", options: [])
                        _ = regexError.matches(in: str, options: [], range: NSRange(location: 0, length: str.count))
                        
                        if matches.count > 0 {
                            let rangeOfMatch = matches[0].range(at: 0)
                            var index = str.index(str.startIndex, offsetBy: rangeOfMatch.location + rangeOfMatch.length - 1)
                            str = String(str[..<index])
                            index = str.index(str.startIndex, offsetBy: rangeOfMatch.location - 1)
                            str = String(str[index...])
                            
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
                            status = "Processing file \(self.downloadingFileNr)"
                            self.previousProgress = 0.0
                        } else if (str == "-1" && self.downloadingFileNr > 1){
                            status = "Processing file \(self.downloadingFileNr - 1)"
                        } else if (str == "-1") {
                            status = "Downloading file \(self.downloadingFileNr)"
                        } else if (self.currentProgress <= 100){
                            status = "Downloading file \(self.downloadingFileNr)"
                            self.previousProgress = self.currentProgress
                            self.downloadsDidStart = true
                        } else {
                            status = "Processing file \(self.downloadingFileNr)"
                            self.previousProgress = self.currentProgress
                        }
                        if(self.downloadsDidStart) {
                            self.showInProgressView(title: status, details: "\(self.currentProgress)%")
                        }
                    }
                    //error received
                    else {
                        self.showInProgressView(title: "Error!", details: "\(receivedStr)")
                    }
                }
                outHandle.waitForDataInBackgroundAndNotify()
            } else {
                //EOF ON STDOUT FROM PROCESS
                NotificationCenter.default.removeObserver(obs1 as Any)
                if(self.downloadingFileNr < 2){
                    self.showInProgressView(title: "Failed...", details: "Something went wrong. Please try other settings or report this issue on github if the problem doesn't magically disappears.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                        self.dismissProgressView()
                    })
                }
            }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: task, queue: nil) { notification -> Void in
            //PROCESS TERMINATED
            NotificationCenter.default.removeObserver(obs2 as Any)
            self.dismissProgressView()
        }
        
        task.launch()
    }

}
