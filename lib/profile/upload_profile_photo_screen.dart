import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../auth/success_screen.dart';
import '../services/local_profile_service.dart';

class UploadProfilePhotoScreen extends StatefulWidget {
  const UploadProfilePhotoScreen({super.key});

  @override
  State<UploadProfilePhotoScreen> createState() =>
      _UploadProfilePhotoScreenState();
}

class _UploadProfilePhotoScreenState extends State<UploadProfilePhotoScreen> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  bool isUploading = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadLocalImage();
  }

  // 🔥 LOAD LOCAL IMAGE IF EXISTS
  void _loadLocalImage() {
    final uid = _user?.uid;
    if (uid == null) return;

    final path = LocalProfileService.getProfileImage(uid);
    if (path != null) {
      setState(() => selectedImage = File(path));
    }
  }

  // 🔥 OPEN BOTTOM SHEET
  void _showImagePickerOptions() {
    if (isUploading) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Choose From",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _optionButton(
                      icon: Icons.camera_alt,
                      label: "Camera",
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _optionButton(
                      icon: Icons.photo_library,
                      label: "Gallery",
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // 🔥 SKIP
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _goToSuccess();
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 39, 45, 200),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // 📷 PICK IMAGE
  Future<void> _pickImage(ImageSource source) async {
    if (isUploading) return;

    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 75,
    );

    if (image != null) {
      setState(() => selectedImage = File(image.path));
      await _uploadImage();
    }
  }

  // 🚀 UPLOAD IMAGE
  Future<void> _uploadImage() async {
    if (_user == null || selectedImage == null) return;

    setState(() => isUploading = true);

    try {
      final uid = _user!.uid;

      // 🔥 FIREBASE STORAGE
      final ref = FirebaseStorage.instance
          .ref('profile_photos')
          .child('$uid.jpg');

      await ref.putFile(selectedImage!);
      final imageUrl = await ref.getDownloadURL();

      // 🔥 UPDATE FIRESTORE
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'photoUrl': imageUrl,
      });

      // 🔥 UPDATE AUTH PROFILE
      await _user!.updatePhotoURL(imageUrl);

      // 🔥 SAVE LOCALLY
      await LocalProfileService.saveProfileImage(uid, selectedImage!.path);

      _goToSuccess();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Image upload failed")));
      }
    }

    setState(() => isUploading = false);
  }

  // ✅ NAVIGATE TO SUCCESS
  void _goToSuccess() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SuccessScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !isUploading, // 🔒 BLOCK BACK WHILE UPLOADING
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: isUploading ? null : () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              selectedImage == null
                  ? Lottie.asset(
                    'assets/lottie/upload_profile.json',
                    height: 260,
                  )
                  : CircleAvatar(
                    radius: 90,
                    backgroundImage: FileImage(selectedImage!),
                  ),

              const SizedBox(height: 30),

              const Text(
                "Upload a Profile Photo to\nComplete Registration",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: 200,
                height: 55,
                child: ElevatedButton.icon(
                  onPressed: isUploading ? null : _showImagePickerOptions,
                  icon:
                      isUploading
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : const Icon(Icons.add, color: Colors.white),
                  label: Text(
                    isUploading ? "Uploading..." : "Upload",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 63, 104, 207),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
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

  Widget _optionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color.fromARGB(255, 68, 76, 222),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 60, 78, 198),
            ),
          ),
        ],
      ),
    );
  }
}
