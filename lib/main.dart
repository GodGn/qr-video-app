import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Video App Web',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: Color(0xFFFFF0F5),
      ),
      home: SimulateUnlockPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SimulateUnlockPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    VideoPage(videoAsset: 'web/assets/videos/m_01.mp4'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          child: Text('模擬解鎖並播放影片', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}

class VideoPage extends StatefulWidget {
  final String videoAsset;
  VideoPage({required this.videoAsset});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  String _pressed = "";
  late VideoPlayerController _controller;
  bool showButtons = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoAsset)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.addListener(() {
          if (_controller.value.position >= _controller.value.duration &&
              !showButtons) {
            setState(() {
              showButtons = true;
            });
          }
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _cuteButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = text),
      onTapUp: (_) => setState(() => _pressed = ""),
      onTapCancel: () => setState(() => _pressed = ""),
      child: AnimatedScale(
        scale: _pressed == text ? 0.95 : 1.0,
        duration: Duration(milliseconds: 100),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pinkAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            elevation: 5,
          ),
          child: Text(text == "播放 m_02" ? "Yes" : "NO",
              style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _navigateTo(String asset) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VideoPage(videoAsset: asset)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('影片播放', style: TextStyle(fontWeight: FontWeight.bold))),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text("已解鎖影片",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.pink)),
          SizedBox(height: 10),
          if (_controller.value.isInitialized)
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: VideoPlayer(_controller),
              ),
            ),
          SizedBox(height: 20),
          if (showButtons)
            Column(
              children: [
                Text("請選擇下一部影片",
                    style: TextStyle(fontSize: 16, color: Colors.pink[400])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _cuteButton("播放 m_02",
                        () => _navigateTo("web/assets/videos/m_02.mp4")),
                    _cuteButton("播放 m_03",
                        () => _navigateTo("web/assets/videos/m_03.mp4")),
                  ],
                ),
              ],
            )
        ],
      ),
    );
  }
}