
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_test/services/mqtt_services.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required this.mqttService});
  final MQTTService mqttService;

  String selectedQoSLevel = '0';
  MqttConnectionState connectionStatus = MqttConnectionState.disconnected;

  final TextEditingController topicController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  Future<void> connectToBroker() async {
    await mqttService.connectToBroker();
    connectionStatus = mqttService.mqttClient?.connectionStatus?.state ?? MqttConnectionState.disconnected;
    notifyListeners();
  }

  void publishMessageToTopic({
    required String topic,
    required String message,
    required int qosLevel,
  }) {
    mqttService.publishMessage(topic, message, qosLevel);
  }

  void updateSelectedQoSLevel(String qos) {
    selectedQoSLevel = qos;
    notifyListeners();
  }

  void clearInputFields() {
    topicController.clear();
    messageController.clear();
  }
}
