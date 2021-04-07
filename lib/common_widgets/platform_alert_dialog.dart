import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:map_app/common_widgets/platform_widget.dart';
import 'package:map_app/helper/constants/app_colors.dart';
import 'package:map_app/helper/ui_helpers.dart';

class APlatformAlertDialog extends PlatformWidget {
  APlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => this,
          )
        : await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return
              this;},
          );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title,style: TextStyle(color: facebookColor,fontWeight: FontWeight.bold),),
      content: Text(content,style: TextStyle(color: facebookColor,fontWeight: FontWeight.bold),),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius:
        BorderRadius.all(
            Radius.circular(10.0)),),
        title: Text(title,maxLines: 1,textScaleFactor: 1, style: TextStyle(color: facebookColor,fontSize: screenWidth(context)*.056, fontWeight: FontWeight.bold),),
        content: Builder(
            builder: (context){
              return Container(
                  height: screenHeight(context)*.097,
                  width: screenWidth(context)*.9,
                  child: Text(content,maxLines: 2,textScaleFactor: 1, style: TextStyle(color: facebookColor, fontSize: screenWidth(context)*.05, ),));
            },
        ),
        actions: _buildActions(context),
      ),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    actions.add(
      APlatformAlertDialogAction(
        child: Text(defaultActionText,maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.05,color: facebookColor,fontWeight: FontWeight.bold),),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    if (cancelActionText != null) {
      actions.add(
        APlatformAlertDialogAction(
          child: Text(cancelActionText,maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.05,color: facebookColor,fontWeight: FontWeight.bold),),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    return actions;
  }
}

class APlatformAlertDialogAction extends PlatformWidget {
  APlatformAlertDialogAction({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}


class EPlatformAlertDialog extends PlatformWidget {
  EPlatformAlertDialog({
    @required this.title,
    @required this.content,
    this.cancelActionText,
    @required this.defaultActionText,
  })  : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);

  final String title;
  final String content;
  final String cancelActionText;
  final String defaultActionText;

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => this,
    )
        : await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return
          this;},
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title,style: TextStyle(color: facebookColor,fontWeight: FontWeight.bold),),
      content: Text(content,style: TextStyle(color: facebookColor,fontWeight: FontWeight.bold),),
      actions: _buildActions(context),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius:
      BorderRadius.all(
          Radius.circular(10.0)),),
      title: Text(title,maxLines: 1,textScaleFactor: 1, style: TextStyle(color: facebookColor,fontSize: screenWidth(context)*.056, fontWeight: FontWeight.bold),),
      content: Builder(
        builder: (context){
          return Container(
              height: screenHeight(context)*.15,
              width: screenWidth(context)*.9,
              child: Text(content,maxLines: 4,overflow: TextOverflow.ellipsis, textScaleFactor: 1, style: TextStyle(color: facebookColor, fontSize: screenWidth(context)*.053, ),));
        },
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    final actions = <Widget>[];
    if (cancelActionText != null) {
      actions.add(
        EPlatformAlertDialogAction(
          child: Text(cancelActionText,maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.05,color: facebookColor,fontWeight: FontWeight.bold),),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      );
    }
    actions.add(
      EPlatformAlertDialogAction(
        child: Text(defaultActionText,maxLines: 1,textScaleFactor: 1, style: TextStyle(fontSize: screenWidth(context)*.05,color: facebookColor,fontWeight: FontWeight.bold),),
        onPressed: () => Navigator.of(context).pop(true),
      ),
    );
    return actions;
  }
}

class EPlatformAlertDialogAction extends PlatformWidget {
  EPlatformAlertDialogAction({this.child, this.onPressed});
  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(
      child: child,
      onPressed: onPressed,
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
