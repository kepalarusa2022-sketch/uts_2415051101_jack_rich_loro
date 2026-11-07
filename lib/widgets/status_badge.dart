import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double fontSize;

  const StatusBadge({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.fontSize = 11,
  });

  factory StatusBadge.booking() {
    return const StatusBadge(
      text: 'Bisa Booking',
      backgroundColor: Color(0xFFE8F8EE),
      textColor: Color(0xFF008744),
    );
  }

  factory StatusBadge.gender(String type) {
    Color bg;
    Color fg;

    switch (type.toLowerCase()) {
      case 'putri':
        bg = const Color(0xFFFCE4EC);
        fg = const Color(0xFFC2185B);
        break;
      case 'putra':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        break;
      case 'campur':
      default:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF6A1B9A);
        break;
    }

    return StatusBadge(
      text: type,
      backgroundColor: bg,
      textColor: fg,
    );
  }

  factory StatusBadge.savedStatus(String status) {
    Color bg;
    Color fg;

    switch (status.toLowerCase()) {
      case 'booking sukses':
        bg = const Color(0xFFE8F8EE);
        fg = const Color(0xFF008744);
        break;
      case 'sudah disurvei':
        bg = const Color(0xFFE3F2FD);
        fg = const Color(0xFF1565C0);
        break;
      case 'rencana survei':
      default:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFE65100);
        break;
    }

    return StatusBadge(
      text: status,
      backgroundColor: bg,
      textColor: fg,
      fontSize: 11.5,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: textColor ?? Colors.black87,
        ),
      ),
    );
  }
}
