
import "package:flutter/material.dart";

class ProgressWidget extends StatelessWidget {
  final Widget? child;
  final bool? isShow;
  final double? opacity;
  final Color? color;
  final Animation<Color>? valueColor;

  const ProgressWidget({
    super.key,
    @required this.child,
    @required this.isShow,
    this.opacity = 0.3,
    this.color = Colors.grey,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [];
    widgetList.add(child!);
    if (isShow!) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity!,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          const Center(
            child: CircularProgressIndicator(),
          ),
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}

// class Error extends StatelessWidget {
//   final String? errorMessage;
//
//   final Function onRetryPressed;
//
//   const Error({Key? key, this.errorMessage, required this.onRetryPressed})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Text(
//             errorMessage!,
//             textAlign: TextAlign.center,
//             style:const TextStyle(
//               color: Colors.black,
//               fontSize: 18,
//             ),
//           ),
//           const SizedBox(height: 18),
//           SizedBox(
//             width: 120,
//             child: ElevatedButton(
//               child:  Text(Languages.of(context)!.retryText, style: const TextStyle(color: Colors.black)),
//               onPressed: onRetryPressed(),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }

