import 'package:firebase_auth/firebase_auth.dart';
import 'package:mkn_bank/models/account_profile.dart';

class AccountService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AccountProfile> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Criando um AccountProfile a partir das informações do usuário registrado
    return AccountProfile(
      accountId: userCredential.user!.uid,
      emailAddress: userCredential.user!.email,
    );
  }

  Future<AccountProfile> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Retornando um AccountProfile para o usuário que fez login
    return AccountProfile(
      accountId: userCredential.user!.uid,
      emailAddress: userCredential.user!.email,
    );
  }

  // Adicione aqui outros métodos conforme necessário
}
