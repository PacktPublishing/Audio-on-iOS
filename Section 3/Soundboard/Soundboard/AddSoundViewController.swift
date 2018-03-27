//
//  AddSoundViewController.swift
//  Soundboard
//
//  Created by zappycode on 3/6/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import AVFoundation

class AddSoundViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var addButton: UIButton!
    var audioRecorder : AVAudioRecorder?
    var audioPlayer : AVAudioPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playButton.isEnabled = false
        addButton.isEnabled = false
        
        micSetup()
    }
    
    func micSetup() {
        // Session
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        // URL for saving
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let filepatharray = [basePath, "dasound.m4a"]
            if let audioURL = NSURL.fileURL(withPathComponents: filepatharray) {
                var settings : [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44_100.0
                settings[AVNumberOfChannelsKey] = 2
                
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: Any) {
        if let recorder = audioRecorder {
            if recorder.isRecording {
                // Stop Recording
                recorder.stop()
                recordButton.setTitle("Record", for: .normal)
                playButton.isEnabled = true
                addButton.isEnabled = true
            } else {
                // Start recording
                recorder.record()
                recordButton.setTitle("Stop", for: .normal)
                playButton.isEnabled = false
                addButton.isEnabled = false
            }
        }
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        if let player = audioPlayer {
            if player.isPlaying {
                // Stop
                stopPlaying()
            } else {
                // Start
                startPlaying()
            }
        } else {
            startPlaying()
        }
    }
    
    func startPlaying() {
        if let audioURL = audioRecorder?.url {
            audioPlayer = try? AVAudioPlayer(contentsOf: audioURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            playButton.setTitle("Stop", for: .normal)
            recordButton.isEnabled = false
            addButton.isEnabled = false
        }
    }
    
    func stopPlaying() {
        audioPlayer?.stop()
        audioPlayer?.currentTime = 0
        playButton.setTitle("Play", for: .normal)
        recordButton.isEnabled = true
        addButton.isEnabled = true
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: .normal)
        recordButton.isEnabled = true
        addButton.isEnabled = true
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let soundToBeSaved = Sound(context: context)
            soundToBeSaved.name = nameTextfield.text
            if let audioURL = audioRecorder?.url {
                soundToBeSaved.soundData = try? Data(contentsOf: audioURL)
                try? context.save()
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
