import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GLBPetWidget extends StatefulWidget {
  final String status;
  final VoidCallback onPet;
  final VoidCallback onFeed;
  final double size;
  final Map<String, dynamic>? petData;
  final VoidCallback? onPlay;
  final VoidCallback? onGroom;

  const GLBPetWidget({
    super.key,
    required this.status,
    required this.onPet,
    required this.onFeed,
    this.size = 200,
    this.petData,
    this.onPlay,
    this.onGroom,
  });

  @override
  GLBPetWidgetState createState() => GLBPetWidgetState();
}

class GLBPetWidgetState extends State<GLBPetWidget> {
  String _currentAnimation = "model"; // idle animation
  final String _modelPath = "assets/3d_models/pet_new.glb";

  /// Switch animation and auto-return to idle after duration
  void _setAnimation(String action) {
    debugPrint("▶️ Playing animation: $action");

    setState(() {
      _currentAnimation = action;
    });

    // Only auto-return if it's not already idle
    if (action != "model") {
      Future.delayed(_getAnimationDuration(action), () {
        if (mounted) {
          setState(() {
            _currentAnimation = "model"; // back to idle
            debugPrint("🔄 Returning to idle (model)");
          });
        }
      });
    }
  }

  /// Define durations for each animation
  Duration _getAnimationDuration(String animationName) {
    switch (animationName) {
      case 'pet':
        return const Duration(seconds: 11);
      case 'feed':
        return const Duration(seconds: 11);
      case 'play':
        return const Duration(seconds: 9);
      case 'dance': // groom
        return const Duration(seconds: 8);
      default:
        return const Duration(milliseconds: 1000);
    }
  }

  // Exposed methods for outside control (via GlobalKey)
  void triggerPet() => _setAnimation("pet");
  void triggerPlay() => _setAnimation("play");
  void triggerFeed() => _setAnimation("feed");
  void triggerGroom() => _setAnimation("dance");

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getStatusColor().withOpacity(0.3),
            blurRadius: widget.size * 0.2,
            spreadRadius: widget.size * 0.02,
          ),
        ],
      ),
      child: ClipOval(
        child: ModelViewer(
          key: ValueKey(_currentAnimation), // force refresh when anim changes
          src: _modelPath,
          alt: "3D Pet",
          autoPlay: true,
          animationName: _currentAnimation,
          ar: false,
          cameraControls: true,
          disableZoom: true,
          animationCrossfadeDuration: 500,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    int happiness = widget.petData?['happiness'] as int? ?? 80;

    if (happiness >= 90) return const Color(0xFFFFF59D);
    if (happiness >= 75) return const Color(0xFFA5D6A7);
    if (happiness >= 60) return const Color(0xFF90CAF9);
    if (happiness >= 40) return const Color(0xFFB3E5FC);
    if (happiness >= 25) return const Color(0xFFCE93D8);
    return const Color(0xFFBDBDBD);
  }
}