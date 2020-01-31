//
//  OptionsViewController.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 28/01/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Cocoa
import ITSwitch

class OptionsViewController: NSViewController {
    
    var getIt = GetIt()

    //General tab
    @IBOutlet weak var maxFileSize: NSTextField!
    @IBOutlet weak var ignoreErrors: ITSwitch!
    @IBOutlet weak var outputTemplate: NSPopUpButton!
    @IBOutlet weak var selectedPath: NSTextField!
    
    @IBOutlet var installProgressView: progressView!
    @IBOutlet weak var installProgressText: NSTextField!
    
    //audio tab
    @IBOutlet weak var extractAudio: ITSwitch!
    @IBOutlet weak var audioFormat: NSPopUpButton!
    @IBOutlet weak var audioQuality: NSPopUpButton!
    @IBOutlet weak var keepVideo: ITSwitch!
    
    //Video tab
    @IBOutlet weak var videoFormat: NSPopUpButton!
    @IBOutlet weak var downloadAllFormats: ITSwitch!
    @IBOutlet weak var preferFreeFormats: ITSwitch!
    @IBOutlet weak var skipDashManifest: ITSwitch!
    
    //subtitles tab
    @IBOutlet weak var downloadSubs: ITSwitch!
    @IBOutlet weak var downloadAutoSubs: ITSwitch!
    @IBOutlet weak var downloadAllSubs: ITSwitch!
    @IBOutlet weak var languageSubs: NSPopUpButton!
    @IBOutlet weak var embedSubs: ITSwitch!
    
    //playlist tab
    @IBOutlet weak var downloadPlaylist: ITSwitch!
    @IBOutlet weak var reversePlaylist: ITSwitch!
    @IBOutlet weak var startAtVideo: NSTextField!
    @IBOutlet weak var stopAtVideo: NSTextField!
    @IBOutlet weak var downloadSpecificVideos: NSTextField!
    
    //authentication tab
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSSecureTextField!
    @IBOutlet weak var twoFactorCode: NSSecureTextField!
    @IBOutlet weak var netrc: ITSwitch!
    @IBOutlet weak var videoPassword: NSSecureTextField!
    


    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        
        //Switch color
        ignoreErrors.tintColor = blueColor
        extractAudio.tintColor = blueColor
        keepVideo.tintColor = blueColor
        downloadAllFormats.tintColor = blueColor
        preferFreeFormats.tintColor = blueColor
        skipDashManifest.tintColor = blueColor
        downloadSubs.tintColor = blueColor
        downloadAutoSubs.tintColor = blueColor
        downloadAllSubs.tintColor = blueColor
        embedSubs.tintColor = blueColor
        downloadPlaylist.tintColor = blueColor
        reversePlaylist.tintColor = blueColor
        netrc.tintColor = blueColor
        
        // progress view
        installProgressView.isHidden = true
        installProgressText.isHidden = true

        //placeholders
        maxFileSize.placeholderString = "In MB"
        username.placeholderString = "Enter your username"
        password.placeholderString = "Enter your password"
        twoFactorCode.placeholderString = "2FA code"
        videoPassword.placeholderString = "Enter the password"
        startAtVideo.placeholderString = "From"
        stopAtVideo.placeholderString = "To"
        downloadSpecificVideos.placeholderString = "E.g. 1-3,7,10-13"
        
        loadSettingsAndSetElements()
    }
    
    override func awakeFromNib() {
        if self.view.layer != nil {
            let color : CGColor = CGColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.view.layer?.backgroundColor = color
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        
        //we want to save the settings
        saveSettings()
        UserDefaults.standard.setValue(createCommand(), forKey: SAVED_COMMAND)

        //save output template
        var template: String = ""
        switch outputTemplate.selectedItem!.tag {
        case 0: template = "'%(title)s.%(ext)s'"
        case 1: template = "'%(playlist)s/%(title)s.%(ext)s'"
        case 2: template = "'%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s'"
        default: template = "'%(title)s.%(ext)s'"
        }
        
        UserDefaults.standard.setValue(template, forKey: OUTPUT_TEMPLATE)
        UserDefaults.standard.synchronize()
    }

    
    @IBAction func installSoftwareBtnClicked(_ sender: Any) {
        installProgressView.isHidden = false
        installProgressText.isHidden = false
        _ = getIt.execute(commandSynchronous: "if ! xcode-select -v &> /dev/null; then xcode-select --install; fi; if brew -v &> /dev/null; then brew update; else echo /usr/bin/ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'; fi; if brew ls --versions python &> /dev/null; then brew upgrade python; else brew install python; brew link python; fi; if brew ls --versions python3 &> /dev/null; then brew upgrade python3; else brew install python3; fi; if pip2.7 list | grep -i pycrypt &> /dev/null; then pip2.7 install pycrypt --upgrade; else pip2.7 install pycrypt; fi; if youtube-dl --version &> /dev/null; then brew upgrade youtube-dl; else brew install youtube-dl; fi; if brew list libav &> /dev/null; then brew upgrade libav; else brew install libav; fi; if brew list ffmpeg &> /dev/null; then brew upgrade ffmpeg; else brew install ffmpeg; fi")
        installProgressView.isHidden = true
        installProgressText.isHidden = true
    }
    
    @IBAction func loadDefaultsBtnClicked(_ sender: Any) {
        UserDefaults.standard.set(DEFAULT_SETTINGS, forKey: SETTINGS_KEY)
        UserDefaults.standard.setValue(DEFAULT_SETTINGS["path"]!, forKey: OUTPUT_PATH)
        UserDefaults.standard.synchronize()
        loadSettingsAndSetElements()
    }
    
    func saveSettings() {
        var settingsDict = [String: String]()

        settingsDict["maxFileSize"] = maxFileSize.stringValue.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: "")
        settingsDict["ignoreErrors"] = String(ignoreErrors.checked) == "true" ? "1" : "0"
        settingsDict["path"] = UserDefaults.standard.value(forKey: OUTPUT_PATH) as? String
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
        settingsDict["extractAudio"] = String(extractAudio.checked) == "true" ? "1" : "0"
        settingsDict["keepVideo"] = String(keepVideo.checked) == "true" ? "1" : "0"
        settingsDict["downloadAllFormats"] = String(downloadAllFormats.checked) == "true" ? "1" : "0"
        settingsDict["preferFreeFormats"] = String(preferFreeFormats.checked) == "true" ? "1" : "0"
        settingsDict["skipDashManifest"] = String(skipDashManifest.checked) == "true" ? "1" : "0"
        settingsDict["downloadSubs"] = String(downloadSubs.checked) == "true" ? "1" : "0"
        settingsDict["downloadAutoSubs"] = String(downloadAutoSubs.checked) == "true" ? "1" : "0"
        settingsDict["downloadAllSubs"] = String(downloadAllSubs.checked) == "true" ? "1" : "0"
        settingsDict["embedSubs"] = String(embedSubs.checked) == "true" ? "1" : "0"
        settingsDict["downloadPlaylist"] = String(downloadPlaylist.checked) == "true" ? "1" : "0"
        settingsDict["reversePlaylist"] = String(reversePlaylist.checked) == "true" ? "1" : "0"
        settingsDict["netrc"] = String(netrc.checked) == "true" ? "1" : "0"

        UserDefaults.standard.set(settingsDict, forKey: SETTINGS_KEY)
        UserDefaults.standard.synchronize()
    }
    
    func loadSettingsAndSetElements() {
        
        if let arr = UserDefaults.standard.value(forKey: SETTINGS_KEY) as? [String:String] {

            
            //Get and set all saved settings            
            if arr["path"] != nil {
                if let temp = UserDefaults.standard.value(forKey: OUTPUT_PATH) as? String {
                    selectedPath.stringValue = NSURL(fileURLWithPath: temp).lastPathComponent!
                } else { // BUG FIX
                    UserDefaults.standard.setValue(DEFAULT_OUTPUTPATH, forKey: OUTPUT_PATH)
                    UserDefaults.standard.synchronize()
                    selectedPath.stringValue = NSURL(fileURLWithPath: DEFAULT_OUTPUTPATH).lastPathComponent!
                }
            }
            else { selectedPath.stringValue = DEFAULT_SETTINGS["path"]! }
            
            if let val = arr["maxFileSize"] { maxFileSize.stringValue = val }
            else { maxFileSize.stringValue = DEFAULT_SETTINGS["maxFileSize"]! }
            
            if let val = arr["ignoreErrors"] { ignoreErrors.checked = val == "1" ? true : false }
            else { ignoreErrors.checked = DEFAULT_SETTINGS["ignoreErrors"]! == "1" ? true : false }
            
            if let val = arr["outputTemplate"] { outputTemplate.select(outputTemplate.item(withTitle: val)) }
            else { outputTemplate.select(outputTemplate.item(withTitle: DEFAULT_SETTINGS["outputTemplate"]!)) }
            
            if let val = arr["extractAudio"] { extractAudio.checked = val == "1" ? true : false }
            else { extractAudio.checked = DEFAULT_SETTINGS["extractAudio"]! == "1" ? true : false }
            
            if let val = arr["audioFormat"] { audioFormat.select(audioFormat.item(withTitle: val)) }
            else { audioFormat.select(audioFormat.item(withTitle: DEFAULT_SETTINGS["audioFormat"]!)) }
            
            if let val = arr["audioQuality"] { audioQuality.select(audioQuality.item(withTitle: val)) }
            else { audioQuality.select(audioQuality.item(withTitle: DEFAULT_SETTINGS["audioQuality"]!)) }
            
            if let val = arr["keepVideo"] { keepVideo.checked = val  == "1" ? true : false }
            else { keepVideo.checked = DEFAULT_SETTINGS["keepVideo"]! == "1" ? true : false }
            
            if let val = arr["videoFormat"] { videoFormat.selectItem(at: Int(val)!) }
            else { videoFormat.selectItem(at: Int(DEFAULT_SETTINGS["videoFormat"]!)!) }
            
            if let val = arr["downloadAllFormats"] { downloadAllFormats.checked = val == "1" ? true : false }
            else { downloadAllFormats.checked = DEFAULT_SETTINGS["downloadAllFormats"]! == "1" ? true : false }
            
            if let val = arr["preferFreeFormats"] { preferFreeFormats.checked = val == "1" ? true : false }
            else { preferFreeFormats.checked = DEFAULT_SETTINGS["preferFreeFormats"]! == "1" ? true : false }
            
            if let val = arr["skipDashManifest"] { skipDashManifest.checked = val == "1" ? true : false }
            else { skipDashManifest.checked = DEFAULT_SETTINGS["skipDashManifest"]! == "1" ? true : false }
            
            if let val = arr["downloadSubs"] { downloadSubs.checked = val == "1" ? true : false }
            else { downloadSubs.checked = DEFAULT_SETTINGS["downloadSubs"]! == "1" ? true : false }
            
            if let val = arr["downloadAutoSubs"] { downloadAutoSubs.checked = val == "1" ? true : false }
            else { downloadAutoSubs.checked = DEFAULT_SETTINGS["downloadAutoSubs"]! == "1" ? true : false }
            
            if let val = arr["downloadAllSubs"] { downloadAllSubs.checked = val == "1" ? true : false }
            else { downloadAllSubs.checked = DEFAULT_SETTINGS["downloadAllSubs"]! == "1" ? true : false }
            
            if let val = arr["embedSubs"] { embedSubs.checked = val == "1" ? true : false }
            else { embedSubs.checked = DEFAULT_SETTINGS["embedSubs"]! == "1" ? true : false }
            
            if let val = arr["languageSubs"] { languageSubs.selectItem(at: Int(val)!) }
            else { languageSubs.selectItem(at: Int(DEFAULT_SETTINGS["languageSubs"]!)!) }

            if let val = arr["downloadPlaylist"] { downloadPlaylist.checked = val == "1" ? true : false }
            else { downloadPlaylist.checked = DEFAULT_SETTINGS["downloadPlaylist"]! == "1" ? true : false }
            
            if let val = arr["reversePlaylist"] { reversePlaylist.checked = val == "1" ? true : false }
            else { reversePlaylist.checked = DEFAULT_SETTINGS["reversePlaylist"]! == "1" ? true : false }

            if let val = arr["startAtVideo"] { startAtVideo.stringValue = val }
            else { startAtVideo.stringValue = DEFAULT_SETTINGS["startAtVideo"]! }
            
            if let val = arr["stopAtVideo"] { stopAtVideo.stringValue = val }
            else { stopAtVideo.stringValue = DEFAULT_SETTINGS["stopAtVideo"]! }
            
            if let val = arr["downloadSpecificVideos"] { downloadSpecificVideos.stringValue = val }
            else { downloadSpecificVideos.stringValue = DEFAULT_SETTINGS["downloadSpecificVideos"]! }
            
            if let val = arr["username"] { username.stringValue = val }
            else { username.stringValue = DEFAULT_SETTINGS["username"]! }
            
            if let val = arr["password"] { password.stringValue = val }
            else { password.stringValue = DEFAULT_SETTINGS["password"]! }
            
            if let val = arr["twoFactorCode"] { twoFactorCode.stringValue = val }
            else { twoFactorCode.stringValue = DEFAULT_SETTINGS["twoFactorCode"]! }
            
            if let val = arr["netrc"] { netrc.checked = val == "1" ? true : false }
            else { netrc.checked = DEFAULT_SETTINGS["netrc"]! == "1" ? true : false }
            
            if let val = arr["videoPassword"] { videoPassword.stringValue = val }
            else { videoPassword.stringValue = DEFAULT_SETTINGS["videoPassword"]!}
            
        } else {
            // No saved settings?, save the defaults and retry
            UserDefaults.standard.setValue(DEFAULT_SETTINGS, forKey: SETTINGS_KEY)
            UserDefaults.standard.synchronize()
            loadSettingsAndSetElements()
        }
    }
    
    func createCommand() -> String {
        //Start of creating the command
        var command = EXPORT_PATH + " && youtube-dl --newline --prefer-ffmpeg";
        
        //Preprocessing
        let audioFormatString = audioFormat.selectedItem?.title.split{$0 == "\""}.map(String.init)
        let audioQualityString = audioQuality.selectedItem!.title.split{$0 == "\""}.map(String.init)
        let videoFormatString = videoFormat.selectedItem!.tag
        let audioQ = audioQualityString.first!.first
        
        //Creating the command
        if downloadPlaylist.checked { command += " --yes-playlist" } else { command += " --no-playlist" }
        if reversePlaylist.checked { command += " --playlist-reverse" }
        if !startAtVideo.stringValue.isEmpty { command += " --playlist-start \(startAtVideo.stringValue)" }
        if !stopAtVideo.stringValue.isEmpty { command += " --playlist-end \(stopAtVideo.stringValue)" }
        if !downloadSpecificVideos.stringValue.isEmpty { command += " --playlist-items \(downloadSpecificVideos.stringValue)" }
        if !username.stringValue.isEmpty { command += " --username \(username.stringValue)" }
        if !password.stringValue.isEmpty { command += " --password \(password.stringValue)" }
        if !twoFactorCode.stringValue.isEmpty { command += " --twofactor \(twoFactorCode.stringValue)" }
        if !videoPassword.stringValue.isEmpty { command += " --video-password \(videoPassword.stringValue)" }
        if netrc.checked { command += " --netrc" }
        if extractAudio.checked { command += " --extract-audio" }
        if keepVideo.checked { command += " --keep-video" }
        if videoFormatString > 0 { command += " --format \(videoFormatString)" }
        if downloadAllFormats.checked { command += " --all-formats" }
        if preferFreeFormats.checked { command += " --prefer-free-formats " }
        if skipDashManifest.checked { command += " --youtube-skip-dash-manifest" }
        if downloadSubs.checked { command += " --write-sub" }
        if downloadAutoSubs.checked { command += " --write-auto-sub" }
        if downloadAllSubs.checked { command += " --all-subs" }
        if embedSubs.checked { command += " --embed-subs" }
        if !maxFileSize.stringValue.isEmpty { command += " --max-filesize \(maxFileSize.stringValue.replacingOccurrences(of: ".", with: "").replacingOccurrences(of: ",", with: ""))M" }
        if ignoreErrors.checked == true { command += " --ignore-errors" } else { command += " --abort-on-error" }
        
        command += " --audio-format \(audioFormatString![0])"
        command += " --audio-quality \(audioQ!)"
        command += " --sub-format srt"  //always SRT
        
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
            case 10: subLanguage = "zh-Hans"
            case 11: subLanguage = "zh-Hant"
            default: subLanguage = "en"
            }
            command += " --sub-lang \(subLanguage)"
        }
        
        return command
    }
    
    
    @IBAction func folderIconClicked(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a folder"
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseFiles          = false
        dialog.canChooseDirectories    = true
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url
            if (result != nil) {
                let path = result!.path
                UserDefaults.standard.setValue(path, forKey: OUTPUT_PATH)
                UserDefaults.standard.synchronize()
                
                selectedPath.stringValue = NSURL(fileURLWithPath: path).lastPathComponent!
            }
        }
        
        //post notification to viewcontroller.swift to open the settingsview again (segue)
        NotificationCenter.default.post(NSNotification(name: NSNotification.Name(rawValue: "openSettingsView"), object: nil) as Notification)
        
    }
 
}
