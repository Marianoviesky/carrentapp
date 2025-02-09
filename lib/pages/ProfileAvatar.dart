import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatar extends StatefulWidget {
  @override
  _ProfileAvatarState createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // Charger l'image depuis les préférences locales
  Future<void> _loadProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image');
    if (imagePath != null) {
      setState(() {
        _image = File(imagePath);
      });
    }
  }

  // Sélectionner une image depuis la galerie
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      // Sauvegarder l'image localement
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profile_image', pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    double radius = MediaQuery.of(context).size.width * 0.15;

    return GestureDetector(
      onTap: _pickImage, // Ouvre la galerie au clic
      child: CircleAvatar(
        radius: radius,
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.grey[300],
        backgroundImage: _image != null ? FileImage(_image!) : null,
        child: _image == null
            ? Icon(
                Icons.person,
                color: isDarkMode ? Colors.white : const Color(0xff3b22a1),
                size: radius * 1.3,
              )
            : null, // Cache l'icône si une image est sélectionnée
      ),
    );
  }
}
