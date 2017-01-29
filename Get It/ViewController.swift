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

class ViewController: NSViewController {

    //input and output GUI elements
    @IBOutlet var inputURLS: NSTextView!
 //   @IBOutlet var outputWindow: NSTextView!
    
        
    var getIt = GetIt()

//****************************************************************************************************************
//****************************************************************************************************************

    
    //will excecute when we psuh on the download-button
    @IBAction func downloadButton(_ sender: AnyObject) {
       
    
        //get input URLs and devide them in an array
        let tempString = inputURLS.string!
        let inputURLS_array = tempString.characters.split{$0 == "\n"}.map(String.init) //array: inputURL[0] inputURL[1] ...

    }


/********************
*  EXCECUTE COMMAND *
*********************/
        
        func execute(command: String){
        
        //the following code (from stackoverflow) will excecute the youtube-dl command and will add the output from the command
        //to the output window (real time output)
        // http://stackoverflow.com/questions/29548811/real-time-nstask-output-to-nstextview-with-swift
        
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( command )
        

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
                                                                            if let str = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                                                                                //print("got output: \(str)")
                                                                                //RECEIVED OUTPUT
                                                                                //self.outputWindow.insertText( "\(str)" )
                                                                            
                                                                            }
                                                                            outHandle.waitForDataInBackgroundAndNotify()
                                                                        } else {
                                                                            //print("EOF on stdout from process")
                                                                            //self.outputWindow.insertText( "\nEOF on stdout from process" )
                                                                            NotificationCenter.default.removeObserver(obs1)
                                                                        }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NotificationCenter.default.addObserver(forName: Process.didTerminateNotification,
                                                                       object: task, queue: nil) { notification -> Void in
                                                                        //print("terminated")
                                                                   //     self.outputWindow.insertText( "\n\nDONE.\n" )
                                                                        NotificationCenter.default.removeObserver(obs2)
        }
        
        task.launch()
        
    }
    
    
//****************************************************************************************************************
//****************************************************************************************************************

    
    //this function will excecute once when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set texts
       // inputURLS.insertText("\n\nInsert your URLs here. Seperate multiple URLS with a breakline (enter).")
     //   outputWindow.insertText( "\n\nThis will contain some debugging information when downloading your requested files.\n\nThe default settings will download the input URLs as MP3-files.\n\nENJOY!" )
        
        
        
        
        
        getIt.loadCmdFromSettings()
        
    }
    
    
    
    

    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }

    

}

