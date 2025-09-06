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
    Key? key,
    required this.status,
    required this.onPet,
    required this.onFeed,
    this.size = 200,
    this.petData,
    this.onPlay,
    this.onGroom,
  }) : super(key: key);

  @override
  GLBPetWidgetState createState() => GLBPetWidgetState();
}

class GLBPetWidgetState extends State<GLBPetWidget> {
  String _currentAnimation = "model";
  String _currentModel = "pet_new.glb";

  void _setAnimation(String name) {
    debugPrint("🔄 _setAnimation called with: $name");
    setState(() {
      _currentAnimation = name;
      _currentModel = _getModelForAnimation(name);
      debugPrint("🔄 Switching to animation: $name with model: $_currentModel");
    });

    // Auto-return to idle after animation
    Duration animationDuration = _getAnimationDuration(name);
    Future.delayed(animationDuration, () {
      if (mounted) {
        setState(() {
          _currentAnimation = "model"; // Return to default/idle
          _currentModel = "pet_new.glb";
          debugPrint("🔄 Returning to idle animation");
        });
      }
    });
  }

  String _getAnimationName(String action) {
    // Use the exact animation names from your GLB file
    switch (action) {
      case 'pet':
        return 'pet'; // Exact animation name from your GLB
      case 'feed':
        return 'feed'; // Exact animation name from your GLB
      case 'play':
        return 'play'; // Exact animation name from your GLB
      case 'dance': // groom
        return 'dance'; // Exact animation name from your GLB
      default:
        return 'idle';
    }
  }

  String _getModelForAnimation(String animationName) {
    // Use the main model for all animations
    return 'pet_new.glb';
  }

  Duration _getAnimationDuration(String animationName) {
    switch (animationName) {
      case 'pet':
        return const Duration(milliseconds: 1500);
      case 'feed':
        return const Duration(milliseconds: 2000);
      case 'play':
        return const Duration(milliseconds: 3000);
      case 'dance': // groom
        return const Duration(milliseconds: 2500);
      default:
        return const Duration(milliseconds: 1000);
    }
  }

  // Exposed methods for outside control (via GlobalKey)
  void triggerPet() {
    _setAnimation("pet");
    widget.onPet();
  }

  void triggerFeed() {
    _setAnimation("feed");
    widget.onFeed();
  }

  void triggerPlay() {
    _setAnimation("play");
    widget.onPlay?.call();
  }

  void triggerGroom() {
    _setAnimation("dance");
    widget.onGroom?.call();
  }

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
          //key: ValueKey(_currentAnimation), // force refresh animation
          src: 'assets/3d_models/pet_new.glb',
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
