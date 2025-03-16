import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  final String lastError;
  const CustomErrorWidget({
    super.key,
    required this.lastError,
  });

  @override
  Widget build(BuildContext context) {
    return lastError.isNotEmpty
        ? Column(
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: SelectableText(lastError,
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          )
        : const SizedBox();
  }
}
