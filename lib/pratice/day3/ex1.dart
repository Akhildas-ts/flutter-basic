import 'package:flutter/material.dart';

// TODO: Create a ProfileCard StatelessWidget
// Properties:
// - name (required String)
// - title (required String)
// - imageUrl (optional String?)
// - isOnline (bool, default false)
//
// Display:
// - Avatar with first letter of name (or image if provided)
// - Name in bold
// - Title below name
// - Green dot indicator if online

class ProfileCard extends StatelessWidget {
  final String name;
  final String title;
  final String? imageUrl;
  final bool isOnline;

  const ProfileCard({
    super.key,
    required this.name,
    required this.title,
    this.imageUrl,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Avatar with online indicator
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage:
                      imageUrl != null ? NetworkImage(imageUrl!) : null,
                  child: imageUrl == null
                      ? Text(
                          name[0],
                          style: const TextStyle(fontSize: 20),
                        )
                      : null,
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // Name + title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


// TODO: Create a ToggleCard StatefulWidget
// Properties:
// - title (required String)
// - initiallyExpanded (bool, default false)
//
// Behavior:
// - Shows title and expand/collapse icon
// - When tapped, toggles between collapsed and expanded
// - When expanded, shows a Lorem ipsum text

class ToggleCard extends StatefulWidget {
  final String title;
  final bool initiallyExpanded;

  const ToggleCard({
    super.key,
    required this.title,
    this.initiallyExpanded = false,
  });

  @override
  State<ToggleCard> createState() => _ToggleCardState();
}

class _ToggleCardState extends State<ToggleCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
  }

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.expand_less
                        : Icons.expand_more,
                  ),
                ],
              ),

              // Expanded content
              if (_expanded) ...[
                const SizedBox(height: 8),
                const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                  'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Exercise 3.1')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ProfileCard(
              name: 'Alice Johnson',
              title: 'Software Engineer',
              isOnline: true,
            ),
            ProfileCard(
              name: 'Bob Smith',
              title: 'Product Manager',
            ),
            SizedBox(height: 16),
            ToggleCard(
              title: 'About Us',
              initiallyExpanded: true,
            ),
            ToggleCard(
              title: 'Contact Information',
            ),
          ],
        ),
      ),
    ),
  );
}