import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fixy/providers/profile_provider.dart';

void showEditPictureSheet(BuildContext context, String? profileUrl) {
  final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  profileProvider.clearPreview();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          20,
          20,
          MediaQuery.of(context).viewInsets.bottom + 30,
        ),
        child: Consumer<ProfileProvider>(
          builder: (context, provider, _) {
            final image = provider.selectedImageBytes;
            final isLoading = provider.isUploading;
            final error = provider.errorMessage;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: image != null
                          ? Image.memory(
                              image,
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            )
                          : CircleAvatar(
                              radius: 45,
                              backgroundColor: Colors.indigo.shade50,
                              backgroundImage: profileUrl != null
                                  ? NetworkImage(
                                      profileUrl,
                                      headers: {
                                        'ngrok-skip-browser-warning': 'true',
                                      },
                                    )
                                  : null,
                              child: profileUrl == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 45,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                    ),
                    if (isLoading)
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                if (error != null && error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      error,
                      style: const TextStyle(color: Colors.redAccent),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ElevatedButton.icon(
                  onPressed: () => provider.pickImage(fromCamera: false),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => provider.pickImage(fromCamera: true),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    foregroundColor: const Color(0xFF4F46E5),
                    minimumSize: const Size.fromHeight(45),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () => provider.removeProfilePicture(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.close, color: Colors.redAccent),
                      SizedBox(width: 6),
                      Text(
                        'Remove Photo',
                        style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
