import 'package:firebase_auth/firebase_auth.dart';
import 'package:mkn_bank/models/account_profile.dart';

class AccountService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AccountProfile> signUp(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

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

    return AccountProfile(
      accountId: userCredential.user!.uid,
      emailAddress: userCredential.user!.email,
    );
  }

}
