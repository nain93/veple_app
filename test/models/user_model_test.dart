import 'package:flutter_test/flutter_test.dart';
import 'package:veple/models/user_model.dart';

void main() {
  test('The User instance has a class variable called name', () {
    const user = UserModel(id: '0', email: 'email', password: 'password');
    expect(user.email, 'email');
  });
}
