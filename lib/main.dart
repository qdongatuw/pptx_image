import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:io';

List<Color> colors = [Colors.green, Colors.blue, Colors.red, Colors.orange, Colors.purple, Colors.indigo];

List<String> actions = ['Paw Licking','Nose/Face Washing', 'Body Grooming','Leg Licking', 'Tail/Genitals Grooming', 'Other'];

class CircularContainer extends StatefulWidget {
  final double radius;
  final Color color;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final String name;

  const CircularContainer({super.key, 
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
        width: widget.radius * 4,
        height: widget.radius,
        decoration: BoxDecoration(
          // shape: BoxShape.circle,
          // color: _currentColor,
          borderRadius: BorderRadius.circular(50),
          gradient: LinearGradient(colors: [_currentColor, Colors.white, _currentColor])
        ),
        child: Center(
          
          child: Text(widget.name, 
          style: GoogleFonts.lato(textStyle: TextStyle(color: widget.color, fontWeight: FontWeight.bold, fontSize: 16)) , 
          textAlign: TextAlign.center,),
          )
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
      theme: ThemeData.dark(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Stopwatch> _stopwatches = [];
  List<int> _buttonTimes = [];
  List<int> _buttonTotalTimes = [];
  List<List> _log = [];


  void _startTimer(int index) {
    setState(() {
      _stopwatches[index].start();
      _log.add([index, 0]);
    });
  }

  void _stopTimer(int index) {
    setState(() {
      _stopwatches[index].stop();
      _buttonTimes[index] = _stopwatches[index].elapsed.inMilliseconds;
      _buttonTotalTimes[index] += _buttonTimes[index];
      _stopwatches[index].reset();
      _log.removeLast();
      _log.add([index, _buttonTimes[index]]);
    });
  }

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < actions.length; i++) {
      _stopwatches.add(Stopwatch());
      _buttonTimes.add(0);
      _buttonTotalTimes.add(0);
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
          
          name: (actions[i]), color: colors[i], radius: 50,
        ),
                  
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _log.length,
              itemBuilder: (context, index) {
                final int reversedIndex = _log.length - 1 - index;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    
                    tileColor: colors[_log[reversedIndex][0]].withOpacity(0.5),
                    titleTextStyle: const TextStyle(fontSize: 14),
                    title: Text(actions[_log[reversedIndex][0]]).animate().fadeIn(), 
                    subtitle: Text(_log[reversedIndex][1] == 0? '.........': '${_log[reversedIndex][1]} ms').animate().shake() ,
                    )
                  //  Text(
                  //   _log[index][1] == 0? '${_log[index]][0]} ...': '${_log[index][0]} duration: ${_log[index][1]} ms',
                  //   style: TextStyle(fontSize: 14,
                  //   color: _log[index][1]),
                  // ),
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
                for (int i=0; i<_buttonTotalTimes.length; i++){
                    _buttonTotalTimes[i] = 0;
                }
              });
            },
            child: const Icon(Icons.clear),
          ),
          const SizedBox(width: 16), 
          FloatingActionButton(
            tooltip: "Save the record",
            onPressed: () async{
              String csvData = const ListToCsvConverter().convert(_log);
          File file = File('image_paths.csv');
          await file.writeAsString(csvData);
    //print('CSV file saved.');
            },
            child: const Icon(Icons.download),
          ),
        ],
      ),
    );
  }
}
