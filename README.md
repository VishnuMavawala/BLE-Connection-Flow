# BLE-Connection-Flow

BLE-Connection-Flow is a SwiftUI-based iOS project demonstrating a complete **Bluetooth Low Energy (BLE) connection flow**, including scanning, connecting, and interacting with peripheral devices. It supports **reading**, **writing (with or without response)**, and **observing characteristic notifications**. The app is built for iOS devices and provides a clean example of BLE communication in SwiftUI.

## Features

Scan for nearby BLE peripheral devices, connect to a selected device, and perform BLE operations on characteristics including **read**, **write without response**, **write with response**, and **notify/observe**. The app handles connection and disconnection events and provides a user-friendly SwiftUI interface.

## Requirements

iOS 15.0 or later, Xcode 14 or later, Swift 5+, and a **physical iOS device** (BLE functionality is limited on the simulator).

## Installation and Usage

Clone the repository using:

```
git clone https://github.com/VishnuMavawala/BLE-Connection-Flow.git
```

Navigate to the project folder and open `BLE-Connection-Flow.xcodeproj` in Xcode. Build and run the project on a physical iOS device. When the app launches, grant Bluetooth (and location, if prompted) permissions. The app will automatically scan for nearby BLE peripheral devices. Select a peripheral to connect, then interact with its characteristics by reading data, writing with or without response, and observing notifications for real-time updates.

## Project Structure

* **Views/** – SwiftUI views for scanning, connecting, and interacting with peripherals.
* **Models/** – Data models representing BLE devices and characteristics.
* **Managers/** – Core Bluetooth manager handling scanning, connecting, reading, writing, and notifications.
* **Resources/** – Assets and supporting files.

## LightBlue Application Flow (Virtual GATT Server)

To simulate a BLE peripheral for testing, you can use the **LightBlue** application to create a virtual GATT server. This is helpful to test your BLE-Connection-Flow app without a physical peripheral device.

**Steps to create a virtual GATT server in LightBlue:**

1. Download and install the LightBlue app on your iOS device.
2. Open LightBlue and tap **Peripheral** to start a virtual peripheral server.
3. Tap **+ Add Service** to create a custom service. Assign a UUID for your service.
4. Inside the service, tap **+ Add Characteristic** to create a characteristic. Set its UUID, properties (Read, Write, Notify), and permissions.
5. Start advertising your virtual peripheral. It will appear as a BLE device that can be scanned and connected to by your BLE-Connection-Flow app.
6. Use your app to connect to the virtual peripheral and test reading, writing, and notifications.

Using this flow, you can simulate BLE devices and characteristics without needing hardware peripherals, which is perfect for development and debugging.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
