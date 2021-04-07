import 'package:flutter/cupertino.dart';
import 'package:map_app/common_widgets/platform_alert_dialog.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class CustomLauncher{

  void customLaunch({BuildContext context,command})async{
    try{
      await UrlLauncher.launch(command);
    }catch(e){
      //TODO Show Dialog
      APlatformAlertDialog(
        defaultActionText: "موافق",
        title: "حدث خطأ",
        content: "من فضلك حاول ثانيا",
      ).show(context);
      print("couldn't launch $command  ${e.message}");
    }
  }

}