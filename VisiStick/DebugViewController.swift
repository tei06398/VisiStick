//
//  InfoViewController.swift
//  VisiStick
//
//  Created by Seth Teichman for the VisiStick Project on 4/4/19.
//  Copyright © 2019 VisiStick. All rights reserved.
//

import UIKit
import AVFoundation

class DebugViewController: UIViewController {
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
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderValue: UILabel!
    
    @IBAction func sliderSlid(_ sender: Any) {
        sliderValue.text = String(Int(slider.value))
    }
    
    @IBAction func play(_ sender: Any) {
        do {
            inchToBeep(distance: Int(slider.value))
            let url = URL(fileURLWithPath: beep!)
            audioPlayer = try AVAudioPlayer(contentsOf: url )
            audioPlayer.play()
        }
        catch{
            print(error)
        }
    }
    
    func inchToBeep(distance: Int) {
        switch distance {
        case 4, 5:
            setBeep(name: "1650hz", type: "wav")
        case 6, 7:
            setBeep(name: "1600hz", type: "wav")
        case 8, 9:
            setBeep(name: "1550hz", type: "wav")
        case 10, 11:
            setBeep(name: "1500hz", type: "wav")
        case 12, 13:
            setBeep(name: "1450hz", type: "wav")
        case 14, 15:
            setBeep(name: "1400hz", type: "wav")
        case 16, 17:
            setBeep(name: "1350hz", type: "wav")
        case 18, 19:
            setBeep(name: "1300hz", type: "wav")
        case 20, 21:
            setBeep(name: "1250hz", type: "wav")
        case 22, 23:
            setBeep(name: "1200hz", type: "wav")
        case 24, 25:
            setBeep(name: "1150hz", type: "wav")
        case 26, 27:
            setBeep(name: "1100hz", type: "wav")
        case 28, 29:
            setBeep(name: "1050hz", type: "wav")
        case 30, 31:
            setBeep(name: "1000hz", type: "wav")
        case 32, 33:
            setBeep(name: "950hz", type: "wav")
        case 34, 35:
            setBeep(name: "900hz", type: "wav")
        default:
            setBeep(name: "900hz", type: "wav")
        }
    }
    
    func setBeep(name: String, type: String) {
        beep = Bundle.main.path(forResource: name, ofType: type)
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
