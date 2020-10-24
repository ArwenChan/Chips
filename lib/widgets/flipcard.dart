import 'dart:math';

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class WidgetFlipper extends StatefulWidget {
  WidgetFlipper({
    Key key,
    this.frontWidget,
    this.backWidget,
    this.roller,
    this.whenTap,
  }) : super(key: key);

  final Widget frontWidget;
  final Widget backWidget;
  final ScrollController roller;
  final VoidCallback whenTap;

  @override
  _WidgetFlipperState createState() => _WidgetFlipperState();
}

class _WidgetFlipperState extends State<WidgetFlipper>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> _frontRotation;
  Animation<double> _backRotation;
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _frontRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: pi / 2)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _backRotation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(controller);
    _frontRotation.addStatusListener(_rollBack);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        AnimatedCard(
          animation: _backRotation,
          child: widget.backWidget,
        ),
        AnimatedCard(
          animation: _frontRotation,
          child: widget.frontWidget,
        ),
        GestureDetector(
          onTap: () {
            _toggleSide();
            if (!isFrontVisible) {
              widget.whenTap();
            }
          },
          child: Container(color: Colors.transparent),
        ),
      ],
    );
  }

  void _toggleSide() {
    if (isFrontVisible) {
      controller.forward();
      isFrontVisible = false;
    } else {
      controller.reverse();
      isFrontVisible = true;
    }
  }

  void _rollBack(status) async {
    if (status == AnimationStatus.completed) {
      final double extent = widget.roller.position.maxScrollExtent;
      await widget.roller.animateTo(
        extent,
        duration: Duration(milliseconds: (extent * 15).floor()),
        curve: Curves.easeIn,
      );
      Future.delayed(Duration(seconds: 1), () {
        controller.reverse();
        isFrontVisible = true;
      });
      Future.delayed(Duration(milliseconds: 1500), () {
        widget.roller.animateTo(0,
            duration: Duration(milliseconds: 10), curve: Curves.linear);
      });
    }
  }
}

class AnimatedCard extends StatelessWidget {
  AnimatedCard({
    this.child,
    this.animation,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget child) {
        var transform = Matrix4.identity();
        // transform.setEntry(3, 2, 0.001);
        transform.rotateX(animation.value);
        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: child,
    );
  }
}
