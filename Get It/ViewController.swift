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
    
    
    
    
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set texts
        // inputURLS.insertText("\n\nInsert your URLs here. Seperate multiple URLS with a breakline (enter).")
        //   outputWindow.insertText( "\n\nThis will contain some debugging information when downloading your requested files.\n\nThe default settings will download the input URLs as MP3-files.\n\nENJOY!" )
        
        
        getIt.loadCmdFromSettings()
        
    }
    



    @IBAction func downloadButton(_ sender: AnyObject) {
       
        //get input URLs and devide them in an array
        let tempString = inputURLS.string!
        let inputURLS_array = tempString.characters.split{$0 == "\n"}.map(String.init) //array: inputURL[0] inputURL[1] ...
        
        execute(commmandAsynchronous: "for i in {1..100}; do echo $i; sleep 0.05; done && for i in {1..100}; do echo $i; sleep 0.05; done")

        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func execute(commmandAsynchronous: String){
        
        downloadingFileNr = 1 // reset file nr
        
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( /* COMMAND_PREFIX +*/ commmandAsynchronous /*+ COMMAND_POSTFIX*/ )
        
        
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
                                                                let str = s.components(separatedBy: "\n")[0]
                                                                print( "\(str)" )
                                                                

                                                                if(str == "100"){ self.downloadingFileNr = self.downloadingFileNr + 1 }

                                                                
                                                                //set and display progress indicator
                                                                let currentProgress = CGFloat((str as NSString).floatValue)
                                                                let status = "Downloading file \(self.downloadingFileNr)\n            \(currentProgress)%"
                                                                DJProgressHUD.showProgress(currentProgress/100.0, withStatus: status, from: self.view)

                                                                
                                                                

                                                                
                                                                
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

