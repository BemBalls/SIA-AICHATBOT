import 'package:omnichat/widgets/fade_slide_up.dart';
import 'package:flutter/material.dart';

abstract class DataSubpage extends StatefulWidget {
  final Map<String, Object?> json;
  final int complete;

  const DataSubpage({super.key, required this.json, required this.complete});
}

abstract class DataSubpageState<T extends DataSubpage> extends State<T> {
  Widget loadingMessage();
  Widget notFoundMessage();
  Widget loadPage();

  @override
  Widget build(BuildContext context) {
    if (widget.complete != 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 50),
          loadingMessage(),
          CircularProgressIndicator(color: Color.fromARGB(179, 251, 112, 38)),
        ],
      );
    }

    if (widget.json.isEmpty) {
      return FadeSlideUp(
        child: Center(
          child: Padding(
            padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [SizedBox(height: 50), notFoundMessage()],
            ),
          ),
        ),
      );
    }

    return FadeSlideUp(child: loadPage());
  }
}
