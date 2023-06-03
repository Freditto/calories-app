import 'package:flutter/material.dart';

class ReusableContainer extends StatelessWidget {
  const ReusableContainer({super.key, @required this.colour, this.cardChild, this.onPressed});
  final Color? colour;
  final Widget? cardChild;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colour,
          borderRadius: BorderRadius.circular(10),
        ),
        child: cardChild,
      ),
    );
  }
}
