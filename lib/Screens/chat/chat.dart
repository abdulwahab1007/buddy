import 'package:buddy/res/contants/colors_contants.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  // List of sample messages with sender info
  List<Map<String, dynamic>> messages = [
    {'sender': 'Receiver', 'message': 'Hello! How are you?', 'type': 'text'},
    {
      'sender': 'Sender',
      'message': 'I am good, thanks! How about you?',
      'type': 'text'
    },
    {'sender': 'Receiver', 'message': 'I am doing well!', 'type': 'text'},
    {
      'sender': 'Sender',
      'message':
          'This is a longer message to test the resizing of the message box.',
      'type': 'text'
    },
  ];

  // Controller for the message input field
  TextEditingController messageController = TextEditingController();
  bool isTyping = false;
  DateTime? selectedDate;
  bool showAttachmentOptions = false;

  // Function to add a message to the list
  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'Sender',
          'message': messageController.text,
          'type': 'text',
        });
      });
      messageController.clear();
      setState(() {
        isTyping = false;
      });
    }
  }

  // Function to pick files
  Future<void> pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc', 'docx', 'png'],
    );

    if (result != null) {
      for (var file in result.files) {
        setState(() {
          messages.add({
            'sender': 'Sender',
            'message': file.name,
            'type': 'file',
            'fileType': file.extension,
          });
        });
      }
      setState(() {
        showAttachmentOptions = false;
      });
    }
  }

  // Function to show attachment options
  void showAttachmentOptionsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildAttachmentOption(
                  icon: Icons.image_rounded,
                  label: 'Photo',
                  onTap: () {
                    Navigator.pop(context);
                    pickFiles();
                  },
                  color: Colors.blue,
                ),
                _buildAttachmentOption(
                  icon: Icons.file_copy_rounded,
                  label: 'Document',
                  onTap: () {
                    Navigator.pop(context);
                    pickFiles();
                  },
                  color: Colors.orange,
                ),
                _buildAttachmentOption(
                  icon: Icons.local_offer_rounded,
                  label: 'Send Offer',
                  onTap: () {
                    Navigator.pop(context);
                    showSendOfferDialog();
                  },
                  color: ColorsContants.primaryColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to show send offer dialog
  Future<void> showSendOfferDialog() async {
    TextEditingController revisionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    String? selectedGig;
    List<String> gigs = ['Gig 1', 'Gig 2', 'Gig 3']; // Replace with actual gigs

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create Offer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorsContants.primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Gig Selection
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedGig,
                        decoration: InputDecoration(
                          labelText: 'Select Gig',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                        items: gigs.map((String gig) {
                          return DropdownMenuItem<String>(
                            value: gig,
                            child: Text(gig),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedGig = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Number of Revisions
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: revisionController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Number of Revisions',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Price
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Price (\$)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Delivery Date Selection
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: ColorsContants.primaryColor,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey),
                                const SizedBox(width: 12),
                                Text(
                                  selectedDate == null
                                      ? 'Select Delivery Date'
                                      : DateFormat('MMM dd, yyyy')
                                          .format(selectedDate!),
                                  style: TextStyle(
                                    color: selectedDate == null
                                        ? Colors.grey[600]
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Send Offer Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsContants.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          if (selectedGig != null &&
                              revisionController.text.isNotEmpty &&
                              priceController.text.isNotEmpty &&
                              selectedDate != null) {
                            setState(() {
                              messages.add({
                                'sender': 'Sender',
                                'message':
                                    'Offer Sent:\nGig: $selectedGig\nRevisions: ${revisionController.text}\nPrice: \$${priceController.text}\nDelivery: ${DateFormat('MMM dd, yyyy').format(selectedDate!)}',
                                'type': 'offer',
                              });
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          'Send Offer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Online",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // List of messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isSender = message['sender'] == 'Sender';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: isSender
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (!isSender) ...[
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person,
                              color: Colors.grey[600], size: 20),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Flexible(
                        child: Container(
                          constraints: BoxConstraints(
                              maxWidth:
                                  MediaQuery.of(context).size.width * 0.7),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSender
                                ? ColorsContants.primaryColor
                                : Colors.grey[100],
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(20),
                              topRight: const Radius.circular(20),
                              bottomLeft: isSender
                                  ? const Radius.circular(20)
                                  : const Radius.circular(5),
                              bottomRight: isSender
                                  ? const Radius.circular(5)
                                  : const Radius.circular(20),
                            ),
                          ),
                          child: _buildMessageContent(message),
                        ),
                      ),
                      if (isSender) ...[
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.grey[300],
                          child: Icon(Icons.person,
                              color: Colors.grey[600], size: 20),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  // Plus button for attachments
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.add, color: ColorsContants.primaryColor),
                      onPressed: showAttachmentOptionsModal,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Message input field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: messageController,
                        onChanged: (value) {
                          setState(() {
                            isTyping = value.isNotEmpty;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Send button
                  Container(
                    decoration: const BoxDecoration(
                      color: ColorsContants.primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(
                        isTyping ? Icons.send : Icons.mic,
                        color: Colors.white,
                      ),
                      onPressed: isTyping ? sendMessage : null,
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

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageContent(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'file':
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              message['fileType'] == 'pdf'
                  ? Icons.picture_as_pdf
                  : message['fileType'] == 'doc' ||
                          message['fileType'] == 'docx'
                      ? Icons.description
                      : Icons.image,
              color: Colors.grey[600],
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                message['message'],
                style: const TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      case 'offer':
        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '💼 New Offer',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message['message'],
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
        );
      default:
        return Text(
          message['message'],
          style: TextStyle(
            color:
                message['sender'] == 'Sender' ? Colors.black : Colors.black87,
          ),
        );
    }
  }
}
