//
//  OptionsViewController.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa

class OptionsViewController: NSViewController {

    //General tab
    @IBOutlet weak var maxFileSize: NSTextField!
    @IBOutlet weak var ignoreErrors: NSButton!
    @IBOutlet weak var pathChooser: NSPathCell!
    @IBOutlet weak var outputTemplate: NSPopUpButton!
    
    
    //audio tab
    @IBOutlet weak var extractAudio: NSButton!
    @IBOutlet weak var audioFormat: NSPopUpButton!
    @IBOutlet weak var audioQuality: NSPopUpButton!
    @IBOutlet weak var keepVideo: NSButton!
    
    //Video tab
    @IBOutlet weak var videoFormat: NSPopUpButton!
    @IBOutlet weak var downloadAllFormats: NSButton!
    @IBOutlet weak var preferFreeFormats: NSButton!
    @IBOutlet weak var skipDashManifest: NSButton!
    
    //subtitles tab
    
    @IBOutlet weak var downloadSubs: NSButton!
    @IBOutlet weak var downloadAutoSubs: NSButton!
    @IBOutlet weak var downloadAllSubs: NSButton!
    @IBOutlet weak var languageSubs: NSPopUpButton!
    @IBOutlet weak var embedSubs: NSButton!
    
    //playlist tab
    @IBOutlet weak var downloadPlaylist: NSButton!
    @IBOutlet weak var reversePlaylist: NSButton!
//    @IBOutlet weak var flatPlaylist: NSButton!
    @IBOutlet weak var startAtVideo: NSTextField!
    @IBOutlet weak var stopAtVideo: NSTextField!
    @IBOutlet weak var downloadSpecificVideos: NSTextField!
    
    //authentication tab
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var twoFactorCode: NSSecureTextField!
    @IBOutlet weak var netrc: NSButton!
    @IBOutlet weak var videoPassword: NSSecureTextField!

    

    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true

        pathChooser.pathComponentCells.removeAll()
        
        loadSettingsAndSetElements()
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    
    
    
    
    @IBAction func loadDefaultsBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(DEFAULT_SETTINGS, forKey: SETTINGS_KEY)
        UserDefaults.standard.synchronize()
        loadSettingsAndSetElements()
    }
    
    
    
    
    
    func saveSettings() {
        var settingsDict = [String: String]()
        
        let pathString = pathChooser.url?.path.characters.split{$0 == "\""}.map(String.init) //item to string

        
        settingsDict["maxFileSize"] = maxFileSize.stringValue
        settingsDict["ignoreErrors"] = String(ignoreErrors.state)
        settingsDict["path"] = pathString![0]
        
        settingsDict["outputTemplate"] = outputTemplate.itemTitle(at: outputTemplate.indexOfSelectedItem)
        settingsDict["audioFormat"] = audioFormat.itemTitle(at: audioFormat.indexOfSelectedItem)
        settingsDict["audioQuality"] = audioQuality.itemTitle(at: audioQuality.indexOfSelectedItem)
        settingsDict["videoFormat"] = String(videoFormat.indexOfSelectedItem)
        settingsDict["languageSubs"] = String(languageSubs.indexOfSelectedItem)
        settingsDict["startAtVideo"] = startAtVideo.stringValue
        settingsDict["stopAtVideo"] = stopAtVideo.stringValue
        settingsDict["downloadSpecificVideos"] = downloadSpecificVideos.stringValue
        settingsDict["username"] = username.stringValue
        settingsDict["password"] = password.stringValue
        settingsDict["twoFactorCode"] = twoFactorCode.stringValue
        settingsDict["videoPassword"] = videoPassword.stringValue
        settingsDict["extractAudio"] = String(extractAudio.state)
        settingsDict["keepVideo"] = String(keepVideo.state)
        settingsDict["downloadAllFormats"] = String(downloadAllFormats.state)
        settingsDict["preferFreeFormats"] = String(preferFreeFormats.state)
        settingsDict["skipDashManifest"] = String(skipDashManifest.state)
        settingsDict["downloadSubs"] = String(downloadSubs.state)
        settingsDict["downloadAutoSubs"] = String(downloadAutoSubs.state)
        settingsDict["downloadAllSubs"] = String(downloadAllSubs.state)
        settingsDict["embedSubs"] = String(embedSubs.state)
        settingsDict["downloadPlaylist"] = String(downloadPlaylist.state)
        settingsDict["reversePlaylist"] = String(reversePlaylist.state)
//        settingsDict["flatPlaylist"] = String(flatPlaylist.state)
        settingsDict["netrc"] = String(netrc.state)

        UserDefaults.standard.set(settingsDict, forKey: SETTINGS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    
    
    func loadSettingsAndSetElements() {
        
        if let arr = UserDefaults.standard.value(forKey: SETTINGS_KEY) as? [String:String] {
            
            if let val = arr["maxFileSize"] {
                maxFileSize.stringValue = val
            } else {
                maxFileSize.stringValue = DEFAULT_SETTINGS["maxFileSize"]!
            }
            
            if let val = arr["ignoreErrors"], val != "" {
                ignoreErrors.state = Int(val)!
            } else {
                ignoreErrors.state = Int(DEFAULT_SETTINGS["ignoreErrors"]!)!
            }
            
            //TODO: fix the path
            if let val = arr["path"] {
                pathChooser.url = URL.init(fileURLWithPath: val)
            } else {
                pathChooser.url = URL.init(fileURLWithPath: DEFAULT_SETTINGS["path"]!)
            }
            
            if let val = arr["outputTemplate"] {
                outputTemplate.select(outputTemplate.item(withTitle: val))
            } else {
                outputTemplate.select(outputTemplate.item(withTitle: DEFAULT_SETTINGS["outputTemplate"]!))
            }
            
            if let val = arr["extractAudio"] {
                extractAudio.state = Int(val)!
            } else {
                extractAudio.state = Int(DEFAULT_SETTINGS["extractAudio"]!)!
            }
            
            if let val = arr["audioFormat"] {
                audioFormat.select(audioFormat.item(withTitle: val))
            } else {
                audioFormat.select(audioFormat.item(withTitle: DEFAULT_SETTINGS["audioFormat"]!))
            }
            
            if let val = arr["audioQuality"] {
                audioQuality.select(audioQuality.item(withTitle: val))
            } else {
                audioQuality.select(audioQuality.item(withTitle: DEFAULT_SETTINGS["audioQuality"]!))
            }
            
            if let val = arr["keepVideo"] {
                keepVideo.state = Int(val)!
            } else {
                keepVideo.state = Int(DEFAULT_SETTINGS["keepVideo"]!)!
            }
            
            if let val = arr["videoFormat"] {
                videoFormat.selectItem(at: Int(val)!)
            } else {
                videoFormat.selectItem(at: Int(DEFAULT_SETTINGS["videoFormat"]!)!)
            }
            
            if let val = arr["downloadAllFormats"] {
                downloadAllFormats.state = Int(val)!
            } else {
                downloadAllFormats.state = Int(DEFAULT_SETTINGS["downloadAllFormats"]!)!
            }
            
            if let val = arr["preferFreeFormats"] {
                preferFreeFormats.state = Int(val)!
            } else {
                preferFreeFormats.state = Int(DEFAULT_SETTINGS["preferFreeFormats"]!)!
            }
            
            if let val = arr["skipDashManifest"] {
                skipDashManifest.state = Int(val)!
            } else {
                skipDashManifest.state = Int(DEFAULT_SETTINGS["skipDashManifest"]!)!
            }
            
            if let val = arr["downloadSubs"] {
                downloadSubs.state = Int(val)!
            } else {
                downloadSubs.state = Int(DEFAULT_SETTINGS["downloadSubs"]!)!
            }
            
            if let val = arr["downloadAutoSubs"] {
                downloadAutoSubs.state = Int(val)!
            } else {
                downloadAutoSubs.state = Int(DEFAULT_SETTINGS["downloadAutoSubs"]!)!
            }
            
            if let val = arr["downloadAllSubs"] {
                downloadAllSubs.state = Int(val)!
            } else {
                downloadAllSubs.state = Int(DEFAULT_SETTINGS["downloadAllSubs"]!)!
            }
            
            if let val = arr["embedSubs"] {
                embedSubs.state = Int(val)!
            } else {
                embedSubs.state = Int(DEFAULT_SETTINGS["embedSubs"]!)!
            }
            
            if let val = arr["languageSubs"] {
                languageSubs.selectItem(at: Int(val)!)
            } else {
                languageSubs.selectItem(at: Int(DEFAULT_SETTINGS["languageSubs"]!)!)
            }

            if let val = arr["downloadPlaylist"] {
                downloadPlaylist.state = Int(val)!
            } else {
                downloadPlaylist.state = Int(DEFAULT_SETTINGS["downloadPlaylist"]!)!
            }
            
            if let val = arr["reversePlaylist"] {
                reversePlaylist.state = Int(val)!
            } else {
                reversePlaylist.state = Int(DEFAULT_SETTINGS["reversePlaylist"]!)!
            }
            
//            if let val = arr["flatPlaylist"] {
//                flatPlaylist.state = Int(val)!
//            } else {
//                flatPlaylist.state = Int(DEFAULT_SETTINGS["flatPlaylist"]!)!
//            }
            
            if let val = arr["startAtVideo"] {
                startAtVideo.stringValue = val
            } else {
                startAtVideo.stringValue = DEFAULT_SETTINGS["startAtVideo"]!
            }
            
            if let val = arr["stopAtVideo"] {
                stopAtVideo.stringValue = val
            } else {
                stopAtVideo.stringValue = DEFAULT_SETTINGS["stopAtVideo"]!
            }
            
            if let val = arr["downloadSpecificVideos"] {
                downloadSpecificVideos.stringValue = val
            } else {
                downloadSpecificVideos.stringValue = DEFAULT_SETTINGS["downloadSpecificVideos"]!
            }
            
            if let val = arr["username"] {
                username.stringValue = val
            } else {
                username.stringValue = DEFAULT_SETTINGS["username"]!
            }
            
            if let val = arr["password"] {
                password.stringValue = val
            } else {
                password.stringValue = DEFAULT_SETTINGS["password"]!
            }
            
            if let val = arr["twoFactorCode"] {
                twoFactorCode.stringValue = val
            } else {
                twoFactorCode.stringValue = DEFAULT_SETTINGS["twoFactorCode"]!
            }
            
            if let val = arr["netrc"] {
                netrc.state = Int(val)!
            } else {
                netrc.state = Int(DEFAULT_SETTINGS["netrc"]!)!
            }
            
            if let val = arr["videoPassword"] {
                videoPassword.stringValue = val
            } else {
                videoPassword.stringValue = DEFAULT_SETTINGS["videoPassword"]!
            }
            
        } else {
            // No saved settings, save the defaults and retry
            UserDefaults.standard.setValue(DEFAULT_SETTINGS, forKey: SETTINGS_KEY)
            UserDefaults.standard.synchronize()
            loadSettingsAndSetElements()
        }
        
    }
    
    
    
    
    
    func createCommand() -> String {
    
        /*****************
         * create command *
         ******************/
        
        var command = "export PATH=$PATH:/usr/local/bin && youtube-dl";
        
        /*****************
         *  Playlist tab  *
         ******************/
        
        //append "download playlist" to command
        if downloadPlaylist.state == 1 {
            command += " --yes-playlist"
        }
        else{
            command += " --no-playlist"
        }
        
        //append "download playlist in reverse" to command
        if reversePlaylist.state == 1 {
            command += " --playlist-reverse"
        }
        
//        //append "flat playlist" to command
//        if flatPlaylist.state == 1 {
//            command += " --flat-playlist"
//        }
        
        //append ""start at video" to command
        if !startAtVideo.stringValue.isEmpty {
            command += " --playlist-start \(startAtVideo.stringValue)"
        }
        
        //append "stop at video" to command
        if !stopAtVideo.stringValue.isEmpty {
            command += " --playlist-end \(stopAtVideo.stringValue)"
        }
        
        //append "download specific videos" to command
        if !downloadSpecificVideos.stringValue.isEmpty {
            command += " --playlist-items \(downloadSpecificVideos.stringValue)"
        }
        
        
        /***********************
         *  Authentication tab  *
         ************************/
        
        //append "username" to command
        if !username.stringValue.isEmpty {
            command += " --username \(username.stringValue)"
        }
        
        //append "password" to command
        if !password.stringValue.isEmpty {
            command += " --password \(password.stringValue)"
        }
        
        //append "2 factor authentication code" to command
        if !twoFactorCode.stringValue.isEmpty {
            command += " --twofactor \(twoFactorCode.stringValue)"
        }
        
        //append "video password" to command
        if !videoPassword.stringValue.isEmpty {
            command += " --video-password \(videoPassword.stringValue)"
        }
        
        //append "netrc" to command
        if netrc.state == 1 {
            command += " --netrc"
        }
        
        
        /*****************
         *   Audio tab    *
         ******************/
        
        //append extract audio to command
        if extractAudio.state == 1 {
            command += " --extract-audio"
        }
        
        //append audio format to command
        let audioFormatString = audioFormat.selectedItem?.title.characters.split{$0 == "\""}.map(String.init) //item to string
        command += " --audio-format \(audioFormatString![0])"
        
        //append audio quality to command
        let audioQualityString = audioQuality.selectedItem!.title.characters.split{$0 == "\""}.map(String.init) //item to string
        let audioQ = audioQualityString.first!.characters.first
        command += " --audio-quality \(audioQ!)"
        
        //append "keep video" to command
        if keepVideo.state == 1 {
            command += " --keep-video"
        }
        
        /*****************
         *  Video tab    *
         ******************/
        
        //append "video format" to command
        let videoFormatString = videoFormat.selectedItem!.tag
        if videoFormatString > 0 {
            command += " --format \(videoFormatString)"
        }
        
        //append "download all formats" to command
        if downloadAllFormats.state == 1 {
            command += " --all-formats"
        }
        
        //append "prefer free formats" to command
        if preferFreeFormats.state == 1 {
            command += " --prefer-free-formats "
        }
        
        //append "skip dash manifest" to command
        if skipDashManifest.state == 1 {
            command += " --youtube-skip-dash-manifest"
        }
        
        
        /********************
         *  Subtitles tab    *
         *********************/
        
        command += " --sub-format srt"  //always SRT
        
        //append "download subtitles" to command
        if downloadSubs.state == 1 {
            command += " --write-sub"
        }
        
        //append "download auto subtitles" to command
        if downloadAutoSubs.state == 1 {
            command += " --write-auto-sub"
        }
        
        //append "download all subtitles" to command
        if downloadAllSubs.state == 1 {
            command += " --all-subs"
        }
        
        //append "embed subtitles" to command
        if embedSubs.state == 1 {
            command += " --embed-subs"
        }
        
        //append "language subs" to command
        if languageSubs.selectedItem!.tag > 0 {
            var subLanguage = ""
            switch languageSubs.selectedItem!.tag {
            case 1: subLanguage = "en"
            case 2: subLanguage = "gr"
            case 3: subLanguage = "pt"
            case 4: subLanguage = "fr"
            case 5: subLanguage = "it"
            case 6: subLanguage = "ru"
            case 7: subLanguage = "es"
            case 8: subLanguage = "de"
            case 9: subLanguage = "nl"
            default: subLanguage = "en"
            }
            command += " --sub-lang \(subLanguage)"
        }
        
        
        
        /*****************
         *  General tab   *
         ******************/
        
        //append max file size to command
        if !maxFileSize.stringValue.isEmpty {
            command += " --max-filesize \(maxFileSize.stringValue)M"
        }
        
        //append ignore errors to command
        if ignoreErrors.state == 1 {
            command += " --ignore-errors"
        }
        else{
            command += " --abort-on-error"
        }
        
        //append output destination to command
        let pathString = pathChooser.url?.path.characters.split{$0 == "\""}.map(String.init) //item to string
        command += " -o \(pathString![0])/"
        
        //append output template
        switch outputTemplate.selectedItem!.tag {
        case 0: command += "'%(title)s.%(ext)s'"
        case 1: command += "'%(playlist)s/%(title)s.%(ext)s'"
        case 2: command += "'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
        default: command += "'%(title)s.%(ext)s'"
            
        }
        
        //append input URLs to the command
//        for url in inputURLS_array {
//            command += " \(url)"
//        }
//        
        
        return command
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        //we want to save the settings
        saveSettings()
        UserDefaults.standard.setValue(createCommand(), forKey: SAVED_COMMAND)
        UserDefaults.standard.synchronize()
    }
    
}
