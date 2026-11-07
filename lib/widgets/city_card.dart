import 'package:flutter/material.dart';

class CityCard extends StatelessWidget {
  final String cityName;
  final IconData landmarkIcon;
  final VoidCallback? onTap;
  final bool isSelected;

  const CityCard({
    super.key,
    required this.cityName,
    required this.landmarkIcon,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 125,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF1BAA56)
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFE8F8EE)
                    : const Color(0xFFF5F9F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  landmarkIcon,
                  size: 34,
                  color: isSelected
                      ? const Color(0xFF1BAA56)
                      : const Color(0xFF4CAF50),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              cityName,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? const Color(0xFF008744) : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
