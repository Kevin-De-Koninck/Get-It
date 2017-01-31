//
//  GetIt.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation

class GetIt {
    var command: String!
    var progress: CGFloat {
        didSet{
            if progress != oldValue {
                progressChanged()
            }
        }
    }
    
    
    init() {
        progress = 0.0
        loadCmdFromSettings()
    }
    
    func loadCmdFromSettings(){
        if let cmd = UserDefaults.standard.value(forKey: SAVED_COMMAND) as? String {
            self.command = cmd
        } else {
            self.command = DEFAULT_COMMAND
        }
    }
    
    func progressChanged(){
        
    }
    
    func execute(commandSynchronous: String) -> String {
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( command )
        
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
    

    
    
}
