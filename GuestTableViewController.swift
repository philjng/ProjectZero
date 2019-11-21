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
import MediaPlayer

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
        var userData = UserData()
        userData.hostname = hostname
        userData.save()
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
        let advertisementData = String(format: "%@|%@", userData.name, hostname)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestTableViewCell", for: indexPath)
        return cell
    }

}

extension GuestTableViewController {
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(hostname)'s room"
        
    }
}

extension GuestTableViewController : CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        if (peripheral.state == .poweredOn){

            initService()
            updateAdvertisingData()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
//        let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        for request in requests {
            if let value = request.value {
//                let musicPlayer = (data: value, encoding: encoding.utf8)
                let messageText = String(data: value, encoding: String.Encoding.utf8)!
                print("message received from central: ", messageText)
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }

}
