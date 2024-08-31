import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/utils/constants.dart';
import 'package:mqtt_test/view%20model/home_view_model.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'MQTT Publisher',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TopicTextField(),
            kHeight10,
            MessageTextField(),
            kHeight10,
            QoSSelector(),
            kHeight20,
            PublishButton(),
            kHeight10,
            ConnectButton(),
          ],
        ),
      ),
    );
  }
}

class TopicTextField extends StatelessWidget {
  const TopicTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return TextField(
      controller: homeViewModel.topicController,
      decoration: const InputDecoration(
        labelText: 'Topic',
        border: OutlineInputBorder(
          borderSide: BorderSide(),
        ),
      ),
    );
  }
}

class MessageTextField extends StatelessWidget {
  const MessageTextField({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return TextField(
      controller: homeViewModel.messageController,
      decoration: const InputDecoration(
        labelText: 'Message',
        border: OutlineInputBorder(),
      ),
    );
  }
}

class QoSSelector extends StatelessWidget {
  const QoSSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return Row(
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
    );
  }
}

class PublishButton extends StatelessWidget {
  const PublishButton({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (homeViewModel.topicController.text.isEmpty ||
              homeViewModel.messageController.text.isEmpty) {
            _showSnackBar(
                context, 'Both Topic and Message fields must be filled!');
          } else {
            homeViewModel.publishMessageToTopic(
              topic: homeViewModel.topicController.text,
              message: homeViewModel.messageController.text,
              qosLevel: int.parse(homeViewModel.selectedQoSLevel),
            );
            homeViewModel.clearInputFields();
            _showSnackBar(context, 'Message published successfully!');
          }
        },
        child: const Text('Publish'),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

class ConnectButton extends StatelessWidget {
  const ConnectButton({super.key});

  @override
  Widget build(BuildContext context) {
    final homeViewModel = Provider.of<HomeViewModel>(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          try {
            await homeViewModel.connectToBroker();
            if (!context.mounted) return;
            final connectionMessage =
                homeViewModel.connectionStatus == MqttConnectionState.connected
                    ? 'Connected to Broker'
                    : 'Failed to Connect to Broker';
            _showSnackBar(context, connectionMessage);
          } catch (e) {
            if (!context.mounted) return;
            _showSnackBar(context,
                'No internet connection. Please check your network settings.');
          }
        },
        child: const Text('Connect to Broker'),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
