import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential> signInWithGoogle() async {
  // Inicia o fluxo de autenticação
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtém os detalhes de autenticação
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Cria uma nova credencial
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Após o login bem-sucedido, retorna a credencial do usuário
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
