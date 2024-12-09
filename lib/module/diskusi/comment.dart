import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<dynamic> comments = []; // Holds comments and replies
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchComments(); // Fetch comments when the page initializes
  }

  Future<void> fetchComments() async {
    final url = Uri.parse('http://127.0.0.8/diskusi/show_comments'); // Replace with your endpoint
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          comments = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return CommentCard(
                  username: comment['username'],
                  rating: comment['rating'].toString(),
                  comment: comment['comment'],
                  replies: comment['replies'],
                );
              },
            ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final String username;
  final String rating;
  final String comment;
  final List<dynamic> replies;

  const CommentCard({
    Key? key,
    required this.username,
    required this.rating,
    required this.comment,
    required this.replies,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue[50],
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rating: $rating',
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                SizedBox(height: 8),
                Text(
                  comment,
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        // Add Reply functionality
                      },
                      child: Text(
                        'Reply',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          // Replies Section
          ...replies.map((reply) {
            return Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reply['username'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      reply['comment'],
                      style: TextStyle(color: Colors.white),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            // Edit functionality
                          },
                          child: Text(
                            'Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // Delete functionality
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
