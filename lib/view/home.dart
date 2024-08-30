
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/view%20model/home_view_model.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('MQTT Publisher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: homeViewModel.topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: homeViewModel.messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('QoS Level'),
                DropdownButton<String>(
                  value: homeViewModel.selectedQoSLevel,
                  items: const [
                    DropdownMenuItem(value: '0', child: Text('0')),
                    DropdownMenuItem(value: '1', child: Text('1')),
                    DropdownMenuItem(value: '2', child: Text('2')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      homeViewModel.updateSelectedQoSLevel(value);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (homeViewModel.topicController.text.isEmpty ||
                    homeViewModel.messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Both Topic and Message fields must be filled!'),
                    ),
                  );
                } else {
                  homeViewModel.publishMessageToTopic(
                    topic: homeViewModel.topicController.text,
                    message: homeViewModel.messageController.text,
                    qosLevel: int.parse(homeViewModel.selectedQoSLevel),
                  );
                  homeViewModel.clearInputFields();
                }
              },
              child: const Text('Publish'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await homeViewModel.connectToBroker();
                final connectionMessage = homeViewModel.connectionStatus == MqttConnectionState.connected
                    ? 'Connected to Broker'
                    : 'Failed to Connect to Broker';
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(connectionMessage),
                  ),
                );
              },
              child: const Text('Connect to Broker'),
            ),
            const SizedBox(height: 24),
            Text(
              homeViewModel.connectionStatus == MqttConnectionState.connected
                  ? 'Status: Connected to Broker'
                  : 'Status: Not Connected',
              style: TextStyle(
                color: homeViewModel.connectionStatus == MqttConnectionState.connected
                    ? Colors.green
                    : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
