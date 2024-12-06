// ignore_for_file: unused_field

import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:frontend_trend/core/utils/media_picker_utils.dart';
import 'package:frontend_trend/features/posts/presentation/widgets/camera_page/timer_widget.dart';
import '../../../../../core/resources/values_manager.dart';
import '../../../../../core/widgets/loading_widget.dart';
import '../../../data/models/post_media_type_enum.dart';

class CameraImageVideoWidget extends StatefulWidget {
  final Function(Map) onTaken;
  final bool isSingle;
  final bool isVlog;
  final bool allowRecording;
  final String initialCameraType;

  const CameraImageVideoWidget({
    super.key,
    required this.onTaken,
    required this.isVlog,
    this.isSingle = false,
    required this.initialCameraType,
    this.allowRecording = true,
  });

  @override
  State<CameraImageVideoWidget> createState() => _CameraImageVideoWidgetState();
}

class _CameraImageVideoWidgetState extends State<CameraImageVideoWidget> {
  List<CameraDescription>? cameras;
  late CameraController _cameraController;
  Future<void>? _cameraValue;
  bool _isLoading = false;
  int direction = 0;
  bool isFlashOn = false;
  bool isCameraFront = true;
  bool isRecording = false;
  Timer? _timer;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentZoomLevel = 1.0;
  String cameraType = "Photo";

  @override
  void initState() {
    cameraType = widget.initialCameraType;
    super.initState();
    _initializeCamera(direction);
  }

  Future<void> _initializeCamera(int direction) async {
    cameras = await availableCameras();
    _cameraController =
        CameraController(cameras![direction], ResolutionPreset.veryHigh);

    _cameraValue = _cameraController.initialize().then((_) {
      setState(() {
        _cameraController.setFlashMode(FlashMode.off);
        _initializeCameraSettings();
      });
    }).catchError((error) {
      // Handle errors
    });
  }

  void _initializeCameraSettings() {
    _cameraController.setExposureMode(ExposureMode.auto);
    _cameraController.setFocusMode(FocusMode.auto);
    _cameraController.getMaxZoomLevel().then((value) {
      _maxAvailableZoom = value;
    });
    _cameraController.getMinZoomLevel().then((value) {
      _minAvailableZoom = value;
    });
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  // _buildCamera(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.sp, vertical: 25.sp),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildZoom(),
                          _currentMediaText(),
                          SizedBox(height: 8.sp),
                          _buildControlButtons(),
                        ],
                      ),
                    ),
                  ),
                  _buildFlashToggle(),
                  if (_isLoading) _buildLoading(),
                  if (isRecording) _buildRecordingTimer()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _galleryPicker(),
        GestureDetector(
          onTap: () async {
            if (!isRecording && widget.isVlog) {
              await _startRecording();
            } else if (isRecording && widget.isVlog) {
              await _stopRecording();
            } else {
              if (!isRecording) _takePhoto();
            }
          },
          onLongPress: !widget.allowRecording
              ? null
              : () async {
                  if (widget.isVlog) {
                    await _startRecording();
                  }
                },
          onLongPressUp: !widget.allowRecording
              ? null
              : () async {
                  if (widget.isVlog) {
                    await _stopRecording();
                  }
                },
          child: _cameraIcon(),
        ),
        _toggleCamera(),
      ],
    );
  }

  Future<void> _startRecording() async {
    try {
      await _cameraController.startVideoRecording();
      setState(() {
        isRecording = true;
        cameraType = "Video";
      });
      _timer =
          Timer(const Duration(seconds: AppConstants.videoLength), () async {
        if (isRecording) {
          await _stopRecording();
        }
      });
    } catch (e) {
      // Handle errors
    }
  }

  Future<void> _stopRecording() async {
    setState(() {
      _isLoading = true;
    });
    try {
      XFile tempVideoPath = await _cameraController.stopVideoRecording();

      final directory = await getTemporaryDirectory();
      final newPath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

      final File tempFile = File(tempVideoPath.path);
      final File newFile = tempFile.renameSync(newPath);

      setState(() {
        isRecording = false;
        _isLoading = false;
        cameraType = "Photo";
      });

      if (!mounted) return;
      widget.onTaken({
        "files": [newFile],
        "type": PostMediaType.video
      });
    } catch (e) {
      // Handle errors
      setState(() {
        isRecording = false;
        _isLoading = false;
        cameraType = "Photo";
      });
    }
  }

  GestureDetector _toggleCamera() {
    return GestureDetector(
      onTap: _toggleCameraFront,
      child: CircleAvatar(
        radius: 30.sp,
        backgroundColor: Colors.white12,
        child: Icon(
          Icons.flip_camera_ios,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
    );
  }

  void _toggleCameraFront() {
    setState(() {
      isCameraFront = !isCameraFront;
      direction = isCameraFront ? 0 : 1;
      _initializeCamera(direction);
    });
  }

  GestureDetector _galleryPicker() {
    return GestureDetector(
      onTap: () {
        if (widget.isSingle) {
          if (widget.isVlog) {
            _getOneVideoFromGallery();
          } else {
            _getOneImageFromGallery();
          }
        } else {
          _getImageFromGallery();
        }
      },
      child: CircleAvatar(
        radius: 30.sp,
        backgroundColor: Colors.white12,
        child: Icon(
          Icons.photo,
          color: Colors.white,
          size: 30.sp,
        ),
      ),
    );
  }

  Center _currentMediaText() {
    return Center(
      child: Text(
        cameraType,
        style: TextStyle(
            fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Row _buildZoom() {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: _currentZoomLevel,
            min: _minAvailableZoom,
            max: _maxAvailableZoom,
            activeColor: Colors.white,
            inactiveColor: Colors.white30,
            onChanged: (value) async {
              setState(() {
                _currentZoomLevel = value;
              });
              await _cameraController.setZoomLevel(value);
            },
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(5.sp),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 3.sp, horizontal: 8.sp),
            child: Text(
              '${_currentZoomLevel.toStringAsFixed(1)}x',
              style: TextStyle(color: Colors.white, fontSize: 12.5.sp),
            ),
          ),
        ),
      ],
    );
  }

  Align _buildFlashToggle() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding:
            EdgeInsetsDirectional.only(start: 10.sp, end: 10.sp, top: 12.sp),
        child: GestureDetector(
          onTap: _toggleFlash,
          child: CircleAvatar(
            radius: 20.sp,
            backgroundColor: Colors.white12,
            child: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    isFlashOn
        ? _cameraController.setFlashMode(FlashMode.torch)
        : _cameraController.setFlashMode(FlashMode.off);
  }

  Positioned _buildLoading() {
    return Positioned(
      bottom: 0,
      top: 0,
      right: 50.sp,
      left: 50.sp,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.sp),
        ),
        child: Container(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              LoadingWidget(
                height: 50.sp,
              )
            ],
          ),
        ),
      ),
    );
  }

  Align _buildRecordingTimer() {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(top: 16.sp),
        child: const TimerWidget(
          duration: Duration(seconds: AppConstants.videoLength),
        ),
      ),
    );
  }

  FutureBuilder<void> _buildCamera() {
    return FutureBuilder(
      future: _cameraValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return GestureDetector(
            child: SizedBox(
              width: _cameraController.value.previewSize!.height,
              height: _cameraController.value.previewSize!.width,
              child: CameraPreview(_cameraController),
            ),
          );
        } else {
          return const LoadingWidget();
        }
      },
    );
  }

  Icon _cameraIcon() {
    return Icon(
      isRecording ? Icons.radio_button_on : Icons.panorama_fish_eye,
      color: isRecording ? Colors.red : Colors.white,
      size: 80.sp,
    );
  }

  Future<void> _takePhoto() async {
    setState(() {
      _isLoading = true;
    });
    try {
      XFile file = await _cameraController.takePicture();
      if (!mounted) return;
      widget.onTaken({
        "files": [File(file.path)],
        "type": PostMediaType.image
      });
    } catch (e) {
      // Handle errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    List<XFile>? pickedFiles =
        await MediaPickerUtils().pickMultiImages(context);
    if (pickedFiles != null) {
      widget.onTaken({
        "files": pickedFiles.map((xfile) => File(xfile.path)).toList(),
        "type": PostMediaType.image
      });
    }
  }

  Future<void> _getOneVideoFromGallery() async {
    final pickedFile = await MediaPickerUtils().pickVideo(context);
    if (pickedFile != null) {
      widget.onTaken({
        "files": [File(pickedFile.path)],
        "type": PostMediaType.video
      });
    }
  }

  Future<void> _getOneImageFromGallery() async {
    final pickedFile = await MediaPickerUtils().pickImage(context);
    if (pickedFile != null) {
      widget.onTaken({
        "files": [File(pickedFile.path)],
        "type": PostMediaType.image
      });
    }
  }
}
