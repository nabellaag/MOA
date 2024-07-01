import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moa_final_project/viewmodels/auth_viewmodel.dart';
import 'add_story_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Fetch stories when the screen is loaded
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      authViewModel.fetchStories();
    });

    void _logout() async {
      await authViewModel.logout();
      Navigator.pushReplacementNamed(context, '/login');
    }

    void _addStory() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddStoryScreen()),
      );
    }

    void _deleteStory(String storyId) {
      authViewModel.deleteStory(
        storyId,
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Story deleted successfully')),
          );
        },
        onError: (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete story: $error')),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: TextStyle(fontFamily: 'Billabong', fontSize: 30)),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: authViewModel.stories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: authViewModel.stories.length,
        itemBuilder: (context, index) {
          final story = authViewModel.stories[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(story.photoUrl),
            ),
            title: Text(story.name),
            subtitle: Text(story.description),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => _deleteStory(story.id),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addStory,
        child: Icon(Icons.add),
      ),
    );
  }
}
