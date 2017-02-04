//
//  ViewController.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 23/05/16.
//  Copyright © 2016 Kevin De Koninck. All rights reserved.
//





//TODO: youtube-dl --extract-audio --audio-quality 0 --newline https://www.youtube.com/playlist?list=PL1C815DB73EC2678E |   perl -nle 'print $& if m{^\[download\].*?\K([0-9.]+\%|#\d+ of \d)}'
// voor progress bar
// beginnen met file 1 en bij elke 100% 1 optellen en wnnr op 100% dan postprocess zetten tot next % gekregen


//TODO: check if youtube-dl is installed on boot up: if brew ls --versions youtube-dl > /dev/null; then echo INSTALLED; else echo NOT INSTALLED; fi
// if not, then disable all buttons except the package icon that will start a guide on how to install it.

//TODO: check if homebrew is installed: [ ! -f "`which breww`" ]  && echo NOT INSTALLED           (check on output: NOT INSTALLED)

//TODO: make a guide

//TODO: create about screen

//TODO: regex check for urls in input field


import Cocoa
import DJProgressHUD_OSX

class ViewController: NSViewController {

    @IBOutlet var inputURLS: NSTextView!
        
    var getIt = GetIt()
    
    //global variables
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
    }
    
    
    @IBAction func openDestinationFolderBtnClicked(_ sender: Any) {
        _ = getIt.open(folder:"~/Downloads/")
    }

    @IBAction func downloadButton(_ sender: AnyObject) {
       
        //get input URLs
        let tempString = inputURLS.string!
        let urls = tempString.characters.split{$0 == "\n"}.map(String.init)
        var urlStr = " "
        for url in urls { urlStr = urlStr + url + " " }
        
        print(getIt.getCommand() + urlStr)
        
        
        
        
        //start download
        downloadsDidStart = false
        DJProgressHUD.showStatus("Gathering information\n          Please wait", from: self.view)
        execute(commmandAsynchronous: getIt.getCommand() + urlStr)
        
    }
    
    
    func execute(commmandAsynchronous: String){
        
        downloadingFileNr = 1 // reset file nr
        
        //Prepare command
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( commmandAsynchronous  )
        print( commmandAsynchronous  )
        
        //Start waiting screen
        //DJProgressHUD.showProgress(0.0, withStatus: "", from: view)
        
        
        //Start execution of command
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var obs1 : NSObjectProtocol!
        obs1 = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable,
                                                      object: outHandle, queue: nil) {  notification -> Void in
                                                        let data = outHandle.availableData
                                                        if data.count > 0 {
                                                            if let s = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                                                               
                                                                
                                                                //RECEIVED OUTPUT
                                                                
                                                                var str = s.components(separatedBy: "\n")[0]
                                                                str = str.replacingOccurrences(of: " ", with: "")

                                       print("--------------------")
                                                  print(str)
                                                            

                                                                do{
                                                                    let regex = try NSRegularExpression(pattern: REGEX_PATTERN, options: [])
                                                                    let matches = regex.matches(in: str, options: [], range: NSRange(location: 0, length: str.characters.count))
                                                                    
                                                                    if matches.count > 0 {
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
                                                                } catch _ { }
                                                                    
 
                                                                    
                                                                
                                     print(self.currentProgress)
                                                                
                                                                
                                                                var status: String!
                                                                
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
                                                            outHandle.waitForDataInBackgroundAndNotify()
                                                        } else {
                                                            print("EOF on stdout from process")
                                                            NotificationCenter.default.removeObserver(obs1)
                                                        }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                                      object: task, queue: nil) { notification -> Void in
                                                        print("terminated")
                                                        NotificationCenter.default.removeObserver(obs2)
                                                        
                                                        DJProgressHUD.dismiss()
        }
        
        task.launch()
    }







    

}

