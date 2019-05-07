//
//  GetIt.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation
import STPrivilegedTask

class GetIt {
    var isYTDLInstalled: Bool = false
    var isBrewInstalled: Bool = false
    var isFfmpegInstalled: Bool = false
    var isPythonInstalled: Bool = false
    var isXcodeInstalled: Bool = false
    var isPycryptoInstalled: Bool = false
    
    
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
        arguments.append( EXPORT_PATH + " && " + commandSynchronous + " 2>&1")
        
        let task = Process()
        task.launchPath = "/bin/sh"
        task.arguments = arguments
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        
        return(NSString(data: data, encoding: String.Encoding.utf8.rawValue)! as String)
    }
    
}
