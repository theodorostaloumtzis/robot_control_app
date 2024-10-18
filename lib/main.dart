import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self-balancing Robot Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ControlPage(),
    );
  }
}

class ControlPage extends StatefulWidget {
  @override
  _ControlPageState createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  String robotName = "selfbalancingrobot.local"; // mDNS name
  String pitchAngle = "N/A";
  String pidOutput = "N/A";
  String kp = "0.0";
  String ki = "0.0";
  String kd = "0.0";
  Timer? statusTimer;

  // Function to send motor commands to the ESP32
  Future<void> sendCommand(String command) async {
    try {
      final url = Uri.http(robotName, "/command", {"command": command});
      final response = await http.get(url);
      if (response.statusCode == 200) {
        showMessage(response.body);
      } else {
        showError("Failed to send command");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  // Function to fetch pitch angle and PID output
  Future<void> fetchStatus() async {
    try {
      final url = Uri.http(robotName, "/status");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<String> status = response.body.split('\n');
        if (status.length >= 2) {
          setState(() {
            pitchAngle = status[0].split(": ")[1]; // Ensure this index exists
            pidOutput = status[1].split(": ")[1]; // Ensure this index exists
          });
        } else {
          showError("Unexpected status format");
        }
      } else {
        showError("Failed to fetch status");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  // Function to set individual PID values
  Future<void> setPidValue(String type, String value) async {
    try {
      final url = Uri.http(robotName, "/set_pid", {type: value});
      final response = await http.get(url); // Use GET for setting individual PID
      if (response.statusCode == 200) {
        showMessage("PID $type set to $value");
      } else {
        showError("Failed to set PID $type");
      }
    } catch (e) {
      showError("Error: $e");
    }
  }

  // Show message dialog
  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Show error dialog
  void showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(error, style: TextStyle(color: Colors.red)),
    ));
  }

  @override
  void initState() {
    super.initState();
    // Periodically fetch status every 2 seconds
    statusTimer = Timer.periodic(Duration(seconds: 2), (Timer t) => fetchStatus());
  }

  @override
  void dispose() {
    statusTimer?.cancel(); // Stop status timer when app is closed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Self-balancing Robot Control'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Robot Name: $robotName'),
            SizedBox(height: 20),
            // PID Controls
            buildPidControl('Kp', (value) {
              kp = value; // Update Kp value
              setPidValue("Kp", kp); // Send Kp value to the server
            }),
            SizedBox(height: 10),
            buildPidControl('Ki', (value) {
              ki = value; // Update Ki value
              setPidValue("Ki", ki); // Send Ki value to the server
            }),
            SizedBox(height: 10),
            buildPidControl('Kd', (value) {
              kd = value; // Update Kd value
              setPidValue("Kd", kd); // Send Kd value to the server
            }),
            SizedBox(height: 20),
            // Robot Movement Controls
            buildMovementControls(),
            SizedBox(height: 20),
            Text('Pitch Angle: $pitchAngle'),
            Text('PID Output: $pidOutput'),
          ],
        ),
      ),
    );
  }

  // Helper method to build PID Control UI
  Widget buildPidControl(String label, Function(String) onChanged) {
    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: label,
            ),
            keyboardType: TextInputType.number,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () => onChanged(label),
          child: Text('Set $label'),
        ),
      ],
    );
  }

  // Helper method to build movement control UI
  Widget buildMovementControls() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => sendCommand("FORWARD"),
              child: Text('Forward'),
            ),
            ElevatedButton(
              onPressed: () => sendCommand("BACKWARD"),
              child: Text('Backward'),
            ),
          ],
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => sendCommand("LEFT"),
              child: Text('Left'),
            ),
            ElevatedButton(
              onPressed: () => sendCommand("RIGHT"),
              child: Text('Right'),
            ),
          ],
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => sendCommand("STOP"),
          child: Text('Stop'),
        ),
      ],
    );
  }
}
