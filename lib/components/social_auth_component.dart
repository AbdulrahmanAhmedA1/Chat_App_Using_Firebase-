import 'package:flutter/material.dart';

class SocialAuthComponent extends StatelessWidget {
  final void Function()? onTap;
  final String socialImage;
  final String socialName;

  const SocialAuthComponent({
    required this.onTap,
    required this.socialName,
    required this.socialImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage(socialImage),
            ),
            Text(socialName)
          ],
        ));
  }
}
