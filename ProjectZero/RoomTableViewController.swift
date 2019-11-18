//
//  RoomTableViewController.swift
//  ProjectZero
//
//  Created by phing on 2019-11-13.
//  Copyright © 2019 phing. All rights reserved.
//

import UIKit
import CoreBluetooth

class RoomTableViewController: UITableViewController {

    var deviceUUID : UUID?
    var deviceAttributes : String = ""
    var selectedPeripheral : CBPeripheral?
    var centralManager : CBCentralManager?
    var cachedPeripheralNames = Dictionary<String, String>()

    var peripheralManager = CBPeripheralManager()
    var visibleDevices = Array<Device>()
    var cachedDevices = Array<Device>()
    var timer = Timer()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (lightTheme) {
            self.view.backgroundColor = blue2

        }
        else{
            self.view.backgroundColor = dark3
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func updateAdvertisingData() {

        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }

        let userData = UserData()
        let advertisementData = String(format: "%@", userData.name)

        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }

    func initService() {

        let serialService = CBMutableService(type: Constants.SERVICE_UUID, primary: true)
        let rx = CBMutableCharacteristic(type: Constants.RX_UUID, properties: Constants.RX_PROPERTIES, value: nil, permissions: Constants.RX_PERMISSIONS)
        serialService.characteristics = [rx]

        peripheralManager.add(serialService)
    }

    func scheduledTimerWithTimeInterval(){

        timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.clearPeripherals), userInfo: nil, repeats: true)
    }
    
    @objc func clearPeripherals(){
        visibleDevices = cachedDevices
        cachedDevices.removeAll()
        tableView?.reloadData()
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
}


extension RoomTableViewController : CBCentralManagerDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state is powered on: ", central.state == .poweredOn)
        if (central.state == .poweredOn){

            self.centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])

        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("here")
        var peripheralName = cachedPeripheralNames[peripheral.identifier.description] ?? "unknown"

        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {

            peripheralName = advertisementName
            cachedPeripheralNames[peripheral.identifier.description] = peripheralName
        }
        
        let device = Device(peripheral: peripheral, name: peripheralName)
        self.addOrUpdatePeripheralList(device: device, list: &visibleDevices)
        self.addOrUpdatePeripheralList(device: device, list: &cachedDevices)
        print("host visible devices (should be none until someone joins the room: ", visibleDevices)
    }
}

//extension RoomTableViewController : CBPeripheralDelegate {
//
//    func peripheral( _ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//
//        for service in peripheral.services! {
//
//            peripheral.discoverCharacteristics(nil, for: service)
//        }
//    }
//
//}

extension RoomTableViewController : CBPeripheralManagerDelegate {

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        if (peripheral.state == .poweredOn){

            initService()
            updateAdvertisingData()
        }
    }

}

extension RoomTableViewController {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return visibleDevices.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let userData = UserData()
        return "\(userData.name)'s room"
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return visibleDevices.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell  = tableView.dequeueReusableCell(withIdentifier: "RoomTableViewCell", for: indexPath) as! RoomTableViewCell
        if (visibleDevices.isEmpty) {
            return cell
        }
        else {
            let device = visibleDevices[indexPath.row]
            let advertisementData = device.name.components(separatedBy: "|")
            
            if (advertisementData.count > 1) {
                
                cell.roomNameLabel.text = advertisementData[0]
            }
            else {
                cell.roomNameLabel.text = device.name
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
    }
     

    
}
