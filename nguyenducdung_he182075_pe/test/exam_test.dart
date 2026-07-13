import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

// Đảm bảo các tệp/class này tồn tại trong lib/ của sinh viên (xem SPEC_UserManager_Contract.md)
import '../lib/models/user.dart';
import '../lib/repositories/user_repository.dart';
import '../lib/viewmodels/user_view_model.dart';
import '../lib/screens/user_list_screen.dart';
import '../lib/screens/user_detail_screen.dart';

// ============================================================================
// FAKE REPOSITORY — giả lập kho dữ liệu người dùng trong bộ nhớ.
// Sinh viên không cần biết/viết class này. Có ghi lại lịch sử gọi hàm (calls)
// để verify side-effect, tránh trường hợp sinh viên tự sửa state cục bộ mà
// không thực sự gọi qua repository.
// ============================================================================
class FakeUserRepository implements UserRepository {
  FakeUserRepository([List<UserModel>? seed]) : _users = List.of(seed ?? []);
  final List<UserModel> _users;

  final List<UserModel> addUserCalls = [];
  final List<UserModel> updateUserCalls = [];
  final List<int> deleteUserCalls = [];

  @override
  Future<List<UserModel>> getUsers() async => List.of(_users);

  @override
  Future<void> addUser(UserModel user) async {
    addUserCalls.add(user);
    _users.add(user);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    updateUserCalls.add(user);
    final idx = _users.indexWhere((u) => u.id == user.id);
    if (idx != -1) _users[idx] = user;
  }

  @override
  Future<void> deleteUser(int id) async {
    deleteUserCalls.add(id);
    _users.removeWhere((u) => u.id == id);
  }
}

// --- FIXTURE DATA DÙNG CHUNG ---
List<UserModel> _sampleUsers() => [
      const UserModel(id: 1, fullName: 'Nguyễn Văn An', email: 'an.nguyen@gmail.com', avatar: 'https://example.com/a1.png'),
      const UserModel(id: 2, fullName: 'Trần Thị Bình', email: 'binh.tran@gmail.com', avatar: 'https://example.com/a2.png'),
      const UserModel(id: 3, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'https://example.com/a3.png'),
    ];

// --- HELPER PUMP UI ---
Future<FakeUserRepository> _pumpList(
  WidgetTester tester, {
  List<UserModel>? seed,
  Size? size,
}) async {
  if (size != null) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }
  final repo = FakeUserRepository(seed ?? _sampleUsers());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [userRepositoryProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: UserListScreen()),
    ),
  );
  await tester.pumpAndSettle();
  return repo;
}

/// Điền cả 3 field rồi bấm nút Add/Update, dùng chung cho nhiều test.
Future<void> _fillForm(WidgetTester tester, {required String fullName, required String email, required String avatar}) async {
  await tester.enterText(find.byKey(const Key('input_fullname')), fullName);
  await tester.enterText(find.byKey(const Key('input_email')), email);
  await tester.enterText(find.byKey(const Key('input_avatar')), avatar);
}

void main() {
  // ==========================================================================
  // A. MODEL — lib/models/user.dart  (DART_CLASSES / OOP_MODEL)
  // ==========================================================================
  test('TC_UMODEL_01', () {
    const u = UserModel(id: 1, fullName: 'a', email: 'a@a.com', avatar: 'a.png');
    expect(u, isNotNull, reason: 'Khởi tạo UserModel không được crash');
  });

  test('TC_UMODEL_02', () {
    const u = UserModel(id: 7, fullName: 'a', email: 'a@a.com', avatar: 'a.png');
    expect(u.id, 7, reason: 'Field id lưu sai giá trị');
  });

  test('TC_UMODEL_03', () {
    const u = UserModel(id: 1, fullName: 'Nguyễn Văn An', email: 'a@a.com', avatar: 'a.png');
    expect(u.fullName, 'Nguyễn Văn An', reason: 'Field fullName lưu sai giá trị');
  });

  test('TC_UMODEL_04', () {
    const u = UserModel(id: 1, fullName: 'a', email: 'an.nguyen@gmail.com', avatar: 'a.png');
    expect(u.email, 'an.nguyen@gmail.com', reason: 'Field email lưu sai giá trị');
  });

  test('TC_UMODEL_05', () {
    const u = UserModel(id: 1, fullName: 'a', email: 'a@a.com', avatar: 'https://example.com/x.png');
    expect(u.avatar, 'https://example.com/x.png', reason: 'Field avatar lưu sai giá trị');
  });

  test('TC_UMODEL_06', () {
    const u = UserModel(id: 1, fullName: 'A', email: 'a@a.com', avatar: 'a.png');
    final updated = u.copyWith(fullName: 'B');
    expect(updated.fullName, 'B', reason: 'copyWith không cập nhật đúng field fullName');
  });

  test('TC_UMODEL_07', () {
    const u = UserModel(id: 1, fullName: 'A', email: 'a@a.com', avatar: 'a.png');
    final updated = u.copyWith(fullName: 'B');
    expect(updated.id, 1, reason: 'copyWith làm đổi field id trong khi id không được yêu cầu đổi');
  });

  test('TC_UMODEL_08', () {
    const u = UserModel(id: 1, fullName: 'A', email: 'a@a.com', avatar: 'a.png');
    final updated = u.copyWith(fullName: 'B');
    expect(updated.email, 'a@a.com', reason: 'copyWith làm đổi field email trong khi email không được yêu cầu đổi');
  });

  test('TC_UMODEL_09', () {
    const u = UserModel(id: 1, fullName: 'A', email: 'a@a.com', avatar: 'a.png');
    final updated = u.copyWith(fullName: 'B');
    expect(updated.avatar, 'a.png', reason: 'copyWith làm đổi field avatar trong khi avatar không được yêu cầu đổi');
  });

  // ==========================================================================
  // B. REPOSITORY (interface) — lib/repositories/user_repository.dart (ASYNC_FUTURE)
  // ==========================================================================
  test('TC_REPO_01', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final list = await repo.getUsers();
    expect(list.length, 3, reason: 'getUsers phải trả về đúng danh sách hiện có');
  });

  test('TC_REPO_02', () async {
    final repo = FakeUserRepository();
    await repo.addUser(const UserModel(id: 1, fullName: 'A', email: 'a@a.com', avatar: 'a.png'));
    expect((await repo.getUsers()).length, 1, reason: 'addUser phải thêm đúng 1 phần tử');
  });

  test('TC_REPO_03', () async {
    final repo = FakeUserRepository(_sampleUsers());
    await repo.updateUser(const UserModel(id: 2, fullName: 'Đã sửa', email: 'binh.tran@gmail.com', avatar: 'https://example.com/a2.png'));
    final list = await repo.getUsers();
    expect(list.firstWhere((u) => u.id == 2).fullName, 'Đã sửa', reason: 'updateUser phải cập nhật đúng phần tử theo id');
  });

  test('TC_REPO_04', () async {
    final repo = FakeUserRepository(_sampleUsers());
    await repo.deleteUser(2);
    final list = await repo.getUsers();
    expect(list.any((u) => u.id == 2), isFalse, reason: 'deleteUser phải loại bỏ đúng phần tử theo id');
  });

  // ==========================================================================
  // C. VIEWMODEL — LOAD (STATE_BASIC)
  // ==========================================================================
  test('TC_VM_LOAD_01', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    expect(vm.state.items.length, 3, reason: 'ViewModel phải tự gọi loadUsers() ngay trong constructor');
  });

  test('TC_VM_LOAD_02', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    expect(vm.state.isLoading, isFalse, reason: 'isLoading phải là false sau khi load xong');
  });

  test('TC_VM_LOAD_03', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    expect(vm.state.items.map((u) => u.id).toSet(), {1, 2, 3}, reason: 'Danh sách users trong state phải khớp dữ liệu từ repository');
  });

  // ==========================================================================
  // D. VIEWMODEL — ADD (DART_COLLECTIONS / STATE_LIFTING)
  // ==========================================================================
  test('TC_VM_ADD_01', () async {
    final repo = FakeUserRepository(_sampleUsers()); // id lớn nhất hiện có = 3
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    await vm.addUser(fullName: 'Người mới', email: 'moi@gmail.com', avatar: 'a.png');
    final added = vm.state.items.firstWhere((u) => u.fullName == 'Người mới');
    expect(added.id, 4, reason: 'id mới phải bằng id lớn nhất hiện có + 1');
  });

  test('TC_VM_ADD_02', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    await vm.addUser(fullName: 'Người mới', email: 'moi@gmail.com', avatar: 'a.png');
    expect(vm.state.items.length, 4, reason: 'addUser phải tăng số phần tử trong state thêm 1');
  });

  test('TC_VM_ADD_03', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    await vm.addUser(fullName: 'Người mới', email: 'moi@gmail.com', avatar: 'a.png');
    expect(repo.addUserCalls.length, 1, reason: 'addUser trên ViewModel phải thực sự gọi repository.addUser (không chỉ sửa state cục bộ)');
    expect(repo.addUserCalls.first.fullName, 'Người mới', reason: 'repository.addUser phải được gọi với đúng dữ liệu người dùng mới');
  });

  // ==========================================================================
  // E. VIEWMODEL — UPDATE (STATE_LIFTING)
  // ==========================================================================
  test('TC_VM_UPD_01', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    final target = vm.state.items.firstWhere((u) => u.id == 2);
    await vm.updateUser(target.copyWith(fullName: 'Đã sửa'));
    expect(vm.state.items.firstWhere((u) => u.id == 2).fullName, 'Đã sửa', reason: 'updateUser phải cập nhật đúng field trong state');
  });

  test('TC_VM_UPD_02', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    final target = vm.state.items.firstWhere((u) => u.id == 2);
    await vm.updateUser(target.copyWith(fullName: 'Đã sửa'));
    expect(repo.updateUserCalls.length, 1, reason: 'updateUser trên ViewModel phải thực sự gọi repository.updateUser');
    expect(repo.updateUserCalls.first.id, 2, reason: 'repository.updateUser phải được gọi với đúng id');
  });

  test('TC_VM_UPD_03', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    final target = vm.state.items.firstWhere((u) => u.id == 2);
    await vm.updateUser(target.copyWith(fullName: 'Đã sửa'));
    expect(vm.state.items.firstWhere((u) => u.id == 1).fullName, 'Nguyễn Văn An', reason: 'Sửa user id=2 không được làm đổi user id=1');
    expect(vm.state.items.length, 3, reason: 'updateUser không được làm thay đổi số lượng phần tử');
  });

  // ==========================================================================
  // F. VIEWMODEL — DELETE (STATE_LIFTING)
  // ==========================================================================
  test('TC_VM_DEL_01', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    await vm.deleteUser(2);
    expect(vm.state.items.any((u) => u.id == 2), isFalse, reason: 'deleteUser phải xoá đúng phần tử khỏi state');
    expect(vm.state.items.length, 2, reason: 'deleteUser phải giảm đúng 1 phần tử');
  });

  test('TC_VM_DEL_02', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    await vm.deleteUser(2);
    expect(repo.deleteUserCalls, contains(2), reason: 'deleteUser trên ViewModel phải thực sự gọi repository.deleteUser với đúng id');
  });

  test('TC_VM_DEL_03', () async {
    final repo = FakeUserRepository(_sampleUsers());
    final vm = UserViewModel(repo);
    await Future<void>.delayed(Duration.zero);
    for (final u in List.of(vm.state.items)) {
      await vm.deleteUser(u.id);
    }
    expect(vm.state.items, isEmpty, reason: 'Xoá hết user phải không lỗi và list phải rỗng');
  });

  // ==========================================================================
  // G1. FORM — TỒN TẠI WIDGET (mỗi field/nút = 1 test riêng)
  // ==========================================================================
  testWidgets('TC_FORM_EXIST_01', (tester) async {
    await _pumpList(tester, seed: []);
    expect(find.byKey(const Key('input_fullname')), findsOneWidget, reason: 'Thiếu ô nhập họ và tên (Key: input_fullname)');
  });

  testWidgets('TC_FORM_EXIST_02', (tester) async {
    await _pumpList(tester, seed: []);
    expect(find.byKey(const Key('input_email')), findsOneWidget, reason: 'Thiếu ô nhập email (Key: input_email)');
  });

  testWidgets('TC_FORM_EXIST_03', (tester) async {
    await _pumpList(tester, seed: []);
    expect(find.byKey(const Key('input_avatar')), findsOneWidget, reason: 'Thiếu ô nhập avatar (Key: input_avatar)');
  });

  testWidgets('TC_FORM_EXIST_04', (tester) async {
    await _pumpList(tester, seed: []);
    expect(find.text('ADD USER'), findsOneWidget, reason: 'Thiếu nút "ADD USER"');
  });

  // ==========================================================================
  // G2. FORM — NHẬP ĐƯỢC DỮ LIỆU (mỗi field = 1 test riêng)
  // ==========================================================================
  testWidgets('TC_FORM_INPUT_01', (tester) async {
    await _pumpList(tester, seed: []);
    await tester.enterText(find.byKey(const Key('input_fullname')), 'Nguyễn Văn A');
    await tester.pump();
    expect(find.text('Nguyễn Văn A'), findsOneWidget, reason: 'Ô fullName phải hiển thị đúng nội dung vừa gõ');
  });

  testWidgets('TC_FORM_INPUT_02', (tester) async {
    await _pumpList(tester, seed: []);
    await tester.enterText(find.byKey(const Key('input_email')), 'a.nguyen@gmail.com');
    await tester.pump();
    expect(find.text('a.nguyen@gmail.com'), findsOneWidget, reason: 'Ô email phải hiển thị đúng nội dung vừa gõ');
  });

  testWidgets('TC_FORM_INPUT_03', (tester) async {
    await _pumpList(tester, seed: []);
    await tester.enterText(find.byKey(const Key('input_avatar')), 'https://example.com/x.png');
    await tester.pump();
    expect(find.text('https://example.com/x.png'), findsOneWidget, reason: 'Ô avatar phải hiển thị đúng nội dung vừa gõ');
  });

  // ==========================================================================
  // G3. FORM — VALIDATE (mỗi quy tắc = 1 test riêng)
  // ==========================================================================
  testWidgets('TC_FORM_VALID_01', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: '', email: 'a@a.com', avatar: 'https://example.com/x.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Họ và tên không được để trống'), findsOneWidget, reason: 'Bỏ trống họ tên phải hiện đúng thông báo lỗi');
  });

  testWidgets('TC_FORM_VALID_02', (tester) async {
    final repo = await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: '', email: 'a@a.com', avatar: 'https://example.com/x.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('user_list')).evaluate().isNotEmpty, isTrue);
    expect(repo.addUserCalls, isEmpty, reason: 'Khi validate fail, KHÔNG được gọi repository.addUser');
    expect(find.byKey(const Key('user_item_1')), findsNothing, reason: 'Khi validate fail, KHÔNG được thêm user vào danh sách');
  });

  testWidgets('TC_FORM_VALID_03', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'A', email: 'a@a.com', avatar: 'https://example.com/x.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Họ và tên tối thiểu 2 ký tự'), findsOneWidget, reason: 'Họ tên 1 ký tự phải bị chặn bởi business rule độ dài tối thiểu');
  });

  testWidgets('TC_FORM_VALID_04', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Nguyễn Văn A', email: 'khong-hop-le', avatar: 'https://example.com/x.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Email không đúng định dạng'), findsOneWidget, reason: 'Email sai định dạng phải bị chặn');
  });

  testWidgets('TC_FORM_VALID_05', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Nguyễn Văn A', email: 'a@a.com', avatar: '');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Vui lòng chọn ảnh đại diện'), findsOneWidget, reason: 'Chưa nhập/chọn avatar phải bị chặn (avatar bắt buộc theo đề)');
  });

  // ==========================================================================
  // G4. FORM — THÊM THÀNH CÔNG
  // ==========================================================================
  testWidgets('TC_FORM_SUBMIT_01', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Phạm Thị D', email: 'd.pham@gmail.com', avatar: 'https://example.com/d.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Phạm Thị D'), findsOneWidget, reason: 'Thêm hợp lệ phải hiển thị đúng user mới trong danh sách');
  });

  testWidgets('TC_FORM_SUBMIT_02', (tester) async {
    final repo = await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Phạm Thị D', email: 'd.pham@gmail.com', avatar: 'https://example.com/d.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(repo.addUserCalls.length, 1, reason: 'Thêm hợp lệ phải gọi repository.addUser đúng 1 lần (không chỉ sửa UI)');
  });

  testWidgets('TC_FORM_SUBMIT_03', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Phạm Thị D', email: 'd.pham@gmail.com', avatar: 'https://example.com/d.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byKey(const Key('input_fullname')));
    expect(field.controller?.text ?? '', isEmpty, reason: 'Ô fullName phải reset về rỗng sau khi thêm thành công');
  });

  testWidgets('TC_FORM_SUBMIT_04', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Phạm Thị D', email: 'd.pham@gmail.com', avatar: 'https://example.com/d.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byKey(const Key('input_email')));
    expect(field.controller?.text ?? '', isEmpty, reason: 'Ô email phải reset về rỗng sau khi thêm thành công');
  });

  testWidgets('TC_FORM_SUBMIT_05', (tester) async {
    await _pumpList(tester, seed: []);
    await _fillForm(tester, fullName: 'Phạm Thị D', email: 'd.pham@gmail.com', avatar: 'https://example.com/d.png');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byKey(const Key('input_avatar')));
    expect(field.controller?.text ?? '', isEmpty, reason: 'Ô avatar phải reset về rỗng sau khi thêm thành công');
  });

  // ==========================================================================
  // H. UI — HIỂN THỊ DANH SÁCH (UI_LISTS / NAV_BASIC)
  // ==========================================================================
  testWidgets('TC_LIST_01', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    expect(find.byKey(const Key('user_item_1')), findsOneWidget);
    expect(find.byKey(const Key('user_item_2')), findsOneWidget);
    expect(find.byKey(const Key('user_item_3')), findsOneWidget);
  });

  testWidgets('TC_LIST_AVATAR_02', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 5, fullName: 'Test Name', email: 'test@x.com', avatar: 'a.png')]);
    expect(find.byKey(const Key('user_item_avatar_5')), findsOneWidget, reason: 'Item phải hiển thị avatar');
  });

  testWidgets('TC_LIST_FULLNAME_03', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 5, fullName: 'Test Name', email: 'test@x.com', avatar: 'a.png')]);
    expect(find.text('Test Name'), findsOneWidget, reason: 'Item phải hiển thị đúng fullName');
  });

  testWidgets('TC_LIST_EMAIL_04', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 5, fullName: 'Test Name', email: 'test@x.com', avatar: 'a.png')]);
    expect(find.text('test@x.com'), findsOneWidget, reason: 'Item phải hiển thị đúng email');
  });

  testWidgets('TC_LIST_EDITBTN_05', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 5, fullName: 'Test', email: 'a@a.com', avatar: 'a.png')]);
    expect(find.byKey(const Key('user_item_edit_5')), findsOneWidget, reason: 'Item phải có nút Edit');
  });

  testWidgets('TC_LIST_DELBTN_06', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 5, fullName: 'Test', email: 'a@a.com', avatar: 'a.png')]);
    expect(find.byKey(const Key('user_item_delete_5')), findsOneWidget, reason: 'Item phải có nút Delete');
  });

  testWidgets('TC_LIST_EMPTY_07', (tester) async {
    await _pumpList(tester, seed: []);
    expect(find.byKey(const Key('user_list')), findsOneWidget, reason: 'Danh sách rỗng vẫn phải render, không crash');
  });

  testWidgets('TC_LIST_NAV_08', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 5, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'a.png')]);
    await tester.tap(find.text('Lê Minh Cường'));
    await tester.pumpAndSettle();
    expect(find.byType(UserDetailScreen), findsOneWidget, reason: 'Tap vào item (không phải nút Edit/Delete) phải mở UserDetailScreen');
  });

  // ==========================================================================
  // I. LAYOUT & RESPONSIVE (LAYOUT_FLEX / LAYOUT_GRID / LAYOUT_RESPONSIVE)
  // ==========================================================================
  testWidgets('TC_LAYOUT_01', (tester) async {
    await _pumpList(tester, seed: _sampleUsers(), size: const Size(400, 800));
    final gridFinder = find.byType(GridView);
    if (gridFinder.evaluate().isNotEmpty) {
      final grid = tester.widget<GridView>(gridFinder);
      final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 1, reason: 'Portrait phải hiển thị danh sách 1 cột');
    } else {
      expect(find.byType(ListView), findsOneWidget, reason: 'Portrait phải dùng ListView hoặc GridView 1 cột');
    }
  });

  testWidgets('TC_LAYOUT_02', (tester) async {
    await _pumpList(tester, seed: _sampleUsers(), size: const Size(800, 400));
    final grid = tester.widget<GridView>(find.byType(GridView));
    final delegate = grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 2, reason: 'Landscape phải hiển thị danh sách 2 cột');
  });

  testWidgets('TC_LAYOUT_03', (tester) async {
    await _pumpList(tester, seed: _sampleUsers(), size: const Size(400, 800));
    tester.view.physicalSize = const Size(800, 400);
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(400, 800);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull, reason: 'Đổi kích thước liên tục không được ném exception (overflow, v.v.)');
  });

  // ==========================================================================
  // J. UI — SỬA NGƯỜI DÙNG (STATE_LIFTING / FORM_VALIDATE)
  // ==========================================================================
  testWidgets('TC_EDIT_PREFILL_FULLNAME_01', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byKey(const Key('input_fullname')));
    expect(field.controller?.text, 'Trần Thị Bình', reason: 'Bấm Edit phải điền sẵn đúng fullName hiện tại của user');
  });

  testWidgets('TC_EDIT_PREFILL_EMAIL_02', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byKey(const Key('input_email')));
    expect(field.controller?.text, 'binh.tran@gmail.com', reason: 'Bấm Edit phải điền sẵn đúng email hiện tại của user');
  });

  testWidgets('TC_EDIT_PREFILL_AVATAR_03', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    final field = tester.widget<TextFormField>(find.byKey(const Key('input_avatar')));
    expect(field.controller?.text, 'https://example.com/a2.png', reason: 'Bấm Edit phải điền sẵn đúng avatar hiện tại của user');
  });

  testWidgets('TC_EDIT_SAVE_04', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('input_fullname')), 'Trần Thị Bình Đã Sửa');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Trần Thị Bình Đã Sửa'), findsOneWidget, reason: 'Sau khi lưu, danh sách phải hiển thị đúng dữ liệu mới');
  });

  testWidgets('TC_EDIT_SAVE_REPO_05', (tester) async {
    final repo = await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('input_fullname')), 'Trần Thị Bình Đã Sửa');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(repo.updateUserCalls.length, 1, reason: 'Lưu sau khi sửa phải gọi repository.updateUser đúng 1 lần');
    expect(repo.updateUserCalls.first.id, 2, reason: 'repository.updateUser phải được gọi với đúng id của user đang sửa');
  });

  testWidgets('TC_EDIT_VALIDATE_06', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('input_email')), 'khong-hop-le');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Email không đúng định dạng'), findsOneWidget, reason: 'Sửa với email không hợp lệ phải báo lỗi');
  });

  testWidgets('TC_EDIT_VALIDATE_NOSAVE_07', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('input_email')), 'khong-hop-le');
    await tester.tap(find.byKey(const Key('btn_add_user')));
    await tester.pumpAndSettle();
    expect(find.text('Trần Thị Bình'), findsOneWidget, reason: 'Khi validate fail, dữ liệu cũ trong danh sách KHÔNG được ghi đè bởi dữ liệu sai');
  });

  testWidgets('TC_EDIT_CANCEL_08', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_edit_2')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('input_fullname')), 'Tên bị sửa nháp');
    await tester.tap(find.byKey(const Key('btn_cancel_edit')));
    await tester.pumpAndSettle();
    expect(find.text('Trần Thị Bình'), findsOneWidget, reason: 'Huỷ sửa phải giữ nguyên dữ liệu cũ trong danh sách');
    expect(find.text('Tên bị sửa nháp'), findsNothing, reason: 'Huỷ sửa không được lưu lại bản nháp đang gõ dở');
  });

  // ==========================================================================
  // K. UI — XOÁ NGƯỜI DÙNG (XÁC NHẬN) (UI_PICKERS)
  // ==========================================================================
  testWidgets('TC_DEL_DIALOG_01', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_delete_2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('delete_confirm_dialog')), findsOneWidget, reason: 'Bấm Delete phải hiện dialog xác nhận trước khi xoá thật');
  });

  testWidgets('TC_DEL_CANCEL_02', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_delete_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('btn_cancel_delete')));
    await tester.pumpAndSettle();
    expect(find.text('Trần Thị Bình'), findsOneWidget, reason: 'Bấm Huỷ trong dialog không được xoá user');
  });

  testWidgets('TC_DEL_CONFIRM_03', (tester) async {
    await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_delete_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('btn_confirm_delete')));
    await tester.pumpAndSettle();
    expect(find.text('Trần Thị Bình'), findsNothing, reason: 'Bấm Xác nhận phải xoá đúng user khỏi danh sách hiển thị');
  });

  testWidgets('TC_DEL_CONFIRM_REPO_04', (tester) async {
    final repo = await _pumpList(tester, seed: _sampleUsers());
    await tester.tap(find.byKey(const Key('user_item_delete_2')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('btn_confirm_delete')));
    await tester.pumpAndSettle();
    expect(repo.deleteUserCalls, contains(2), reason: 'Bấm Xác nhận phải gọi repository.deleteUser với đúng id');
  });

  // ==========================================================================
  // L. UI — XEM CHI TIẾT (NAV_BASIC / UI_WIDGETS)
  // ==========================================================================
  testWidgets('TC_DETAIL_AVATAR_01', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: UserDetailScreen(user: UserModel(id: 3, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'a.png')),
    ));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('detail_avatar')), findsOneWidget, reason: 'DetailScreen phải hiển thị avatar lớn');
  });

  testWidgets('TC_DETAIL_ID_02', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: UserDetailScreen(user: UserModel(id: 3, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'a.png')),
    ));
    await tester.pumpAndSettle();
    final idFinder = find.byKey(const Key('detail_id'));
    expect(idFinder, findsOneWidget, reason: 'DetailScreen phải có widget hiển thị ID (Key: detail_id)');
    // Không giả định Key('detail_id') nằm trực tiếp trên Text hay trên 1 widget bọc ngoài (Container/Padding/...):
    // matchRoot: true cho phép tìm cả chính widget gắn Key lẫn các Text con bên trong nó.
    expect(
      find.descendant(of: idFinder, matching: find.textContaining('3'), matchRoot: true),
      findsWidgets,
      reason: 'DetailScreen phải hiển thị đúng ID (id=3) ở trong hoặc ngay trên widget có Key detail_id',
    );
  });

  testWidgets('TC_DETAIL_FULLNAME_03', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: UserDetailScreen(user: UserModel(id: 3, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'a.png')),
    ));
    await tester.pumpAndSettle();
    expect(find.text('Lê Minh Cường'), findsOneWidget, reason: 'DetailScreen phải hiển thị đúng fullName');
  });

  testWidgets('TC_DETAIL_EMAIL_04', (tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: UserDetailScreen(user: UserModel(id: 3, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'a.png')),
    ));
    await tester.pumpAndSettle();
    expect(find.text('cuong.le@gmail.com'), findsOneWidget, reason: 'DetailScreen phải hiển thị đúng email');
  });

  testWidgets('TC_DETAIL_BACK_05', (tester) async {
    await _pumpList(tester, seed: [const UserModel(id: 3, fullName: 'Lê Minh Cường', email: 'cuong.le@gmail.com', avatar: 'a.png')]);
    await tester.tap(find.text('Lê Minh Cường'));
    await tester.pumpAndSettle();
    expect(find.byType(UserDetailScreen), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.byType(UserListScreen), findsOneWidget, reason: 'Nút Back phải quay lại đúng UserListScreen');
  });

  // ==========================================================================
  // M. KIẾN TRÚC — MVVM + RIVERPOD (STATE_RIVERPOD, chống lách luật)
  // ==========================================================================
  String readLibFile(String path) {
    final f = File(path);
    return f.existsSync() ? f.readAsStringSync() : '';
  }

  test('TC_ARCH_01', () {
    final content = readLibFile('lib/screens/user_list_screen.dart');
    expect(content.isNotEmpty, isTrue, reason: 'Không tìm thấy lib/screens/user_list_screen.dart');
    expect(
      content.contains('extends ConsumerWidget') || content.contains('extends ConsumerStatefulWidget'),
      isTrue,
      reason: 'UserListScreen phải extends ConsumerWidget (hoặc ConsumerStatefulWidget)',
    );
  });

  test('TC_ARCH_02', () {
    final content = readLibFile('lib/screens/user_list_screen.dart');
    expect(content.isNotEmpty, isTrue);
    final hasLocalMasterList = RegExp(r'List<UserModel>\s+_\w+\s*=\s*\[').hasMatch(content) ||
        RegExp(r'List<UserModel>\s+_\w+\s*=\s*<UserModel>\[').hasMatch(content);
    expect(hasLocalMasterList, isFalse,
        reason: 'Không được tự khai báo List<UserModel> cục bộ để lưu danh sách né Riverpod — danh sách phải lấy từ ref.watch(userViewModelProvider)');
  });

  test('TC_ARCH_03', () {
    final content = readLibFile('lib/viewmodels/user_view_model.dart');
    expect(content.isNotEmpty, isTrue, reason: 'Không tìm thấy lib/viewmodels/user_view_model.dart');
    expect(content.contains('extends StateNotifier<UserState>'), isTrue, reason: 'UserViewModel phải extends StateNotifier<UserState>');
  });

  test('TC_ARCH_04', () {
    final content = readLibFile('lib/viewmodels/user_view_model.dart');
    expect(content.isNotEmpty, isTrue);
    expect(
      content.contains('StateNotifierProvider') && content.contains('userViewModelProvider'),
      isTrue,
      reason: 'Phải khai báo userViewModelProvider bằng StateNotifierProvider',
    );
  });

  test('TC_ARCH_05', () {
    final content = readLibFile('lib/screens/user_list_screen.dart');
    expect(content.isNotEmpty, isTrue);
    expect(
      content.contains('ref.watch(userViewModelProvider)') || content.contains('ref.read(userViewModelProvider'),
      isTrue,
      reason: 'UserListScreen phải đọc dữ liệu qua ref.watch/ref.read(userViewModelProvider...)',
    );
  });

  testWidgets('TC_ARCH_06', (tester) async {
    final repo = FakeUserRepository(_sampleUsers());
    final container = ProviderContainer(overrides: [userRepositoryProvider.overrideWithValue(repo)]);
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: UserListScreen()),
      ),
    );
    await tester.pumpAndSettle();

    // Đổi state trực tiếp qua notifier, KHÔNG thông qua thao tác chạm UI.
    await container.read(userViewModelProvider.notifier).addUser(
          fullName: 'Injected Runtime User',
          email: 'inject@test.com',
          avatar: 'a.png',
        );
    await tester.pumpAndSettle();

    expect(
      find.text('Injected Runtime User'),
      findsOneWidget,
      reason: 'Nếu dùng ref.watch đúng chuẩn Riverpod, UI phải tự render lại khi state đổi từ ngoài mà không cần tap',
    );
  });
}
