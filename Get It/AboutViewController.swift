//
//  AboutViewController.swift
//  Get It
//
//  Created by Kevin De Koninck on 29/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class AboutViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    @IBAction func githubBtnClicked(_ sender: Any) {
        open(website: "https://kevin-de-koninck.github.io/Get-It/")
    }
    
    @IBAction func supportedSitesBtnClicked(_ sender: Any) {
        open(website: "https://rg3.github.io/youtube-dl/supportedsites.html")
    }
    
    @IBAction func githubYTBtnClicked(_ sender: Any) {
        open(website: "https://github.com/rg3/youtube-dl")
    }

    @IBAction func donateBtnClicked(_ sender: Any) {
        open(website: "https://rg3.github.io/youtube-dl/donations.html")
    }

    func open(website: String){
        if let url = URL(string: website), NSWorkspace.shared.open(url) {
            print("default browser was successfully opened")
        }
    }
    
}
