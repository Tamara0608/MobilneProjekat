import 'package:flutter/material.dart';
import '../services/service.dart';
import 'primary_outlined_button.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onMore;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Image.asset(
              service.imagePath,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  service.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
              PrimaryOutlinedButton(
                text: 'Više o tretmanu',
                onPressed: onMore,
              ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
