import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:moa_final_project/viewmodels/auth_viewmodel.dart';
import 'add_story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Memanggil fetchStories saat layar diinisialisasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      authViewModel.fetchStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final username = authViewModel.user?.name ?? 'User'; // Ambil nama pengguna dari AuthViewModel

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

    Widget _buildHome() {
      return authViewModel.stories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemCount: authViewModel.stories.length,
        itemBuilder: (context, index) {
          final story = authViewModel.stories[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(story.photoUrl),
                  ),
                  title: Text(story.name, style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                Image.network(
                  story.photoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(story.description),
                ),
              ],
            ),
          );
        },
      );
    }

    Widget _buildAccount() {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              username,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome $username', style: TextStyle(fontFamily: 'Billabong', fontSize: 30)),
      ),
      body: _selectedIndex == 0 ? _buildHome() : _buildAccount(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: _addStory,
        child: Icon(Icons.add),
      )
          : null, // Hanya tampilkan FAB di halaman Home
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.green : Colors.grey),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: _selectedIndex == 1 ? Colors.green : Colors.grey),
            label: 'Account',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
