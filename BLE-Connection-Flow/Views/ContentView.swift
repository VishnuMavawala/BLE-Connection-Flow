//
//  ContentView.swift
//  BLE-Connection-Flow
//
//  Created by Vishnu Mavawala on 07/05/26.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @ObservedObject var bleManager = BLEManager()
    
    var body: some View {
        VStack (spacing: 20) {
            HStack {
                TextField("Data", text: $bleManager.txt)
                Button("Sent") {
                    bleManager.sentPeripheralData()
                }
            }
            Text("BLE \(bleManager.connectedPeripheral == nil ? "Scanner" : "Connected")")
                .font(.largeTitle)
                .bold()
            
            List(bleManager.discoveredPeripherals, id: \.identifier) { peripheral in
                if peripheral.name != nil {
                    HStack {
                        Text(peripheral.name ?? "Unnamed Device")
                        Spacer()
                        Button("Connect") {
                            print("Connect button was Clicked")
                            bleManager.connect(peripheral: peripheral)
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            
            
            VStack {
                if bleManager.isSwitchedOn {
                    Text("Bluetooth is ON")
                        .foregroundColor(.green)
                } else {
                    Text("Bluetooth is OFF")
                        .foregroundColor(.red)
                }
                
                Button(action: {
                    Task {
                        await bleManager.startScanning()
                    }
                }) {
                    Text("Start Scanning")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
