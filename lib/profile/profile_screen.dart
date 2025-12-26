import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();

  final List<String> _genderOptions = ["Male", "Female", "Other"];

  String _gender = "Male";
  bool isLoading = false;

  File? _pickedImage;
  String photoUrl = "";

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 🔥 LOAD PROFILE
  Future<void> _loadProfile() async {
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = data['name'] ?? "";
      _emailController.text = data['email'] ?? "";
      _mobileController.text = data['mobile'] ?? "";
      _gender = data['gender'] ?? "Male";
      photoUrl = data['photoUrl'] ?? "";

      if (!_genderOptions.contains(_gender)) {
        _gender = "Male";
      }
      setState(() {});
    }
  }

  // 🔥 PICK IMAGE
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        _pickedImage = File(picked.path);
      });
      await _uploadProfileImage();
    }
  }

  // 🔥 UPLOAD IMAGE
  Future<void> _uploadProfileImage() async {
    if (_pickedImage == null || user == null) return;

    final ref = FirebaseStorage.instance
        .ref()
        .child("profile_images")
        .child("${user!.uid}.jpg");

    await ref.putFile(_pickedImage!);
    final url = await ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
      'photoUrl': url,
    });

    setState(() {
      photoUrl = url;
    });
  }

  // 🔥 UPDATE PROFILE
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate() || user == null) return;

    setState(() => isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
            'name': _nameController.text.trim(),
            'mobile': _mobileController.text.trim(),
            'gender': _gender,
          });

      if (_passwordController.text.isNotEmpty) {
        await user!.updatePassword(_passwordController.text.trim());
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider avatarImage;

    if (_pickedImage != null) {
      avatarImage = FileImage(_pickedImage!);
    } else if (photoUrl.isNotEmpty) {
      avatarImage = NetworkImage(photoUrl);
    } else {
      avatarImage = const AssetImage("assets/images/profile.png");
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF1C4ED8),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 🔥 PROFILE IMAGE (TAP TO CHANGE)
              GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(radius: 50, backgroundImage: avatarImage),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.camera_alt,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                validator: (v) => v!.isEmpty ? "Enter name" : null,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                ),
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _mobileController,
                decoration: const InputDecoration(
                  labelText: "Mobile",
                  prefixIcon: Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 14),

              DropdownButtonFormField<String>(
                value: _gender,
                items:
                    _genderOptions
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                onChanged: (v) => setState(() => _gender = v!),
                decoration: const InputDecoration(
                  labelText: "Gender",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),

              const SizedBox(height: 14),

              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Change Password",
                  prefixIcon: Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _updateProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1C4ED8),
                  ),
                  child:
                      isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
