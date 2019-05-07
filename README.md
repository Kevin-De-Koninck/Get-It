# Get It
A macOS video/audio downloader. Think of it as a youtube downloader that works on many sites.

<img src="https://github.com/Kevin-De-Koninck/Get-It/blob/master/ReadMe%20Resources/MainWindow.png?raw=true" height="400" /><img src="https://github.com/Kevin-De-Koninck/Get-It/blob/master/ReadMe%20Resources/Settings.png?raw=true" height="400" />

**Note**: Get It requires _Homebrew_. The required dependencies will be installed with _Homebrew_.

# Installation

Download it [here](https://github.com/Kevin-De-Koninck/Get-It/releases/download/v0.6.1/Get.It.app.zip), unzip it and open it.
To install the dependencies required to run the software, please open the settings in the app and click on 'Install/update software'. This will not update Get It, but it will update all dependencies.

## dependencies

Get It requires the following dependencies which you can install from within the app, or using the command line yourself (see below).  
The following list is required:
- xcode-select
- brew
- python
- python3
- pycrypt
- youtube-dl
- libav
- ffmpeg

To install the dependencies yourself, open the Terminal app and paste the following command:
``` bash
if ! xcode-select -v &> /dev/null; then xcode-select --install; fi; if brew -v &> /dev/null; then brew update; else echo /usr/bin/ruby -e '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)'; fi; if brew ls --versions python &> /dev/null; then brew upgrade python; else brew install python; brew link python; fi; if brew ls --versions python3 &> /dev/null; then brew upgrade python3; else brew install python3; fi; if pip2.7 list | grep -i pycrypt &> /dev/null; then pip2.7 install pycrypt --upgrade; else pip2.7 install pycrypt; fi; if youtube-dl --version &> /dev/null; then brew upgrade youtube-dl; else brew install youtube-dl; fi; if brew list libav &> /dev/null; then brew upgrade libav; else brew install libav; fi; if brew list ffmpeg &> /dev/null; then brew upgrade ffmpeg; else brew install ffmpeg; fi
```


# About

Get It will download audio and/or movies from many websites such as YouTube, BBC, Instagram, ... It's a GUI round the popular YouTube-DL command-line program but with an easy to use interface.
It will save your settings dynamically or you can restore the default settings. The default settings will download the audio from a video, convert it to an MP3 and save it to you downloads folder. This was, in my opinion, the mostly used setting.



# Submit a bug

You can submit a bug here on Github. Please provide the following:
- The URL(s) that you try to download.
- Your settings.

Also, open the Terminal app on your MacBook and issue the following command:
```
cat /tmp/getit_logs
```

Provide the output of the first command of you have an issue while installing the required software and provide the output of the second command of you have problems while downloading your URLs.

# THANKS

Thanks to [youtube-dl](https://github.com/rg3/youtube-dl) authors for creating such and amazing tool.
