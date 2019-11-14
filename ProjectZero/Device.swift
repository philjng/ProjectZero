//
//  Device.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import Foundation
import CoreBluetooth

struct Device {
    
    var peripheral : CBPeripheral
    var name : String
    
    init(peripheral: CBPeripheral, name:String) {
        self.peripheral = peripheral
        self.name = name
    }
}
