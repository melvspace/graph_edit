# graph_edit

A Flutter package for creating interactive node-based graph editors with infinite canvas and connection management.

![Screenshot of graph_edit](https://github.com/melvspace/graph_edit/blob/main/docs/assets/screenshot.png?raw=true)

## Installation

```yaml
dependencies:
  graph_edit: ^0.1.0
```

## Basic Usage

```dart
import 'package:graph_edit/graph_edit.dart';

GraphCanvas(
  nodes: nodes,
  selected: selectedNodeId,
  onNodeDragged: (id, position, zIndex) => updateNode(id, position, zIndex),
  connections: connections,
  nodeBuilder: (node, isSelected) => buildNodeWidget(node, isSelected),
)
```

## Core Classes

### Node

Represents a graph node with inputs and outputs.

```dart
Node(
  id: 'node_id',
  position: Offset(x, y),
  title: 'Node Title',
  inputs: [NodePort(id: 'in1', label: 'Input')],
  outputs: [NodePort(id: 'out1', label: 'Output')],
  zIndex: 0,
)
```

### NodePort
Defines connection points on nodes.

```dart
NodePort(
  id: 'port_id',
  label: 'Port Label',
  color: Colors.blue, // optional
)
```

### Connection
Represents a connection between two ports.

```dart
Connection(
  outputId: 'source_port_id',
  inputId: 'target_port_id',
)
```

## Components

- **GraphCanvas**: Main widget for rendering the interactive graph with infinite canvas
- **GraphNodeWidget**: Default node visualization widget. You can write your own widget to override the default behavior.
- **Custom Node Widgets**: Create your own node layouts with automatic port detection
- **Custom Port Widgets**: Design custom port appearance and behavior

## Features

- Interactive node editing with infinite canvas
- Visual connections between node ports
- Custom Node and Port widgets with automatic layout detection
- Automatic connection curve positioning and routing
- Z-index management for node layering
