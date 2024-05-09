import 'package:flutter/material.dart';

class ProgressIndicatorComponent extends StatefulWidget {
  final double value;

  const ProgressIndicatorComponent({
    super.key,
    this.value = 0.0,
  });

  @override
  State<ProgressIndicatorComponent> createState() => _ProgressIndicatorComponentState();
}

class _ProgressIndicatorComponentState extends State<ProgressIndicatorComponent>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController? _animationController;
  Animation? _animation;
  double _value = 0.0;
  final _containerKey = GlobalKey();

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween(begin: 0.0, end: widget.value).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.linear),
    )..addListener(() {
        setState(() {
          _value = _animation!.value;
        });
      });

    _animationController!.forward();
    super.initState();
  }

  @override
  void didUpdateWidget(ProgressIndicatorComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (_animationController != null) {
        _animationController!.duration = const Duration(milliseconds: 500);
        _animation = Tween(begin: oldWidget.value, end: widget.value).animate(
          CurvedAnimation(parent: _animationController!, curve: Curves.linear),
        );
        _animationController!.forward(from: 0.0);
      } else {
        _updateProgress();
      }
    }
  }

  _updateProgress() {
    setState(() {
      _value = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Container(
      color: Colors.transparent,
      child: SizedBox(
        width: double.infinity,
        height: 6,
        child: CustomPaint(
          key: _containerKey,
          painter: _LinearPainter(
            progress: _value,
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _LinearPainter extends CustomPainter {
  final Paint _paintBackground = Paint();
  final Paint _paintLine = Paint();
  final double progress;

  final barRadius = const Radius.circular(12);

  _LinearPainter({
    required this.progress,
  }) {
    _paintBackground.color = Colors.white;

    _paintLine.color = progress == 0 ? Colors.red.withOpacity(0.0) : Colors.red;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path backgroundPath = Path();
    backgroundPath
        .addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), barRadius));
    canvas.drawPath(backgroundPath, _paintBackground);
    canvas.clipPath(backgroundPath);

    final xProgress = size.width * progress;
    Path linePath = Path();
    double factor = 0;
    double correction = factor * 2;

    linePath.addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(factor, factor, xProgress - correction, size.height - correction),
        barRadius));
    canvas.drawPath(linePath, _paintLine);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
