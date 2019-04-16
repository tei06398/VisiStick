//
//  PeripheralTableViewCell.swift
//  Basic Chat
//
//  Created by Trevor Beaton on 11/30/16.
//  Copyright © 2016 Vanguard Logic LLC. All rights reserved.
//
//  Adopted and Modified by Seth Teichman for the VisiStick Project on 4/12/19.
//  Copyright © 2019 VisiStick. All rights reserved.

import UIKit

class PeripheralTableViewCell: UITableViewCell {

    @IBOutlet weak var peripheralLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
