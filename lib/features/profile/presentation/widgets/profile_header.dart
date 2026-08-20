import 'package:flutter/material.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileEntity profile;

  const ProfileHeader({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CircleAvatar(
          radius: 48,
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.person, size: 54, color: Colors.white),
        ),
        const SizedBox(height: 12),
        Text(
          profile.name,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          profile.phone,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
