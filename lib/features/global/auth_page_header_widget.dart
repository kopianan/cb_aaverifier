import 'package:coinbit_ui_mobile/coinbit_ui_mobile.dart';
import 'package:flutter/material.dart';

class AuthPageHeaderWidget extends StatelessWidget {
  const AuthPageHeaderWidget(
      {Key? key, this.icon, required this.title, this.tag, this.image})
      : super(key: key);
  final IconData? icon;
  final String title;
  final String? tag;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        (image == null)
            ? const SizedBox()
            : Image.asset(image!, width: 120, height: 120, fit: BoxFit.cover),
        (icon == null)
            ? const SizedBox()
            : CircleAvatar(
                radius: 36,
                backgroundColor: const Color(0xffF3F3FF),
                child: Icon(
                  icon,
                  color: CBColors.primaryLight,
                  size: 40,
                ),
              ),
        const SizedBox(height: 16),
        (icon == null) ? const SizedBox() : const SizedBox(height: 16),
        Text(
          title,
          textAlign: TextAlign.center,
          style: CBText.boldHeading24px,
        ),
        const SizedBox(height: 16),
        (tag == null)
            ? const SizedBox()
            : Text(
                tag!,
                textAlign: TextAlign.center,
                style:
                    CBText.regulerBody14px.copyWith(color: CBColors.iconLight),
              ),
      ],
    );
  }
}
