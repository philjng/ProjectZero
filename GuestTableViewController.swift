//
//  GuestTableViewController.swift
//  ProjectZero
//
//  Created by phing on 2019-11-17.
//  Copyright © 2019 phing. All rights reserved.
//

// cell is overwritten in here? method 2?

import UIKit
import CoreBluetooth

class GuestTableViewController: UITableViewController {

    var peripheralManager = CBPeripheralManager()
    var hostname:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (lightTheme) {
            self.view.backgroundColor = blue2
            
        }
        else{
            self.view.backgroundColor = dark3
        }
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        

    }
    
    func initService() {

        let serialService = CBMutableService(type: Constants.SERVICE_UUID, primary: true)
        let rx = CBMutableCharacteristic(type: Constants.RX_UUID, properties: Constants.RX_PROPERTIES, value: nil, permissions: Constants.RX_PERMISSIONS)
        serialService.characteristics = [rx]

        peripheralManager.add(serialService)
    }
    
    func updateAdvertisingData() {
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let userData = UserData()
        let advertisementData = String(format: "%@", userData.name)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}

extension GuestTableViewController : CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        if (peripheral.state == .poweredOn){

            initService()
            updateAdvertisingData()
        }
    }

}
