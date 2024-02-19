import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:yee_mobile_app/services/user_service.dart';

class ProfileSettingsPage extends StatefulWidget {
  ProfileSettingsPage({Key? key, required this.callback}) : super(key: key);

  Function(BuildContext) callback;

  @override
  _ProfileSettingsPageState createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late TextEditingController _nameController;
  //late TextEditingController _profilePictureController;
  bool _isEditable = false;

  @override
  void initState() {
    super.initState();
    onLoad(context);
    _nameController = TextEditingController(text: "");
    // _profilePictureController = TextEditingController(text: "https://example.com/profile.jpg");
  }

  @override
  void dispose() {
    _nameController.dispose();
    //_profilePictureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки на профила'),
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
                  'Промени потребителско име',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4),
                ),
              ),
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
              onPressed: () async {
                await context
                    .read<UserService>()
                    .setUsername(_nameController.text);

                if (!context.mounted) return;
                widget.callback(context);
                context.pop();
              },
              child: const Text('Запази промените'),
            ),
            const SizedBox(height: 40),
            /*
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Change Profile Picture URL',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4),
                ),
              ),
            ),
            TextFormField(
              controller: _profilePictureController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
            */
          ],
        ),
      ),
    );
  }

  Future<void> onLoad(BuildContext context) async {
    var response = await context.read<UserService>().getUserSettings();

    setState(() {
      _nameController.text = response.data.settings.name;
    });
  }
}
