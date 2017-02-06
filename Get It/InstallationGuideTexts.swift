//
//  InstallationGuideTexts.swift
//  Get It
//
//  Created by Kevin De Koninck on 05/02/2017.
//  Copyright © 2017 Kevin De Koninck. All rights reserved.
//

import Foundation

let PAGES = ["intro","xcode","brew","python","ytdl","finish"]

let TITLE:[String:String] = ["intro":"Introduction",
                             "xcode":"Xcode Command Line Tools",
                             "brew":"Homebrew",
                             "python":"Python interpreter",
                             "ytdl":"YouTube-DL and other dependencies",
                             "finish":"It's over now. It's done."]

let BODY:[String:String] = ["intro":"Before you can use Get It, we must install some dependencies. This guide will assist you with installing these dependencies.\nThe dependencies that we will install (if not already installed) are: Homebrew, Python, YouTube-DL and FFMPEG.\n\nLet's start by opening the Terminal app. Please keep this app open during the installation.",
                            "xcode":"Xcode development tools are some handy tools that are always nice to have on your system. Xcode is a large suite of software development tools and libraries from Apple. The Xcode Command Line Tools are part of XCode. Installation of many common Unix-based tools requires the GCC compiler. The Xcode Command Line Tools include a GCC compiler.\n\nCopy and paste the following line in the terminal app, press enter to execute the installation and follow the guide in your terminal.\n\nWhen you're finished, proceed to the next page.",
                            "brew":"Homebrew is the missing package manager for macOS. Homebrew can install software that apple did not provide.\nWe will be using Homebrew to install all the software that is needed for Get It.\n\nCopy and paste the following line in the terminal app, press enter to execute the installation and follow the guide in your terminal.\n\nWhen you're finished, proceed to the next page.",
                            "python":"YouTube-DL requires the python installer to operate. Let's install this using Homebrew.\n\nCopy and paste the following line in the terminal app, press enter to execute the installation and follow the guide in your terminal.\n\nWhen you're finished, proceed to the next page.",
                            "ytdl":"Now we want to install the core program for Get It: YouTube-DL. This can also be done using the Terminal app. We also want to install ffmpeg and libav for post processing of our files (e.g. converting our audio to mp3).\n\nCopy and paste the following line in the terminal app, press enter to execute the installation and follow the guide in your terminal.\n\nWhen you're finished, you can close this window and click on the blue refresh icon in Get It.",
                            "finish":"If you executed eveything correctly, then your installation is completed. \n\nYou may close this window (and the Terminal app) now and click on the little blue refresh icon (like the one below) to reload all software."]

let INSTALLATION_COMMANDS:[String:String] = ["intro":"",
                                             "xcode":"xcode-select --install",
                                             "brew":"/usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"",
                                             "python":"brew install python3",
                                             "ytdl":"brew install youtube-dl ffmpeg libav",
                                             "finish":""]
