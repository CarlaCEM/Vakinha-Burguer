abstract interface class LoginService {
  Future<void> execute(String email, String password);
  
}