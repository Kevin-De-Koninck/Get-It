//
//  GetIt.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation

class GetIt {
    var isYTDLInstalled: Bool = false
    var isBrewInstalled: Bool = false
    var isFfmpegInstalled: Bool = false
    var isPythonInstalled: Bool = false
    var isXcodeInstalled: Bool = false
    
    init() {
        //Get installed software
        //This is needed for the installation guide
        if let installed = UserDefaults.standard.value(forKey: YTDL) as? String {
            self.isYTDLInstalled = installed == "true" ? true : false
        } else {
            self.isYTDLInstalled = false
        }
        
        if let installed = UserDefaults.standard.value(forKey: BREW) as? String {
            self.isBrewInstalled = installed == "true" ? true : false
        } else {
            self.isBrewInstalled = false
        }
        
        if let installed = UserDefaults.standard.value(forKey: FFMPEG) as? String {
            self.isFfmpegInstalled = installed == "true" ? true : false
        } else {
            self.isFfmpegInstalled = false
        }
        
        if let installed = UserDefaults.standard.value(forKey: PYTHON) as? String {
            self.isPythonInstalled = installed == "true" ? true : false
        } else {
            self.isPythonInstalled = false
        }
        
        if let installed = UserDefaults.standard.value(forKey: XCODE) as? String {
            self.isXcodeInstalled = installed == "true" ? true : false
        } else {
            self.isXcodeInstalled = false
        }
    }
    
    
    func getCommand() -> String {
        if let cmd = UserDefaults.standard.value(forKey: SAVED_COMMAND) as? String {
            return cmd
        } else {
            return DEFAULT_COMMAND
        }
    }
    
    func getOutputPath() -> String {
        if let path = UserDefaults.standard.value(forKey: OUTPUT_PATH) as? String {
            return path + "/"
        } else {
            return DEFAULT_SETTINGS["path"]! + "/"
        }
    }
    
    func getOutputTemplate() -> String {
        if let template = UserDefaults.standard.value(forKey: OUTPUT_TEMPLATE) as? String {
            return template + " "
        } else {
            return DEFAULT_SETTINGS["outputTemplate"]! + " "
        }
    }
    
    
    func open(folder: String){
        _ = self.execute(commandSynchronous: "open \(folder)")
    }
    
    
    func execute(commandSynchronous: String) -> String {
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( commandSynchronous )
        
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        return(NSString(data: data, encoding: String.Encoding.utf8.rawValue) as! String)
    }
    
    
    func checkIfSoftwareIsInstalled(){
        var result = self.execute(commandSynchronous: "export PATH=$PATH:/usr/local/bin && if brew ls --versions youtube-dl > /dev/null; then echo INSTALLED; else echo NOT INSTALLED; fi")
        var temp = result.components(separatedBy: "\n")
        isYTDLInstalled = temp[0] == "INSTALLED" ? true : false
        
        result = self.execute(commandSynchronous: "export PATH=$PATH:/usr/local/bin && [ ! -f \"`which brew`\" ]  && echo NOT INSTALLED")
        temp = result.components(separatedBy: "\n")
        isBrewInstalled = temp[0] == "NOT INSTALLED" ? false : true
        
        result = self.execute(commandSynchronous: "export PATH=$PATH:/usr/local/bin && if brew ls --versions ffmpeg > /dev/null; then echo INSTALLED; else echo NOT INSTALLED; fi")
        temp = result.components(separatedBy: "\n")
        isFfmpegInstalled = temp[0] == "INSTALLED" ? true : false
        
        result = self.execute(commandSynchronous: "export PATH=$PATH:/usr/local/bin && if brew ls --versions python3 > /dev/null; then echo INSTALLED; else echo NOT INSTALLED; fi")
        temp = result.components(separatedBy: "\n")
        isPythonInstalled = temp[0] == "INSTALLED" ? true : false
        
        result = self.execute(commandSynchronous: "export PATH=$PATH:/usr/local/bin && [ ! -f \"`which xcode-select`\" ]  && echo NOT INSTALLED")
        temp = result.components(separatedBy: "\n")
        isXcodeInstalled = temp[0] == "NOT INSTALLED" ? false : true
        
        //save it so we can use it everywhere (installation guide)
        UserDefaults.standard.setValue("\(isBrewInstalled)", forKey: BREW)
        UserDefaults.standard.setValue("\(isYTDLInstalled)", forKey: YTDL)
        UserDefaults.standard.setValue("\(isFfmpegInstalled)", forKey: FFMPEG)
        UserDefaults.standard.setValue("\(isPythonInstalled)", forKey: PYTHON)
        UserDefaults.standard.setValue("\(isXcodeInstalled)", forKey: XCODE)
        UserDefaults.standard.synchronize()
    }
    
}
