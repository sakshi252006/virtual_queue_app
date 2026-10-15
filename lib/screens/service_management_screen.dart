import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/common_widgets.dart';

class ServiceManagementScreen extends StatefulWidget {
  const ServiceManagementScreen({super.key});

  @override
  State<ServiceManagementScreen> createState() =>
      _ServiceManagementScreenState();
}

class _ServiceManagementScreenState extends State<ServiceManagementScreen> {
  final CollectionReference<Map<String, dynamic>> _services = FirebaseFirestore
      .instance
      .collection('services');

  IconData _serviceIcon(String category, String name) {
    final value = name.toLowerCase();

    if (value.contains('doctor')) {
      return Icons.medical_services_outlined;
    }
    if (value.contains('lab')) return Icons.science_outlined;
    if (value.contains('pharmacy')) {
      return Icons.local_pharmacy_outlined;
    }
    if (value.contains('registration')) {
      return Icons.receipt_long_outlined;
    }
    if (category == 'Bank') {
      return Icons.account_balance_outlined;
    }
    return Icons.design_services_outlined;
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> showServiceDialog({
    String? docId,
    Map<String, dynamic>? service,
  }) async {
    final isEditing = docId != null;
    final nameController = TextEditingController(
      text: service?['name']?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: service?['description']?.toString() ?? '',
    );

    String category = service?['category']?.toString() ?? 'Hospital';
    bool saving = false;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(isEditing ? 'Edit Service' : 'Add New Service'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Service Name',
                        prefixIcon: Icon(Icons.design_services_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        prefixIcon: Icon(Icons.description_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        prefixIcon: Icon(Icons.category_outlined),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'Hospital',
                          child: Text('Hospital'),
                        ),
                        DropdownMenuItem(value: 'Bank', child: Text('Bank')),
                        DropdownMenuItem(
                          value: 'General',
                          child: Text('General'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() => category = value);
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: saving ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryPurple,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: saving
                      ? null
                      : () async {
                          final name = nameController.text.trim();
                          final description = descriptionController.text.trim();

                          if (name.isEmpty || description.isEmpty) {
                            ScaffoldMessenger.of(dialogContext).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Enter service name and description.',
                                ),
                              ),
                            );
                            return;
                          }

                          setDialogState(() => saving = true);

                          final data = <String, dynamic>{
                            'name': name,
                            'description': description,
                            'category': category,
                            'active': service?['active'] ?? true,
                            'updatedAt': FieldValue.serverTimestamp(),
                          };

                          try {
                            if (isEditing) {
                              await _services.doc(docId).update(data);
                            } else {
                              data['createdAt'] = FieldValue.serverTimestamp();
                              await _services.add(data);
                            }

                            if (!dialogContext.mounted) return;
                            Navigator.pop(dialogContext);
                            _message(
                              isEditing
                                  ? 'Service updated successfully.'
                                  : 'Service added successfully.',
                            );
                          } on FirebaseException catch (e) {
                            if (dialogContext.mounted) {
                              setDialogState(() => saving = false);
                            }
                            _message(e.message ?? 'Could not save service.');
                          } catch (_) {
                            if (dialogContext.mounted) {
                              setDialogState(() => saving = false);
                            }
                            _message('Could not save service. Try again.');
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(isEditing ? 'Save Changes' : 'Add Service'),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    descriptionController.dispose();
  }

  Future<void> deleteService(String docId, String name) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Service?'),
        content: Text('Do you want to delete "$name"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _services.doc(docId).delete();
      _message('Service deleted successfully.');
    } on FirebaseException catch (e) {
      _message(e.message ?? 'Could not delete service.');
    } catch (_) {
      _message('Could not delete service. Try again.');
    }
  }

  Future<void> toggleService(String docId, bool currentlyActive) async {
    try {
      await _services.doc(docId).update({
        'active': !currentlyActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      _message(currentlyActive ? 'Service deactivated.' : 'Service activated.');
    } on FirebaseException catch (e) {
      _message(e.message ?? 'Could not update service status.');
    } catch (_) {
      _message('Could not update service status.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightPurple,
      appBar: AppBar(
        backgroundColor: lightPurple,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: darkText),
        ),
        title: const Text(
          'Service Management',
          style: TextStyle(
            color: darkText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showServiceDialog(),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Service'),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: _services.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not load services.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final docs = snapshot.data?.docs ?? [];
            final activeCount = docs
                .where((doc) => doc.data()['active'] == true)
                .length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [primaryPurple, Color(0xFF9B8AE8)],
                      ),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 55,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.miscellaneous_services_outlined,
                            color: Colors.white,
                            size: 29,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Manage Services',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${docs.length} services available',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'All Services',
                          style: TextStyle(
                            color: darkText,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '$activeCount Active',
                        style: const TextStyle(
                          color: mintGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: docs.isEmpty
                      ? const Center(
                          child: Text(
                            'No services yet.\nTap Add Service to create one.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: greyText),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 90),
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            final data = doc.data();
                            final name = data['name']?.toString() ?? 'Unnamed';
                            final category =
                                data['category']?.toString() ?? 'General';
                            final description =
                                data['description']?.toString() ?? '';
                            final active = data['active'] == true;

                            return Container(
                              margin: const EdgeInsets.only(bottom: 13),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(19),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 52,
                                        height: 52,
                                        decoration: BoxDecoration(
                                          color: lightPurple,
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                        child: Icon(
                                          _serviceIcon(category, name),
                                          color: primaryPurple,
                                          size: 26,
                                        ),
                                      ),
                                      const SizedBox(width: 13),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: const TextStyle(
                                                color: darkText,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              category,
                                              style: const TextStyle(
                                                color: greyText,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuButton<String>(
                                        onSelected: (value) {
                                          if (value == 'edit') {
                                            showServiceDialog(
                                              docId: doc.id,
                                              service: data,
                                            );
                                          } else if (value == 'toggle') {
                                            toggleService(doc.id, active);
                                          } else if (value == 'delete') {
                                            deleteService(doc.id, name);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                            value: 'edit',
                                            child: Text('Edit'),
                                          ),
                                          PopupMenuItem(
                                            value: 'toggle',
                                            child: Text(
                                              active
                                                  ? 'Deactivate'
                                                  : 'Activate',
                                            ),
                                          ),
                                          const PopupMenuItem(
                                            value: 'delete',
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      description,
                                      style: const TextStyle(
                                        color: greyText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: active
                                              ? const Color(0xFFE4F7EF)
                                              : const Color(0xFFF2F0F5),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Text(
                                          active ? 'Active' : 'Inactive',
                                          style: TextStyle(
                                            color: active
                                                ? mintGreen
                                                : greyText,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      TextButton.icon(
                                        onPressed: () => showServiceDialog(
                                          docId: doc.id,
                                          service: data,
                                        ),
                                        icon: const Icon(
                                          Icons.edit_outlined,
                                          size: 16,
                                        ),
                                        label: const Text('Edit'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
