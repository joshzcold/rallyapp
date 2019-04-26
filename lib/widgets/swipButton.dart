import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class SwipeButton extends StatefulWidget {
  const SwipeButton({
    @required this.leftContent,
    @required this.rightContent,
    this.height = 52.0,
  });

  final leftContent;
  final rightContent;
  final double height;

  @override
  SwipeButtonState createState() => SwipeButtonState();
}

class SwipeButtonState extends State<SwipeButton>{


  PageController _controller;


  @override
  void initState() {
    super.initState();
    _controller = PageController( initialPage: 0);

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints){
        return InkWell(
          onTap: (){
            _controller.page == 0?
                _controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.easeOut):
                _controller.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.easeOut);
          },
          child: Container(
              height: widget.height,
              child: PageView(
                controller: _controller,
                children: <Widget>[
                  widget.leftContent,
                  widget.rightContent
                ],
              )
          )
        );
      },
    );
  }
}
