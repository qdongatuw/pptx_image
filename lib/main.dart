import 'package:flutter/material.dart';

List actions = [
  ['leg', Colors.green],
  ['face', Colors.blue],
  ['foot', Colors.red],
  ['hand', Colors.orange]
];



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
          gradient: RadialGradient(colors: [_currentColor, Colors.white])
        ),
        child: Center(child: Text(widget.name, style: TextStyle(color: widget.color, fontWeight: FontWeight.bold, fontSize: 16),),)
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
  List<List> _log = [];


  void _startTimer(int index) {
    setState(() {
      _stopwatches[index].start();
      _log.add(['${actions[index][0]} ...', actions[index][1]]);
    });
  }

  void _stopTimer(int index) {
    setState(() {
      _stopwatches[index].stop();
      _buttonTimes[index] = _stopwatches[index].elapsed.inMilliseconds.toString();
      _stopwatches[index].reset();
      _log.removeLast();
      _log.add(['${actions[index][0]} duration: ${_buttonTimes[index]} ms', actions[index][1]]);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < actions.length; i++) {
      _stopwatches.add(Stopwatch());
      _buttonTimes.add('0');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer App by Q. Dong'),
      ),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < actions.length; i++)
                  CircularContainer(
          onTapDown: (){_startTimer(i);},
          onTapUp: (){_stopTimer(i);},
          
          name: (actions[i][0]), color: actions[i][1], radius: 70,
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
                    _log[index][0],
                    style: TextStyle(fontSize: 14,
                    color: _log[index][1]),
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
