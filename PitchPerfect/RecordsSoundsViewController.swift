//
//  RecordsSoundsViewController.swift
//  PitchPerfect
//
//  Created by jeremyborger on 5/3/17.
//  Copyright © 2017 jeremyborger. All rights reserved.
//

import UIKit
import AVFoundation

class RecordsSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
  

    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var recordingLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

   //MARK: - setup audio recording button
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(isRecording: true)
        //recordingLabel.text = "Recording in progress"
        //stopRecordingButton.isEnabled = true
        //recordButton.isEnabled = false
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        print(filePath)
        
        
    }
    //MARK: - setup stop recording button

    @IBAction func stopRecording(_ sender: Any) {
        configureUI(isRecording: false)
        
        //recordButton.isEnabled = true
        //stopRecordingButton.isEnabled = false
        //recordingLabel.text = "Tap to Record"
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }

    //MARK: - setup audio recording finish logic
  
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else {
            print("File was not saved")
        }
    }
    
    
    //MARK: - Segue to next view

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

    @IBOutlet weak var recordButton: UIButton!

    @IBOutlet weak var stopRecordingButton: UIButton!

    //MARK: - Logic to handle UI

   
    func configureUI(isRecording: Bool)  {
        if isRecording == true {
            recordButton.isEnabled = false
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "Recording in progress"
            
        }
        else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }
        
    }
    
}

