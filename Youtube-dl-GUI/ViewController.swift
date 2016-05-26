//
//  ViewController.swift
//  Youtube-dl-GUI
//
//  Created by Kevin De Koninck on 23/05/16.
//  Copyright © 2016 Kevin De Koninck. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    //input and output GUI elements
    @IBOutlet var inputURLS: NSTextView!
    @IBOutlet var outputWindow: NSTextView!
    
    //settings GUI elements
    @IBOutlet weak var maxFileSize: NSTextField!
    @IBOutlet weak var ignoreErrors: NSButton!
    @IBOutlet weak var extractAudio: NSButton!
    @IBOutlet weak var audioFormat: NSPopUpButton!
    @IBOutlet weak var pathChooser: NSPathCell!


    //will excecute when we psuh on the download-button
    @IBAction func downloadButton(sender: AnyObject) {
       
        //erase text from outputWindow
        outputWindow.textStorage!.mutableString.setString("")
        
        //get input URLs and devide them in an array
        let tempString = inputURLS.string!
        let inputURLS_array = tempString.characters.split{$0 == "\n"}.map(String.init) //array: inputURL[0] inputURL[1] ...
        
        
        
        
        /*
 
         src: https://github.com/MrS0m30n3/youtube-dl-gui/blob/master/youtube_dl_gui/optionsframe.py
         
         
         VALID_VIDEO_FORMAT = ('0', '17', '36', '5', '34', '35', '43', '44', '45',
         '46', '18', '22', '37', '38', '160', '133', '134', '135', '136','137',
         '264', '138', '242', '243', '244', '247', '248', '271', '272', '82',
         '83', '84', '85', '100', '101', '102', '139', '140', '141', '171', '172')
         
         VALID_AUDIO_FORMAT = ('mp3', 'wav', 'aac', 'm4a', 'vorbis', 'opus')
         
         VALID_AUDIO_QUALITY = ('0', '5', '9')
         
         VALID_OUTPUT_FORMAT = ('title', 'id', 'custom')
         
         VALID_FILESIZE_UNIT = ('', 'k', 'm', 'g', 't', 'p', 'e', 'z', 'y')
         
         VALID_SUB_LANGUAGE = ('en', 'gr', 'pt', 'fr', 'it', 'ru', 'es', 'de')

         
         
 
         'save_path': os_path_expanduser('~'),
         'video_format': '0',
         'second_video_format': '0',
         'to_audio': False,
         'keep_video': False,
         'audio_format': 'mp3',
         'audio_quality': '5',
         'restrict_filenames': False,
         'output_format': 'title',
         'output_template': '%(uploader)s/%(title)s.%(ext)s',
         'playlist_start': 1,
         'playlist_end': 0,
         'max_downloads': 0,
         'min_filesize': 0,
         'max_filesize': 0,
         'min_filesize_unit': '',
         'max_filesize_unit': '',
         'write_subs': False,
         'write_all_subs': False,
         'write_auto_subs': False,
         'embed_subs': False,
         'subs_lang': 'en',
         'ignore_errors': True,
         'open_dl_dir': True,
         'write_description': False,
         'write_info': False,
         'write_thumbnail': False,
         'retries': 10,
         'user_agent': '',
         'referer': '',
         'proxy': '',
         'shutdown': False,
         'sudo_password': '',
         'username': '',
         'password': '',
         'video_password': '',
         'youtubedl_path': self.config_path,
         'cmd_args': '',
         'enable_log': True,
         'log_time': False,
         'workers_number': 3,
         'locale_name': 'en_US',
         'main_win_size': (700, 490),
         'opts_win_size': (640, 270)

         
         ("17", "3gp [176x144]"),
         ("36", "3gp [320x240]"),
         ("5", "flv [400x240]"),
         ("34", "flv [640x360]"),
         ("35", "flv [854x480]"),
         ("43", "webm [640x360]"),
         ("44", "webm [854x480]"),
         ("45", "webm [1280x720]"),
         ("46", "webm [1920x1080]"),
         ("18", "mp4 [640x360]"),
         ("22", "mp4 [1280x720]"),
         ("37", "mp4 [1920x1080]"),
         ("38", "mp4 [4096x3072]"),
         ("160", "mp4 144p (DASH)"),
         ("133", "mp4 240p (DASH)"),
         ("134", "mp4 360p (DASH)"),
         ("135", "mp4 480p (DASH)"),
         ("136", "mp4 720p (DASH)"),
         ("137", "mp4 1080p (DASH)"),
         ("264", "mp4 1440p (DASH)"),
         ("138", "mp4 2160p (DASH)"),
         ("242", "webm 240p (DASH)"),
         ("243", "webm 360p (DASH)"),
         ("244", "webm 480p (DASH)"),
         ("247", "webm 720p (DASH)"),
         ("248", "webm 1080p (DASH)"),
         ("271", "webm 1440p (DASH)"),
         ("272", "webm 2160p (DASH)"),
         ("82", "mp4 360p (3D)"),
         ("83", "mp4 480p (3D)"),
         ("84", "mp4 720p (3D)"),
         ("85", "mp4 1080p (3D)"),
         ("100", "webm 360p (3D)"),
         ("101", "webm 480p (3D)"),
         ("102", "webm 720p (3D)"),
         ("139", "m4a 48k (DASH AUDIO)"),
         ("140", "m4a 128k (DASH AUDIO)"),
         ("141", "m4a 256k (DASH AUDIO)"),
         ("171", "webm 48k (DASH AUDIO)"),
         ("172", "webm 256k (DASH AUDIO)")
 
        */
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        //create command
        var command = "export PATH=$PATH:/usr/local/bin && youtube-dl";
        
        //append max file size to command
        if !maxFileSize.stringValue.isEmpty {
            command += " --max-filesize \(maxFileSize.stringValue)M"
        }

        //append ignore errors to command
        if ignoreErrors.state == 1 {
            command += " --ignore-errors"
        }
        
        //append extract audio to command
        if extractAudio.state == 1 {
            command += " --extract-audio"
        }
        
        //append audio format to command
        let audioFormatString = audioFormat.selectedItem?.title.characters.split{$0 == "\""}.map(String.init) //item to string
        command += " --audio-format \(audioFormatString![0])"
    
        //append output destination to command
        let pathString = pathChooser.URL?.path!.characters.split{$0 == "\""}.map(String.init) //item to string
        command += " -o \(pathString![0])/'%(title)s.%(ext)s'"
        
        //append input URLs to the command
        for url in inputURLS_array {
            command += " \(url)"
        }
        

        
        

        
        //the following code (from stackoverflow) will excecute the youtube-dl command and will add the output from the command
        //to the output window (real time output)
        // http://stackoverflow.com/questions/29548811/real-time-nstask-output-to-nstextview-with-swift
        
        var arguments:[String] = []
        arguments.append("-c")
        arguments.append( command )
        

        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = arguments
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        let outHandle = pipe.fileHandleForReading
        outHandle.waitForDataInBackgroundAndNotify()
        
        var obs1 : NSObjectProtocol!
        obs1 = NSNotificationCenter.defaultCenter().addObserverForName(NSFileHandleDataAvailableNotification,
                                                                       object: outHandle, queue: nil) {  notification -> Void in
                                                                        let data = outHandle.availableData
                                                                        if data.length > 0 {
                                                                            if let str = NSString(data: data, encoding: NSUTF8StringEncoding) {
                                                                                //print("got output: \(str)")
                                                                                //RECEIVED OUTPUT
                                                                                self.outputWindow.insertText( "\(str)" )
                                                                            
                                                                            }
                                                                            outHandle.waitForDataInBackgroundAndNotify()
                                                                        } else {
                                                                            //print("EOF on stdout from process")
                                                                            //self.outputWindow.insertText( "\nEOF on stdout from process" )
                                                                            NSNotificationCenter.defaultCenter().removeObserver(obs1)
                                                                        }
        }
        
        var obs2 : NSObjectProtocol!
        obs2 = NSNotificationCenter.defaultCenter().addObserverForName(NSTaskDidTerminateNotification,
                                                                       object: task, queue: nil) { notification -> Void in
                                                                        //print("terminated")
                                                                        self.outputWindow.insertText( "\n\nDONE.\n" )
                                                                        NSNotificationCenter.defaultCenter().removeObserver(obs2)
        }
        
        task.launch()
        
    }
    
    
    
    //this function will excecute once when the view has been loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set texts
       // inputURLS.insertText("\n\nInsert your URLs here. Seperate multiple URLS with a breakline (enter).")
        outputWindow.insertText( "\n\nThis will contain some debugging information when downloading your requested files.\n" )
        
        
  //      inputURLS.toolTip("Insert your URLs here. Seperate multiple URLS with a breakline (enter).")
        
        //Default value for the maximum file size is 15MB
        maxFileSize.stringValue = "15"
        
        //Delete default path
        pathChooser.pathComponentCells.removeAll()
        
        // TODO - set the default path to the user his downloads folder
        let username = system ("whoami")
        // pathChooser.URL?.path = "/"
        
        
    }

    
    
    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    

}

