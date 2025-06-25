import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lose_found/AnotherUsersProfiles/UsersProfile.dart';

class Search extends StatelessWidget {
  const Search({super.key});
  @override
  Widget build(BuildContext context) {
    //what navigator do ?
    return Navigator(
      key: GlobalKey<NavigatorState>(),
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          builder: (ctx) => const _SearchList(),
        );
      },
    );

  }
}

class _SearchList extends StatefulWidget {
  const _SearchList({super.key});

  @override
  State<_SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<_SearchList> {

  List<Map<String, dynamic>> _allUsers = [];
  List<Map<String, dynamic>> _filteredUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }
//why async
  //future يعني عمليه بدها وقت لحتى يكون في اتصال بالانترنت وتتصل بالداتابيس وفي كمله await
  //
  Future<void> _loadUsers() async {

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .get();

      _allUsers = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'uid': doc.id,
          'username': data['username'] ,
          'avatarURL': data['avatarURL'] ,
        };
      }).toList();

      setState(() {
        _filteredUsers = List.from(_allUsers);
        _isLoading = false;
      });


  }
  /*
   contains: وظيفتها انها تفحص اذا النص الاول يحتوي على النص الثاني
   حولتهم الثنين ل احرف صغيرة عشان  الاقي كلشي
  * */
  void _filterItems(String query) {
    setState(() {
      _filteredUsers = query.isEmpty
          ? List.from(_allUsers)
          : _allUsers
          .where((user) =>

          (user['username'] as String).toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _isLoading
          ?  Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              _filterItems(value);
            },

          ),
          const SizedBox(height: 16),
          if (_filteredUsers.isEmpty)
            const Center(child: Text('No Result')),
          ..._filteredUsers.map((user) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage:
                  NetworkImage(user['avatarURL'] as String),
                ),
                title: Text(user['username'] as String),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          UsersProfile(uid: user['uid'] as String),
                    ),
                  );
                },
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
