//
//  HomeViewController.swift
//  VisiStick
//
//  Created by PLTW Student on 4/4/19.
//  Copyright © 2019 VisiStick. All rights reserved.
//

import UIKit
import CoreBluetooth
import AVFoundation

class HomeViewController: UIViewController {
    var audioPlayer = AVAudioPlayer()
    //Crashes on First Run?
    
    var beep = Bundle.main.path(forResource: "beep", ofType: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func play(_ sender: Any) {
        do {
            let url = URL(fileURLWithPath: beep!)
            audioPlayer.stop()
            audioPlayer = try AVAudioPlayer(contentsOf: url )
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }

}
