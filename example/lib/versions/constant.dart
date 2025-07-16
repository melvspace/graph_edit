import 'package:flutter/material.dart';
import 'package:graph_edit/graph_edit.dart';

final kNodes = [
  Node(
    position: const Offset(-200, 0),
    id: 'uuid1',
    title: 'First Node',
    zIndex: 0,
    inputs: [
      NodePort(id: 'uuid6', label: 'Input', color: Colors.red),
      NodePort(id: 'uuid7', label: 'Input', color: Colors.green),
    ],
    outputs: [
      NodePort(id: 'uuid8', label: 'Output', color: Colors.blue),
      NodePort(id: 'uuid9', label: 'Output', color: Colors.yellow),
      NodePort(id: 'uuid10', label: 'Output', color: Colors.purple),
    ],
  ),
  Node(
    position: const Offset(-0, -400),
    id: 'uuid5',
    title: 'First Node',
    zIndex: 0,
    inputs: [
      NodePort(id: 'uuid6', label: 'Input', color: Colors.red),
      NodePort(id: 'uuid7', label: 'Input', color: Colors.green),
    ],
    outputs: [
      NodePort(id: 'uuid8', label: 'Output', color: Colors.blue),
      NodePort(id: 'uuid9', label: 'Output', color: Colors.yellow),
      NodePort(id: 'uuid10', label: 'Output', color: Colors.purple),
    ],
  ),
  Node(
    position: const Offset(300, 0),
    id: 'uuid2',
    title: 'Some Other Node',
    zIndex: 0,
    inputs: [
      NodePort(id: 'uuid6', label: 'Input', color: Colors.red),
      NodePort(id: 'uuid7', label: 'Input', color: Colors.green),
    ],
    outputs: [
      NodePort(id: 'uuid8', label: 'Output', color: Colors.blue),
      NodePort(id: 'uuid9', label: 'Output', color: Colors.yellow),
      NodePort(id: 'uuid10', label: 'Output', color: Colors.purple),
    ],
  ),
  Node(
    position: const Offset(400, 200),
    id: 'uuid3',
    title: 'Some Node',
    zIndex: 0,
    inputs: [
      NodePort(id: 'uuid6', label: 'Input', color: Colors.red),
      NodePort(id: 'uuid7', label: 'Input', color: Colors.green),
    ],
    outputs: [
      NodePort(id: 'uuid8', label: 'Output', color: Colors.blue),
      NodePort(id: 'uuid9', label: 'Output', color: Colors.yellow),
      NodePort(id: 'uuid10', label: 'Output', color: Colors.purple),
    ],
  ),
];
