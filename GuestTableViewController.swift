//
//  GuestTableViewController.swift
//  ProjectZero
//
//  Created by phing on 2019-11-17.
//  Copyright © 2019 phing. All rights reserved.
//

// cell is overwritten in here? method 2?

import UIKit
import AVKit
import CoreBluetooth
import MediaPlayer
import AVFoundation

class GuestTableViewController: UITableViewController {

//    let musicPlayer = MPMusicPlayerApplicationController.systemMusicPlayer
    var musicPlayer = AVPlayer()
    
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
    func downloadFileFromURL(url:NSURL){
        
        var downloadTask:URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url as URL, completionHandler: { [weak self](URL, response, error) -> Void in
            self!.musicPlayer = AVPlayer(url: URL!)

            self!.musicPlayer.play()
        })

        downloadTask.resume()

    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {

        if (peripheral.state == .poweredOn){

            initService()
            updateAdvertisingData()
        }
    }
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
//        let musicPlayer = MPMusicPlayerApplicationController.applicationQueuePlayer
        var url: NSURL!
        for request in requests {
            if let value = request.value {
//                let musicPlayer = (data: value, encoding: encoding.utf8)
                let message = String(data: value, encoding: String.Encoding.utf8)!
                print("message received from central: ", message)
                url = URL(string: message) as NSURL?
                downloadFileFromURL(url: url!)
                
            }
            self.peripheralManager.respond(to: request, withResult: .success)
        }
    }
    
}

func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    print("download complete")
    
}
