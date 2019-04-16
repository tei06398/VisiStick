//
//  InfoViewController.swift
//  VisiStick
//
//  Created by Seth Teichman for the VisiStick Project on 4/4/19.
//  Copyright © 2019 VisiStick. All rights reserved.
//

import UIKit
import AVFoundation

class InfoViewController: UIViewController {
    var audioPlayer = AVAudioPlayer()
    var beep = Bundle.main.path(forResource: "beep", ofType: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segueToBLE(unwindSegue: UIStoryboardSegue) {
        
    }
    
    @IBAction func play(_ sender: Any) {
        do {
            let url = URL(fileURLWithPath: beep!)
            audioPlayer = try AVAudioPlayer(contentsOf: url )
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
