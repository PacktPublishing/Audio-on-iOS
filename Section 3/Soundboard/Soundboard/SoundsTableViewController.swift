//
//  SoundsTableViewController.swift
//  Soundboard
//
//  Created by zappycode on 3/6/18.
//  Copyright © 2018 Nick Walter. All rights reserved.
//

import UIKit
import AVFoundation

class SoundsTableViewController: UITableViewController {
    
    var sounds : [Sound] = []
    var audioPlayer : AVAudioPlayer?

    override func viewWillAppear(_ animated: Bool) {
        getSounds()
    }
    
    func getSounds() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let tempSounds = try? context.fetch(Sound.fetchRequest()) as? [Sound] {
                if let theSounds = tempSounds {
                    sounds = theSounds
                    tableView.reloadData()
                }
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sounds.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        let soundToBeDisplayed = sounds[indexPath.row]

        cell.textLabel?.text = soundToBeDisplayed.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let soundToBePlayed = sounds[indexPath.row]
        if let audioData = soundToBePlayed.soundData {
            audioPlayer = try? AVAudioPlayer(data: audioData)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let soundToBeDeleted = sounds[indexPath.row]
             if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(soundToBeDeleted)
                getSounds()
            }
        }
    }

}
