import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jigsaw_client/ui/providers/objects_providers/users_provider.dart';

class UserManagementPage extends ConsumerWidget {
  const UserManagementPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(usersProvider);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('User Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => ref.read(usersProvider.notifier).fetchData(),
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddUserDialog(context, ref),
          ),
        ],
      ),
      body:
          usersState.isLoading
              ? Center(child: CircularProgressIndicator())
              : usersState.error != null
              ? Center(child: Text('Error: ${usersState.error}'))
              : usersState.data!.isEmpty
              ? Center(child: Text('No users found'))
              : ListView.separated(
                padding: EdgeInsets.all(8),
                itemCount: usersState.data!.length,
                separatorBuilder: (_, __) => Divider(),
                itemBuilder: (_, index) {
                  final user = usersState.data![index];
                  return ListTile(
                    title: Text(
                      '${user.fName} ${user.lName} (${user.nickname})',
                    ),
                    subtitle: Text('Role: ${user.role}'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed:
                          user.nickname == "root"
                              ? null
                              : () async {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        title: Text('Delete User'),
                                        content: Text(
                                          'Are you sure you want to delete ${user.nickname}?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, false),
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(ctx, true),
                                            child: Text('Delete'),
                                          ),
                                        ],
                                      ),
                                );
                                if (confirmed == true) {
                                  await ref
                                      .read(usersProvider.notifier)
                                      .deleteUser(user.nickname);
                                }
                              },
                    ),
                  );
                },
              ),
    );
  }

  void _showAddUserDialog(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final nicknameController = TextEditingController();
    final passwordController = TextEditingController();
    final fNameController = TextEditingController();
    final lNameController = TextEditingController();
    final emailController = TextEditingController();
    String selectedRole = 'worker';

    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Add User'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nicknameController,
                      decoration: InputDecoration(labelText: 'Nickname'),
                      validator: _required,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: _required,
                    ),
                    TextFormField(
                      controller: fNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                    ),
                    TextFormField(
                      controller: lNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: _required,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(labelText: 'Role'),
                      items:
                          ['admin', 'worker', 'viewer']
                              .map(
                                (role) => DropdownMenuItem(
                                  value: role,
                                  child: Text(role),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        if (value != null) selectedRole = value;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await ref
                        .read(usersProvider.notifier)
                        .createUser(
                          nickname: nicknameController.text.trim(),
                          password: passwordController.text.trim(),
                          role: selectedRole,
                          fName: fNameController.text.trim(),
                          lName: lNameController.text.trim(),
                          email: emailController.text.trim(),
                        );
                    if (context.mounted) Navigator.of(context).pop();
                  }
                },
                child: Text('Create'),
              ),
            ],
          ),
    );
  }

  String? _required(String? value) =>
      (value == null || value.isEmpty) ? 'Required' : null;
}
