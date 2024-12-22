import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'models/show_seller.dart';
import 'models/show_comment.dart';
import 'models/show_reply.dart';

class CommentPage extends StatefulWidget {
  final int id;
  final String companyName;
  const CommentPage({super.key, required this.id, required this.companyName});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<ShowSeller> seller = [];
  List<ShowComment> comments = [];
  Map<String, List<ShowReply>> replies = {};
  bool isLoading = true;
  final TextEditingController commentController = TextEditingController();
  int rating = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => fetchData());
  }

  Future<void> fetchData() async {
    final request = context.read<CookieRequest>();
    try {
      // Fetch seller details
      (widget.id);
      final sellerResponse = await request.get(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/show_seller/${widget.id}');
      if (sellerResponse is List) {
        seller =
            sellerResponse.map((item) => ShowSeller.fromJson(item)).toList();
      }

      // Fetch comments
      final commentResponse = await request.get(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/show_comment/${widget.id}');
      if (commentResponse is List) {
        comments =
            commentResponse.map((item) => ShowComment.fromJson(item)).toList();
      }

      // Fetch replies for each comment
      for (var comment in comments) {
        final replyResponse = await request.get(
            'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/show_reply/${comment.pk}');
        if (replyResponse is List) {
          replies[comment.pk] =
              replyResponse.map((item) => ShowReply.fromJson(item)).toList();
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ('Error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> refreshComments() async {
    commentController.clear();
    setState(() {
      rating = 0;
    });
    await fetchData();
  }

  Future<void> submitComment() async {
    if (commentController.text.isEmpty || rating == 0) return;
    final request = context.read<CookieRequest>();
    ('Login status: ${commentController.text}');
    ('star: ${rating.toString()}');
    try {
      final response = await request.post(
          'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/add_comment_api/${widget.id}',
          {
            'body': commentController.text,
            'star': rating.toString(),
          });
      if (mounted) {
        (response);
        if (response["status"] == "success") {
          commentController.clear();
          setState(() {
            rating = 0;
          });
          await fetchData();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comment posted successfully')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to post comment')),
          );
        }
        ;
      }
    } catch (e) {
      (e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to post comment')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Discussion',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromRGBO(74, 98, 138, 1),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (context.read<CookieRequest>().jsonData['is_buyer'] ==
                      true)
                    // Comment Input
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: commentController,
                            decoration: const InputDecoration(
                              labelText: 'Add a comment',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Rating: '),
                              ...List.generate(
                                5,
                                (index) => IconButton(
                                  icon: Icon(
                                    index < rating
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: Colors.amber,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      rating = index + 1;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: submitComment,
                            child: const Text('Submit Comment'),
                          ),
                        ],
                      ),
                    ),
                  // Comments List or No Comments Message
                  if (comments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Belum ada review pada toko ini',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                    )
                  else
                    // Comments List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comments.length,
                      itemBuilder: (context, index) {
                        final comment = comments[index];
                        return CommentCard(
                          comment: comment,
                          replies: replies[comment.pk] ?? [],
                          refreshComments: refreshComments,
                          companyName: widget.companyName,
                        );
                      },
                    ),
                ],
              ),
            ),
    );
  }
}

class CommentCard extends StatefulWidget {
  final ShowComment comment;
  final List<ShowReply> replies;
  final Function refreshComments;
  final String companyName;

  const CommentCard({
    super.key,
    required this.comment,
    required this.replies,
    required this.refreshComments,
    required this.companyName,
  });

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isEditing = false;
  bool isReplying = false;
  final TextEditingController editController = TextEditingController();
  final TextEditingController replyController = TextEditingController();
  String? editingReplyId;
  final TextEditingController editReplyController = TextEditingController();
  int editingStarRating = 0;

  @override
  void initState() {
    super.initState();
    editController.text = widget.comment.fields.body;
  }

  Future<void> submitReply() async {
    if (replyController.text.isEmpty) return;
    final request = context.read<CookieRequest>();
    try {
      await request.post(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/reply_api/${widget.comment.pk}',
        {
          'body': replyController.text,
        },
      );
      setState(() {
        isReplying = false;
        replyController.clear();
      });
      widget.refreshComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add reply')),
      );
    }
  }

  Future<void> updateReply(String replyId) async {
    final request = context.read<CookieRequest>();
    try {
      await request.post(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/edit_reply_api/$replyId',
        {
          'body': editReplyController.text,
        },
      );
      setState(() {
        editingReplyId = null;
      });
      widget.refreshComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update reply')),
      );
    }
  }

  Future<void> deleteReply(String replyId) async {
    final request = context.read<CookieRequest>();
    try {
      await request.post(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/delete_reply_api/$replyId',
        {},
      );
      widget.refreshComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete reply')),
      );
    }
  }

  Future<void> updateComment() async {
    final request = context.read<CookieRequest>();
    try {
      await request.post(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/edit_comment_api/${widget.comment.pk}',
        {
          'body': editController.text,
          'star': editingStarRating.toString(),
        },
      );
      setState(() {
        isEditing = false;
      });
      widget.refreshComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update comment')),
      );
    }
  }

  Future<void> deleteComment() async {
    final request = context.read<CookieRequest>();
    try {
      await request.post(
        'https://tristan-agra-househunt.pbp.cs.ui.ac.id/diskusi/delete_comment_api/${widget.comment.pk}',
        {},
      );
      widget.refreshComments();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete comment')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment Container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFDCF2F1),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment Header with Edit/Delete
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.comment.fields.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (context
                            .read<CookieRequest>()
                            .jsonData['company_name'] ==
                        widget.companyName) // Add this condition
                      Row(children: [
                        IconButton(
                          icon: const Icon(Icons.reply),
                          onPressed: () {
                            setState(() {
                              isReplying = !isReplying;
                            });
                          },
                        )
                      ]),
                    if (widget.comment.fields.name ==
                        context.read<CookieRequest>().jsonData['username'])
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, size: 20),
                            onPressed: () {
                              setState(() {
                                isEditing = !isEditing;
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete Comment'),
                                  content: const Text('Are you sure?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deleteComment();
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                  ],
                ),
                // Star Rating
                Row(
                  children: [
                    ...List.generate(
                      widget.comment.fields.star,
                      (index) =>
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Comment Body
                if (isEditing)
                  Column(
                    children: [
                      Row(children: [
                        const Text('Rating: '),
                        ...List.generate(
                          5,
                          (index) => IconButton(
                            icon: Icon(
                              index < editingStarRating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                editingStarRating = index + 1;
                              });
                            },
                          ),
                        ),
                      ]),
                      TextField(
                        controller: editController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                isEditing = false;
                                editController.text =
                                    widget.comment.fields.body;
                              });
                            },
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: updateComment,
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                    ],
                  )
                else
                  Text(widget.comment.fields.body),
              ],
            ),
          ),

          //reply section
          if (isReplying)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    controller: replyController,
                    decoration: const InputDecoration(
                      labelText: 'Add a reply',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isReplying = false;
                            replyController.clear();
                          });
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: submitReply,
                        child: const Text('Reply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Replies Section
          if (widget.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: widget.replies.map((reply) {
                  return Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7AB2D3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              reply.fields.name.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (reply.fields.name ==
                                context
                                    .read<CookieRequest>()
                                    .jsonData['company_name'])
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        editingReplyId = reply.pk;
                                        editReplyController.text =
                                            reply.fields.body;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text('Delete Reply'),
                                          content: const Text('Are you sure?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteReply(reply.pk);
                                              },
                                              child: const Text('Delete'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (editingReplyId == reply.pk)
                          Column(
                            children: [
                              TextField(
                                controller: editReplyController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(color: Colors.white),
                                maxLines: 3,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        editingReplyId = null;
                                      });
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => updateReply(reply.pk),
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else
                          Text(
                            reply.fields.body,
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
