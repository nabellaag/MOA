import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:moa_final_project/viewmodels/auth_viewmodel.dart';

class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  _AddStoryScreenState createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submit() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final description = _descriptionController.text;

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a description')),
      );
      return;
    }

    try {
      await authViewModel.addStory(
        description,
        _image!,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Story added successfully')),
          );
          Navigator.pop(context); // Kembali ke layar sebelumnya (HomeScreen)
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error)),
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add story: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Story'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _image == null
                  ? GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.add_a_photo,
                      color: Colors.grey[700], size: 50),
                ),
              )
                  : GestureDetector(
                onTap: _pickImage,
                child: Image.file(
                  _image!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Pick Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
