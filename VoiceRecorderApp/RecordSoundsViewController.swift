//
//  ViewController.swift
//  VoiceRecorderApp
//
//  Created by Alejandro Franco on 01/02/20.
//  Copyright © 2020 Alejandro Franco. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var btnStopRecord: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnStopRecord.isEnabled = false
        self.btnStopRecord.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func recordAudio(_ sender: Any) {
        print("Recording button pressed")
        self.btnRecord.isEnabled = false
        self.btnRecord.isHidden = true
        self.btnStopRecord.isEnabled = true
        self.btnStopRecord.isHidden = false
        self.lblRecording.text = "Recording..."
        self.lblRecording.textColor = UIColor.red
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
//        print(filePath)
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("Stop recording button pressed")
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("Desaparecí")
        self.btnRecord.isEnabled = true
        self.btnRecord.isHidden = false
        self.btnStopRecord.isEnabled = false
        self.btnStopRecord.isHidden = true
        self.lblRecording.text = "Tap to record"
        self.lblRecording.textColor = UIColor.black
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("No se pudo grabar")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

