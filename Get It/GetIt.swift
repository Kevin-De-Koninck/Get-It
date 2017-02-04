//
//  GetIt.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation

class GetIt {
    private var command: String!

    init() {
    }
    
    func getCommand() -> String {
        if let cmd = UserDefaults.standard.value(forKey: SAVED_COMMAND) as? String {
            self.command = cmd
        } else {
            self.command = DEFAULT_COMMAND
        }
        return self.command
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
    

    
    
}
