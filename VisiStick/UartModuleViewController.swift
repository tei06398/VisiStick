//
//  UartModuleViewController.swift
//  Basic Chat
//
//  Created by Trevor Beaton on 12/4/16.
//  Copyright © 2016 Vanguard Logic LLC. All rights reserved.
//
//  Adopted and Modified by Seth Teichman for the VisiStick Project on 4/12/19.
//  Copyright © 2019 VisiStick. All rights reserved.





import UIKit
import CoreBluetooth
import AVKit

class UartModuleViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    //UI
    @IBOutlet weak var baseTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var switchUI: UISwitch!
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    var debugEnabled: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        self.baseTextView.delegate = self
        self.inputTextField.delegate = self
        //Base text view setup
        self.baseTextView.layer.borderWidth = 3.0
        self.baseTextView.layer.borderColor = UIColor.blue.cgColor
        self.baseTextView.layer.cornerRadius = 3.0
        self.baseTextView.text = ""
        //Input Text Field setup
        self.inputTextField.layer.borderWidth = 2.0
        self.inputTextField.layer.borderColor = UIColor.blue.cgColor
        self.inputTextField.layer.cornerRadius = 3.0
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.baseTextView.text = ""
        
        
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
                self.recievedPings.append(Int(characteristicASCIIValue.intValue))
            } else {
                var total: NSInteger = 0
                for i in self.recievedPings {
                    total+=i
                }
                self.recievedPings = []
                let appendString = "\n"
                let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
                let myAttributes2 = [NSFontAttributeName: myFont!, NSForegroundColorAttributeName: UIColor.red]
                let attribString = NSAttributedString(string: "[AVG]: " + (String(total/3)) + appendString, attributes: myAttributes2)
                
                let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
                self.baseTextView.attributedText = NSAttributedString(string: characteristicASCIIValue as String , attributes: myAttributes2)
                
                newAsciiText.append(attribString)
                print("AVG: " + String(total/3))
                
                self.consoleAsciiText = newAsciiText
                self.baseTextView.attributedText = self.consoleAsciiText
            }
            if self.debugEnabled {
                let appendString = "\n"
                let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
                let myAttributes2 = [NSFontAttributeName: myFont!, NSForegroundColorAttributeName: UIColor.red]
                let attribString = NSAttributedString(string: "[Incoming]: " + (characteristicASCIIValue as String) + appendString, attributes: myAttributes2)
                let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
                self.baseTextView.attributedText = NSAttributedString(string: characteristicASCIIValue as String , attributes: myAttributes2)
                
                newAsciiText.append(attribString)
                
                self.consoleAsciiText = newAsciiText
                self.baseTextView.attributedText = self.consoleAsciiText
            }
            print("IN:" + (characteristicASCIIValue as String))
            do {
                self.inchToBeep(distance: Int(characteristicASCIIValue.intValue))
                let url = URL(fileURLWithPath: self.beep!)
                self.audioPlayer = try AVAudioPlayer(contentsOf: url )
                self.audioPlayer.play()
            }
            catch{
                print(error)
            }
        }
    }
    
    @IBAction func clickSendAction(_ sender: AnyObject) {
        outgoingData()
        
    }
    
    
    
    func outgoingData () {
        let appendString = "\n"
        
        let inputText = inputTextField.text
        
        let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
        let myAttributes1 = [NSFontAttributeName: myFont!, NSForegroundColorAttributeName: UIColor.blue]
        
        writeValue(data: inputText!)
        
        let attribString = NSAttributedString(string: "[Outgoing]: " + inputText! + appendString, attributes: myAttributes1)
        let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)
        newAsciiText.append(attribString)
        
        consoleAsciiText = newAsciiText
        baseTextView.attributedText = consoleAsciiText
        //erase what's in the text field
        inputTextField.text = ""
        
    }
    
    // Write functions
    func writeValue(data: String){
        let valueString = (data as NSString).data(using: String.Encoding.utf8.rawValue)
        //change the "data" to valueString
        if let blePeripheral = blePeripheral{
            if let txCharacteristic = txCharacteristic {
                blePeripheral.writeValue(valueString!, for: txCharacteristic, type: CBCharacteristicWriteType.withResponse)
            }
        }
    }
    
    func writeCharacteristic(val: Int8){
        var val = val
        let ns = NSData(bytes: &val, length: MemoryLayout<Int8>.size)
        blePeripheral!.writeValue(ns as Data, for: txCharacteristic!, type: CBCharacteristicWriteType.withResponse)
    }
    
    
    
    //MARK: UITextViewDelegate methods
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView === baseTextView {
            //tapping on consoleview dismisses keyboard
            inputTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:250), animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x:0, y:0), animated: true)
    }
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }
    
    //This on/off switch sends a value of 1 and 0 to the Arduino
    //This can be used as a switch or any thing you'd like
    @IBAction func switchAction(_ sender: Any) {
        if switchUI.isOn {
            debugEnabled = true
        }
        else
        {
            debugEnabled = false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        outgoingData()
        return(true)
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }
}

