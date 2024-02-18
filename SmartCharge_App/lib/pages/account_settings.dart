import 'package:flutter/material.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({Key? key}) : super(key: key);

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _profilePictureController;
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with default values or retrieved values
    _nameController = TextEditingController(text: "John Doe"); // Replace with retrieved name
    _profilePictureController = TextEditingController(text: "https://example.com/profile.jpg"); // Replace with retrieved profile picture URL
  }

  @override
  void dispose() {
    _nameController.dispose();
    _profilePictureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Change Username',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                suffixIcon: IconButton(
                  icon: Icon(_isEditable ? Icons.lock : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditable = !_isEditable;
                    });
                  },
                ),
              ),
              readOnly: !_isEditable,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call API or perform necessary actions to change the username
                // Use _nameController.text to get the new name
              },
              child: const Text('Save Username'),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Change Profile Picture URL',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, letterSpacing: 4),
                ),
              ),
            ),
            TextFormField(
              controller: _profilePictureController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                suffixIcon: IconButton(
                  icon: Icon(_isEditable ? Icons.lock : Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEditable = !_isEditable;
                    });
                  },
                ),
              ),
              readOnly: !_isEditable,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Call API or perform necessary actions to change the profile picture
                // Use _profilePictureController.text to get the new profile picture URL
              },
              child: const Text('Save Profile Picture URL'),
            ),
          ],
        ),
      ),
    );
  }
}
