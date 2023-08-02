import 'package:flutter/material.dart';


class CircularContainer extends StatefulWidget {
  final double radius;
  final Color color;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final String name;

  CircularContainer({
    required this.radius,
    required this.color,
    required this.onTapDown,
    required this.onTapUp,
    required this.name,
  });

  @override
  _CircularContainerState createState() => _CircularContainerState();
}

class _CircularContainerState extends State<CircularContainer> {
  late Color _currentColor;

  @override
  void initState() {
    super.initState();
  _currentColor = widget.color.withOpacity(0.5);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _currentColor = widget.color.withOpacity(1);
        });
        widget.onTapDown();
      },
      onTapUp: (_) {
        setState(() {
          _currentColor = widget.color.withOpacity(0.5);
        });
        widget.onTapUp();
      },
      onTapCancel: () {
        setState(() {
          _currentColor = widget.color.withOpacity(0.5);
        });
        widget.onTapUp();
      },
      child: Container(
        width: widget.radius * 2,
        height: widget.radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // color: _currentColor,
          gradient: RadialGradient(colors: [_currentColor, Colors.transparent])
        ),
        child: Center(child: Text(widget.name),)
      ),
    );
  }
}


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Stopwatch> _stopwatches = [];
  List<String> _buttonTimes = [];
  List<String> _log = [];


  void _startTimer(int index) {
    setState(() {
      _stopwatches[index].start();
      _log.add('Button ${index + 1} ...');
    });
  }

  void _stopTimer(int index) {
    setState(() {
      _stopwatches[index].stop();
      _buttonTimes[index] = _stopwatches[index].elapsed.inMilliseconds.toString();
      _stopwatches[index].reset();
      _log.removeLast();
      _log.add('Button ${index + 1} Time: ${_buttonTimes[index]} ms');
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      _stopwatches.add(Stopwatch());
      _buttonTimes.add('0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 3; i++)
                  CircularContainer(
          onTapDown: (){_startTimer(i);},
          onTapUp: (){_stopTimer(i);},
          
          name: ('Button ${i + 1}'), color: Colors.greenAccent, radius: 50,
        ),
                  
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    _log[index],
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            tooltip: "Clear all",
            onPressed: () {
              setState(() {
                _log.clear();
              });
            },
            child: const Icon(Icons.clear),
          ),
          const SizedBox(width: 16), 
          FloatingActionButton(
            tooltip: "Save the record",
            onPressed: () {
              // 处理第二个按钮的点击事件
            },
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
