//
//  RoomsTableViewController.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import UIKit
import CoreBluetooth

class RoomsTableViewController: UITableViewController {

    
    var peripheralManager = CBPeripheralManager()
    var centralManager: CBCentralManager?
    
    let roomsCellReuseIdentifier = "RoomsTableViewCell"
    var visibleDevices = Array<Device>()
    var cachedDevices = Array<Device>()
    var cachedPeripheralNames = Dictionary<String, String>()
    var timer = Timer()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
     
        scheduledTimerWithTimeInterval()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateAdvertisingData()
    }
    
    func scheduledTimerWithTimeInterval(){

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.clearPeripherals), userInfo: nil, repeats: true)
    }
    
    @objc func clearPeripherals(){

        visibleDevices = cachedDevices
        cachedDevices.removeAll()
        tableView?.reloadData()
    }
    
    func updateAdvertisingData() {
        print("also here doing stuff i shouldn't be")
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let userData = UserData()
        let advertisementData = String(format: "%@", userData.name)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    
    func addOrUpdatePeripheralList(device: Device, list: inout Array<Device>) {

        if !list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            
            list.append(device)
            tableView?.reloadData()
        }
        else if list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier
            && $0.name == "unknown"}) && device.name != "unknown" {
            
            for index in 0..<list.count {
                
                if (list[index].peripheral.identifier == device.peripheral.identifier) {
                    
                    list[index].name = device.name
                    tableView?.reloadData()
                    break
                }
            }
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

}

extension RoomsTableViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section: ", section)
//        return visibleDevices.count
        return 1
    }

    // make a cell for each cell index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: roomsCellReuseIdentifier, for: indexPath as IndexPath) as! RoomsTableViewCell
//        print("visibleDevices[indexPath.row]: ", visibleDevices[indexPath.row])
        if (visibleDevices.isEmpty) {
            return cell
        }
        else {
            let device = visibleDevices[indexPath.row]
            let advertisementData = device.name.components(separatedBy: "|")

            if (advertisementData.count > 1) {

                cell.roomsNameLabel.text = advertisementData[0]
            }
            else {
                cell.roomsNameLabel.text = device.name
            }

            return cell
        }
        
    }

}

extension RoomsTableViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let chatViewController = ChatViewController()
//        chatViewController.deviceUUID = visibleDevices[indexPath.row].peripheral.identifier
//        chatViewController.deviceAttributes = visibleDevices[indexPath.row].name
//        self.navigationController?.pushViewController(chatViewController, animated: true)
    }
}


//extension RoomsTableViewController : CBPeripheralManagerDelegate {
//
//    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
//
//        if (peripheral.state == .poweredOn){
//
//            updateAdvertisingData()
//        }
//    }
//}

extension RoomsTableViewController : CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("rooms state is powered on: ", central.state == .poweredOn)
        if (central.state == .poweredOn){
            
            self.centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName = cachedPeripheralNames[peripheral.identifier.description] ?? "unknown"
        
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
            peripheralName = advertisementName
            cachedPeripheralNames[peripheral.identifier.description] = peripheralName
        }
        
        let device = Device(peripheral: peripheral, name: peripheralName)
        
        self.addOrUpdatePeripheralList(device: device, list: &visibleDevices)
        self.addOrUpdatePeripheralList(device: device, list: &cachedDevices)
        print("visible devices: ", visibleDevices)
    }
}
