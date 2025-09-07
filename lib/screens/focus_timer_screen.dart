import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/notification_service.dart';

class FocusTimerScreen extends StatefulWidget {
  const FocusTimerScreen({super.key});

  @override
  State<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  static const List<int> _presets = [25, 30, 45, 50, 120];
  int _selectedMinutes = 25;
  Duration _remaining = const Duration(minutes: 25);
  Timer? _timer;
  bool _running = false;
  bool _onBreak = false;
  int _breakMinutes = 5;
  Duration _focusTotal = const Duration(minutes: 25);
  Duration _breakTotal = const Duration(minutes: 5);

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _running = true;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_remaining.inSeconds <= 1) {
        t.cancel();
        _onSessionComplete();
        return;
      }
      setState(() {
        _remaining = _remaining - const Duration(seconds: 1);
      });
    });
  }

  Future<void> _onSessionComplete() async {
    final isBreak = _onBreak;
    await NotificationService.instance.scheduleNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(1000000),
      title: isBreak ? 'Break finished' : 'Focus session finished',
      body:
          isBreak
              ? 'Nice rest! Ready to focus again?'
              : 'Time for a healthy break: stretch, hydrate, relax.',
      scheduledDateTime: DateTime.now().add(const Duration(seconds: 1)),
    );

    if (!isBreak) {
      // Switch to break
      setState(() {
        _onBreak = true;
        _running = false;
        _breakTotal = Duration(minutes: _breakMinutes);
        _remaining = _breakTotal;
      });
    } else {
      // Break done, reset to new focus
      setState(() {
        _onBreak = false;
        _running = false;
        _focusTotal = Duration(minutes: _selectedMinutes);
        _remaining = _focusTotal;
      });
    }
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _running = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _running = false;
      _onBreak = false;
      _focusTotal = Duration(minutes: _selectedMinutes);
      _remaining = _focusTotal;
    });
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    final h = d.inHours;
    if (h > 0) return '$h:$m:$s';
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final double totalSeconds =
        (_onBreak ? _breakTotal : _focusTotal).inSeconds.toDouble();
    final double remainingSeconds = _remaining.inSeconds.toDouble().clamp(
      0,
      totalSeconds,
    );
    final double progress =
        totalSeconds == 0 ? 0 : 1 - (remainingSeconds / totalSeconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _onBreak ? 'Break Timer' : 'Focus Timer',
          style: GoogleFonts.fredoka(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset',
            icon: const Icon(Icons.refresh),
            onPressed: _resetTimer,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors:
                _onBreak
                    ? [Colors.teal.shade50, Colors.green.shade50]
                    : [Colors.purple.shade50, Colors.blue.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              Center(
                child: Text(
                  _onBreak ? 'Time to Rest' : 'Time to Focus',
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CustomPaint(
                            painter: _ProgressRingPainter(
                              progress: progress,
                              baseColor: Colors.grey.shade200,
                              progressColor:
                                  _onBreak ? Colors.teal : Colors.deepPurple,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _format(_remaining),
                              style: GoogleFonts.fredoka(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _onBreak ? 'Break' : 'Focus',
                              style: GoogleFonts.fredoka(
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _onBreak
                    ? 'Take a healthy break: stretch, hydrate, breathe.'
                    : 'Deep focus time. You\'ve got this! 🐾',
                style: GoogleFonts.fredoka(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              if (!_onBreak) ...[
                Text(
                  'Focus length',
                  style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      _presets.map((m) {
                        final selected = _selectedMinutes == m && !_running;
                        return ChoiceChip(
                          label: Text('$m min'),
                          selected: selected,
                          selectedColor: Colors.deepPurple.shade100,
                          onSelected:
                              _running
                                  ? null
                                  : (v) {
                                    if (v) {
                                      setState(() {
                                        _selectedMinutes = m;
                                        _focusTotal = Duration(minutes: m);
                                        _remaining = _focusTotal;
                                      });
                                    }
                                  },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Break length', style: GoogleFonts.fredoka()),
                    DropdownButton<int>(
                      value: _breakMinutes,
                      items:
                          const [5, 10, 15]
                              .map(
                                (m) => DropdownMenuItem(
                                  value: m,
                                  child: Text('$m min'),
                                ),
                              )
                              .toList(),
                      onChanged:
                          _running
                              ? null
                              : (v) {
                                if (v != null) {
                                  setState(() {
                                    _breakMinutes = v;
                                    _breakTotal = Duration(minutes: v);
                                  });
                                }
                              },
                    ),
                  ],
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _onBreak ? Colors.teal : Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: Icon(_running ? Icons.pause : Icons.play_arrow),
                      label: Text(_running ? 'Pause' : 'Start'),
                      onPressed: _running ? _pauseTimer : _startTimer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: BorderSide(color: Colors.grey.shade400),
                      ),
                      icon: const Icon(Icons.stop),
                      label: const Text('Reset'),
                      onPressed: _resetTimer,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress; // 0..1
  final Color baseColor;
  final Color progressColor;

  _ProgressRingPainter({
    required this.progress,
    required this.baseColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide / 2) - 6;

    final basePaint =
        Paint()
          ..color = baseColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round;

    final progPaint =
        Paint()
          ..shader = SweepGradient(
            colors: [progressColor.withOpacity(0.2), progressColor],
            startAngle: -3.14 / 2,
            endAngle: 3 * 3.14 / 2,
          ).createShader(Rect.fromCircle(center: center, radius: radius))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 14
          ..strokeCap = StrokeCap.round;

    // Base circle
    canvas.drawCircle(center, radius, basePaint);

    // Progress arc
    final sweep = 2 * 3.141592653589793 * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = -3.141592653589793 / 2; // top
    canvas.drawArc(rect, startAngle, sweep, false, progPaint);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.baseColor != baseColor ||
        oldDelegate.progressColor != progressColor;
  }
}
