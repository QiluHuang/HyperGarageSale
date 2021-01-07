import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hypergaragesale/screens/picture_preview_screen.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class CameraScreen extends StatefulWidget {
  static String id = 'camera_screen';
  final CameraDescription camera;

  const CameraScreen({Key key, this.camera}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take a Picture'),
        backgroundColor: Colors.black12,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            tooltip: 'Back',
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        /// 底部导航栏打出一个圆形的洞，BottomAppBar的shape属性决定洞的外形，CircularNotchedRectangle实现了一个圆形的外形
        shape: CircularNotchedRectangle(),
        color: Colors.black12,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink[200],
        child: Icon(
          Icons.camera,
        ),
        onPressed: () async {
          try {
            await _initializeControllerFuture;

            /// 图片的临时地址
            final path = join(
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );

            print(path);
            await _controller.takePicture(path);
            final res = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PicturePreviewScreen(imagePath: path),
              ),
            );
            print(res);
            Navigator.pop(context, res);
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
