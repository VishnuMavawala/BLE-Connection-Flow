//
//  BLEManager.swift
//  BLE-Connection-Flow
//
//  Created by Vishnu Mavawala on 07/05/26.
//

import Foundation
import CoreBluetooth
import Combine
import SwiftUI

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    @Published var isSwitchedOn = false
    @Published var discoveredPeripherals = [CBPeripheral]()
    @Published var connectedPeripheral: CBPeripheral?
    @State var txt: String = ""

    // Replace with your device's Service UUID if known
    let serviceUUID = [CBUUID(string: constant.serviceNotify)] //(string: "1807") // Example: Heart Rate Service

    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    func startScanning() async {
        print("Scanning started")
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }

    func stopScanning() {
        centralManager.stopScan()
    }

    func connect(peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        connectedPeripheral?.delegate = self
        centralManager.connect(peripheral, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        connectedPeripheral = nil
        print("Did disconnect from: ", peripheral)
    }

    // MARK: - Central Manager Delegates
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            isSwitchedOn = true
        } else {
            isSwitchedOn = false
        }
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
            print((peripheral.name ?? "??"), RSSI)
            print(peripheral.identifier)
            print(peripheral.services)
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        stopScanning()
        peripheral.discoverServices(nil)
    }

    // MARK: - Peripheral Delegates
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("services: ", service.uuid.uuidString)
            // Discover characteristics for the service
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: (any Error)?) {
        guard let characteristics = service.characteristics else { return }
        
        for char in characteristics {
            print("Characteristics: ", char.uuid.uuidString)
            if constant.characteristicNotifyNotify == char.uuid.uuidString {
                peripheral.setNotifyValue(true, for: char)
            }
//            peripheral.readValue(for: char)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic.isNotifying {
            print("Successfully subscribed to notifications for \(characteristic.uuid)")
        } else {
            print("Notifications stopped for \(characteristic.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        let data = characteristic.value
        print(characteristic.service?.uuid.uuidString, characteristic.uuid.uuidString)
        print(data ?? "")
    }
    
    func sentPeripheralData() {
        if let char = connectedPeripheral?.services?.filter({ $0.uuid.uuidString == constant.serviceNotify }).first?.characteristics?.filter({ $0.uuid.uuidString == constant.characteristicNotifyNotify }).first {
            connectedPeripheral?.writeValue("Done".data(using: .utf8)!, for: char, type: .withResponse)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        print("Write failed for \(characteristic.uuid): \(error?.localizedDescription)")
    }
}
