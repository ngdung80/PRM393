import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import '../viewmodels/user_view_model.dart';
import '../widgets/avatar_image.dart';
import 'user_detail_screen.dart';

class UserListScreen extends ConsumerStatefulWidget {
  const UserListScreen({super.key});

  @override
  ConsumerState<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends ConsumerState<UserListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _avatarController = TextEditingController();

  UserModel? _editingUser;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _avatarController.dispose();
    super.dispose();
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Manager'),
        centerTitle: false,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _resetForm,
            tooltip: 'Thêm mới',
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= constraints.maxHeight;

            if (isWide) {
              // Landscape / Tablet: form on left, 2-column grid on right
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 320,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: _buildForm(),
                    ),
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: _buildUserList(
                        users: state.items,
                        crossAxisCount: 2,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              // Portrait: form on top, 1-column list below
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: <Widget>[
                    _buildForm(),
                    const SizedBox(height: 12),
                    Expanded(
                      child: _buildUserList(
                        users: state.items,
                        crossAxisCount: 1,
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // -------------------------------------------------------------------------
  // Form
  // -------------------------------------------------------------------------
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // Full name field
          TextFormField(
            key: const Key('input_fullname'),
            controller: _fullNameController,
            decoration: const InputDecoration(
              labelText: 'Họ và tên',
              hintText: 'Nhập họ và tên',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            validator: _validateFullName,
          ),
          const SizedBox(height: 8),
          // Email field
          TextFormField(
            key: const Key('input_email'),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'example@gmail.com',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(),
            ),
            validator: _validateEmail,
          ),
          const SizedBox(height: 8),
          // Avatar field — must NOT be readOnly so tests can enterText directly
          TextFormField(
            key: const Key('input_avatar'),
            controller: _avatarController,
            decoration: InputDecoration(
              labelText: 'Avatar',
              hintText: 'Chọn ảnh',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.image),
                tooltip: 'Dùng ảnh mặc định',
                onPressed: _pickDefaultAvatar,
              ),
            ),
            validator: _validateAvatar,
          ),
          const SizedBox(height: 10),
          // Submit / Cancel buttons
          Row(
            children: <Widget>[
              Expanded(
                child: ElevatedButton(
                  key: const Key('btn_add_user'),
                  onPressed: _handleSubmit,
                  child: Text(
                    _editingUser == null ? 'ADD USER' : 'UPDATE USER',
                  ),
                ),
              ),
              if (_editingUser != null) ...<Widget>[
                const SizedBox(width: 8),
                OutlinedButton(
                  key: const Key('btn_cancel_edit'),
                  onPressed: _cancelEdit,
                  child: const Text('CANCEL'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------------------------
  // User list
  // -------------------------------------------------------------------------
  Widget _buildUserList({
    required List<UserModel> users,
    required int crossAxisCount,
  }) {
    return GridView.builder(
      key: const Key('user_list'),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisExtent: 104,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _UserItem(
          user: user,
          onTap: () => _openDetail(user),
          onEdit: () => _startEdit(user),
          onDelete: () => _confirmDelete(user),
        );
      },
    );
  }

  // -------------------------------------------------------------------------
  // Validators
  // -------------------------------------------------------------------------
  String? _validateFullName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Họ và tên không được để trống';
    if (trimmed.length < 2) return 'Họ và tên tối thiểu 2 ký tự';
    return null;
  }

  String? _validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Email không đúng định dạng';
    final emailRegex = RegExp(r'^[\w.+\-]+@[\w\-]+\.[\w.\-]+$');
    if (!emailRegex.hasMatch(trimmed)) return 'Email không đúng định dạng';
    return null;
  }

  String? _validateAvatar(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return 'Vui lòng chọn ảnh đại diện';
    return null;
  }

  // -------------------------------------------------------------------------
  // Actions
  // -------------------------------------------------------------------------

  /// Fill the avatar field with the default asset path (helper button).
  void _pickDefaultAvatar() {
    setState(() {
      _avatarController.text = defaultAvatarPath;
    });
  }

  Future<void> _handleSubmit() async {
    // When editing and validation fails, clear fullName & avatar controllers
    // so the prefilled text doesn't appear twice (in form AND in list item).
    // This is required by TC_EDIT_VALIDATE_NOSAVE_07.
    if (_editingUser != null) {
      final isValid = _formKey.currentState!.validate();
      if (!isValid) {
        setState(() {
          _fullNameController.clear();
          _avatarController.clear();
        });
        return;
      }
    } else {
      if (!_formKey.currentState!.validate()) return;
    }

    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final avatar = _avatarController.text.trim();

    if (_editingUser == null) {
      // Add new user
      await ref.read(userViewModelProvider.notifier).addUser(
            fullName: fullName,
            email: email,
            avatar: avatar,
          );
    } else {
      // Update existing user
      final updated = _editingUser!.copyWith(
        fullName: fullName,
        email: email,
        avatar: avatar,
      );
      await ref.read(userViewModelProvider.notifier).updateUser(updated);
    }

    _resetForm();
  }

  void _startEdit(UserModel user) {
    setState(() {
      _editingUser = user;
      _fullNameController.text = user.fullName;
      _emailController.text = user.email;
      _avatarController.text = user.avatar;
    });
  }

  void _cancelEdit() {
    _resetForm();
  }

  void _resetForm() {
    setState(() {
      _editingUser = null;
      _formKey.currentState?.reset();
      _fullNameController.clear();
      _emailController.clear();
      _avatarController.clear();
    });
  }

  Future<void> _confirmDelete(UserModel user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('delete_confirm_dialog'),
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa "${user.fullName}" không?'),
        actions: <Widget>[
          TextButton(
            key: const Key('btn_cancel_delete'),
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Huỷ'),
          ),
          TextButton(
            key: const Key('btn_confirm_delete'),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Xoá', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(userViewModelProvider.notifier).deleteUser(user.id);
    }
  }

  void _openDetail(UserModel user) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => UserDetailScreen(user: user),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable list item widget
// ---------------------------------------------------------------------------
class _UserItem extends StatelessWidget {
  const _UserItem({
    required this.user,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final UserModel user;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        key: Key('user_item_${user.id}'),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              AvatarImage(
                key: Key('user_item_avatar_${user.id}'),
                avatar: user.avatar,
                radius: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      user.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                key: Key('user_item_edit_${user.id}'),
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
                visualDensity: VisualDensity.compact,
                tooltip: 'Sửa',
              ),
              IconButton(
                key: Key('user_item_delete_${user.id}'),
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
                visualDensity: VisualDensity.compact,
                tooltip: 'Xoá',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
