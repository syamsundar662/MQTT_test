import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/utils/constants.dart';
import 'package:mqtt_test/view%20model/home_view_model.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MQTT Publisher',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: homeViewModel.topicController,
              decoration: const InputDecoration(
                labelText: 'Topic',
                border: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
            ),
            kHeight10,
            TextField(
              controller: homeViewModel.messageController,
              decoration: const InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
            ),
            kHeight10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'QoS Level',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
            kHeight20,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
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

                    // Display the SnackBar after publishing
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message published successfully!'),
                      ),
                    );
                  }
                },
                child: const Text('Publish'),
              ),
            ),
            kHeight10,
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    await homeViewModel.connectToBroker();
                    final connectionMessage = homeViewModel.connectionStatus == MqttConnectionState.connected
                        ? 'Connected to Broker'
                        : 'Failed to Connect to Broker';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(connectionMessage),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No internet connection. Please check your network settings.'),
                      ),
                    );
                  }
                },
                child: const Text('Connect to Broker'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
