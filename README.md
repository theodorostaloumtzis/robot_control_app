# Robot Control App for Self-Balancing Robot

This repository contains a Flutter application designed to control a self-balancing robot via WiFi. The app allows users to send movement commands, adjust PID parameters, and receive real-time feedback such as pitch angle and PID output from the robot. The robot is controlled by an ESP32 microcontroller running code from the [SelfBalancingRobot](https://github.com/theodorostaloumtzis/SelfBalancingRobot) repository.

## Features

- **Movement Control**: Control the robot's movement by sending commands like forward, backward, left, right, and stop.
- **Dynamic PID Adjustment**: Adjust the PID controller's `Kp`, `Ki`, and `Kd` values from the app to fine-tune the robot’s balancing performance.
- **Real-Time Feedback**: Fetch and display real-time data from the robot, including the current pitch angle and PID output.
- **IP Configuration**: Enter and set the robot’s IP address directly from the app for seamless connectivity.

## Getting Started

### Prerequisites

- **Flutter SDK**: Install the Flutter SDK from [here](https://flutter.dev/docs/get-started/install).
- **ESP32 with the Self-Balancing Code**: Ensure your robot’s ESP32 is flashed with the firmware from the [SelfBalancingRobot](https://github.com/theodorostaloumtzis/SelfBalancingRobot) repository and is connected to the same network as your mobile device.

### Running the App

1. Clone the repository:
   ```bash
   git clone https://github.com/theodorostaloumtzis/robot_control_app.git
   cd robot_control_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Connect your device or run an emulator.

4. Run the app:
   ```bash
   flutter run
   ```

### Using the App

1. **Set the Robot’s IP Address**:
   - In the app, enter the robot's IP address (e.g., `192.168.0.100`), then press the "Set IP" button to configure the connection.
   
2. **Control the Robot**:
   - Use the provided buttons in the app to move the robot forward, backward, left, right, or stop.
   
3. **Adjust PID Parameters**:
   - Adjust the `Kp`, `Ki`, and `Kd` values from the PID control section of the app and send the updated values to the robot.

4. **View Status**:
   - The app will periodically fetch and display the current pitch angle and PID output from the robot every 2 seconds.

## Screenshots

[Add screenshots here to demonstrate the UI of the app]

## Related Repositories

- **ESP32 Robot Firmware**: The firmware running on the ESP32 that communicates with this app can be found at [SelfBalancingRobot](https://github.com/theodorostaloumtzis/SelfBalancingRobot).

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

- **Theodoros Taloumtzis** - [GitHub](https://github.com/theodorostaloumtzis)
