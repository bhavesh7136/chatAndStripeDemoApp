
import 'package:flutter/material.dart';
import 'package:progress_loading_button/progress_loading_button.dart';

class MyButton extends StatelessWidget {
  final String title;
  final Future<dynamic> Function()? onTap;
  const MyButton({super.key,required this.onTap,required this.title});

  @override
  Widget build(BuildContext context) {
    return  LoadingButton(
        onPressed: onTap,
        type: LoadingButtonType.Elevated,
        height: 44,
        loadingWidget: const CircularProgressIndicator(
          color: Colors.white,
        ),
        defaultWidget: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .apply(bodyColor: Colors.white)
              .titleMedium,
        ));
  }
}
