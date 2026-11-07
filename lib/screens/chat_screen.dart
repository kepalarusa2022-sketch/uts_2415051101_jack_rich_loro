import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'sender': 'admin',
      'name': 'Customer Care KosFinder',
      'text': 'Halo Jack! Ada yang bisa kami bantu seputar pencarian kos atau booking kamar hari ini?',
      'time': '10:00',
    },
    {
      'sender': 'user',
      'name': 'Jack Rich Loro',
      'text': 'Halo, apakah kamar di Kost Wisma Divina Sejahtera masih tersedia?',
      'time': '10:02',
    },
    {
      'sender': 'admin',
      'name': 'Customer Care KosFinder',
      'text': 'Masih tersedia 2 kamar eksklusif dengan AC dan kamar mandi dalam! Anda bisa langsung simpan ke Wishlist atau buat janji survei.',
      'time': '10:03',
    },
  ];

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({
        'sender': 'user',
        'name': 'Jack Rich Loro',
        'text': text,
        'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      });
      _messageController.clear();
    });

    // Auto reply simulation
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _messages.add({
            'sender': 'admin',
            'name': 'Customer Care KosFinder',
            'text': 'Pesan Anda telah diterima pengelola. Kami akan segera menghubungi nomor telepon Anda.',
            'time': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(
              radius: 17,
              backgroundColor: Colors.white,
              child: Icon(Icons.support_agent, color: Color(0xFF1BAA56)),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'KosFinder Support',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online â€¢ Siap Membantu 24 Jam',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1BAA56),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.78,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isUser ? const Color(0xFF1BAA56) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(14),
                        topRight: const Radius.circular(14),
                        bottomLeft: Radius.circular(isUser ? 14 : 2),
                        bottomRight: Radius.circular(isUser ? 2 : 14),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        if (!isUser)
                          Text(
                            msg['name'],
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF008744),
                            ),
                          ),
                        const SizedBox(height: 2),
                        Text(
                          msg['text'],
                          style: TextStyle(
                            fontSize: 13.5,
                            color: isUser ? Colors.white : Colors.black87,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg['time'],
                          style: TextStyle(
                            fontSize: 10,
                            color: isUser ? Colors.white70 : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Tulis pesan atau pertanyaan kos...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 13),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1BAA56),
                    radius: 22,
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
