import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class MQTTService {
  final String brokerUri = 'broker.mqtt.cool';
  final String clientId = const Uuid().v4();
  final int port = 1883;

  MqttServerClient? mqttClient;

  Future<void> connectToBroker() async {
    mqttClient = MqttServerClient(brokerUri, clientId)
      ..logging(on: true)
      ..port = port
      ..onDisconnected = handleDisconnection
      ..onConnected = handleConnection;

    final connectionMessage = MqttConnectMessage()
        .withClientIdentifier(clientId)
        .startClean()
        .withWillQos(MqttQos.atMostOnce);

    mqttClient!.connectionMessage = connectionMessage;

    try {
      await mqttClient!.connect();
    } catch (e) {
      log('Connection Exception: $e');
      disconnectFromBroker();
    }
  }

  void handleConnection() {
    debugPrint('Connected to MQTT Broker');
  }

  void handleDisconnection() {
    debugPrint('Disconnected from MQTT Broker');
  }

  void disconnectFromBroker() {
    mqttClient?.disconnect();
  }

  Future<void> publishMessage(String topic, String message, int qosLevel) async {
    await connectToBroker();
    log('Publishing message "$message" to topic "$topic" with QoS $qosLevel');
    final payloadBuilder = MqttClientPayloadBuilder();
    payloadBuilder.addString(message);
    mqttClient!.publishMessage(topic, MqttQos.values[qosLevel], payloadBuilder.payload!);
  }
}
