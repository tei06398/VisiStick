//
//  UartModuleCleanViewController.swift
//
//  Created by Seth Teichman for the VisiStick Project on 4/12/19.
//  Copyright © 2019 VisiStick. All rights reserved.





import UIKit
import CoreBluetooth
import AVKit

class UartModuleCleanViewController: UIViewController, CBPeripheralManagerDelegate {
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    var debugEnabled: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Disconnect", style:.plain, target:nil, action:nil)
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // peripheralManager?.stopAdvertising()
        // self.peripheralManager = nil
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    var recievedPings: [NSInteger] = []
    
    var audioPlayer = AVAudioPlayer()
    var beep = Bundle.main.path(forResource: "beep", ofType: "mp3")
    
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
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            
            if (self.recievedPings.count < 3) {
                if !(characteristicASCIIValue.intValue <= 7) {
                    self.recievedPings.append(Int(characteristicASCIIValue.intValue))
                }
            } else {
                var total: NSInteger = 0
                for i in self.recievedPings {
                    total+=i
                }
                self.recievedPings = []
                
                print("AVG: " + String(total/3))
                do {
                    self.inchToBeep(distance: Int(total/3))
                    let url = URL(fileURLWithPath: self.beep!)
                    self.audioPlayer = try AVAudioPlayer(contentsOf: url )
                    self.audioPlayer.play()
                }
                catch{
                    print(error)
                }
            }
            print("IN:" + (characteristicASCIIValue as String))
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }
}


