//
//  ViewController.swift
//  AudioLearning
//
//  Created by zappycode on 3/6/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder : AVAudioRecorder?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let paths = [basePath, "iloveaudioios.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: paths) {
                
                var settings : [String : Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44_100.0
                settings[AVNumberOfChannelsKey] = 2
                
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
            
        }
       
        playerSetup(audioURL: nil)
    }
    
    func playerSetup(audioURL:URL?) {
        if audioURL == nil {
            if let audioPath = Bundle.main.path(forResource: "testAudio", ofType: "m4a") {
                var tempAudioURL = URL(fileURLWithPath: audioPath)
                audioPlayer = try? AVAudioPlayer(contentsOf: tempAudioURL)
            }
        } else {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL!)
        }
        audioPlayer?.prepareToPlay()
    }
    
    @IBAction func playTapped(_ sender: Any) {
        audioPlayer?.play()
    }
    
    @IBAction func pauseTapped(_ sender: Any) {
        audioPlayer?.pause()
    }
    
    @IBAction func stopTapped(_ sender: Any) {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
    }
    
    @IBAction func recordTapped(_ sender: Any) {
        if let recorder = audioRecorder {
            if !recorder.isRecording {
                recorder.record()
            }
        }
    }
    
    @IBAction func stopRecordingTapped(_ sender: Any) {
        if let recorder = audioRecorder {
            if recorder.isRecording {
                recorder.stop()
                playerSetup(audioURL: recorder.url)
            }
        }
    }
    
}

