import '../../models/user_model.dart';

abstract interface class UserRepository {
  Future<UserModel> getById (int id);
}