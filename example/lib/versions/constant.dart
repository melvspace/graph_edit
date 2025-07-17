import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

final kNodes = [
  BasicNode(
    position: const Offset(-200, 0),
    id: 'uuid1',
    title: 'First Node',
    zIndex: 0,
    ports: [
      BasicNodePort(
        id: 'uuid6',
        isInput: true,
        label: 'Input',
        color: Colors.red,
      ),
      BasicNodePort(
        id: 'uuid7',
        isInput: true,
        label: 'Input',
        color: Colors.green,
      ),
      BasicNodePort(
        id: 'uuid8',
        isInput: false,
        label: 'Output',
        color: Colors.blue,
      ),
      BasicNodePort(
        id: 'uuid9',
        isInput: false,
        label: 'Output',
        color: Colors.yellow,
      ),
      BasicNodePort(
        id: 'uuid10',
        isInput: false,
        label: 'Output',
        color: Colors.purple,
      ),
    ],
  ),
  BasicNode(
    position: const Offset(-0, -400),
    id: 'uuid5',
    title: 'First Node',
    zIndex: 0,
    ports: [
      BasicNodePort(
        id: 'uuid6',
        isInput: true,
        label: 'Input',
        color: Colors.red,
      ),
      BasicNodePort(
        id: 'uuid7',
        isInput: true,
        label: 'Input',
        color: Colors.green,
      ),
      BasicNodePort(
        id: 'uuid8',
        isInput: false,
        label: 'Output',
        color: Colors.blue,
      ),
      BasicNodePort(
        id: 'uuid9',
        isInput: false,
        label: 'Output',
        color: Colors.yellow,
      ),
      BasicNodePort(
        id: 'uuid10',
        isInput: false,
        label: 'Output',
        color: Colors.purple,
      ),
    ],
  ),
  BasicNode(
    position: const Offset(300, 0),
    id: 'uuid2',
    title: 'Some Other Node',
    zIndex: 0,
    ports: [
      BasicNodePort(
        id: 'uuid6',
        isInput: true,
        label: 'Input',
        color: Colors.red,
      ),
      BasicNodePort(
        id: 'uuid7',
        isInput: true,
        label: 'Input',
        color: Colors.green,
      ),
      BasicNodePort(
        id: 'uuid8',
        isInput: false,
        label: 'Output',
        color: Colors.blue,
      ),
      BasicNodePort(
        id: 'uuid9',
        isInput: false,
        label: 'Output',
        color: Colors.yellow,
      ),
      BasicNodePort(
        id: 'uuid10',
        isInput: false,
        label: 'Output',
        color: Colors.purple,
      ),
    ],
  ),
  BasicNode(
    position: const Offset(400, 200),
    id: 'uuid3',
    title: 'Some Node',
    zIndex: 0,
    ports: [
      BasicNodePort(
        id: 'uuid6',
        isInput: true,
        label: 'Input',
        color: Colors.red,
      ),
      BasicNodePort(
        id: 'uuid7',
        isInput: true,
        label: 'Input',
        color: Colors.green,
      ),
      BasicNodePort(
        id: 'uuid8',
        isInput: false,
        label: 'Output',
        color: Colors.blue,
      ),
      BasicNodePort(
        id: 'uuid9',
        isInput: false,
        label: 'Output',
        color: Colors.yellow,
      ),
      BasicNodePort(
        id: 'uuid10',
        isInput: false,
        label: 'Output',
        color: Colors.purple,
      ),
    ],
  ),
];
