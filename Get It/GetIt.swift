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
    
    
    init() {
         loadCmdFromSettings()
    }
    
    func loadCmdFromSettings(){
        if let cmd = UserDefaults.standard.value(forKey: SAVED_COMMAND) as? String {
            self.command = cmd
        } else {
            self.command = DEFAULT_COMMAND
        }
    }
    
    
    
    
}
