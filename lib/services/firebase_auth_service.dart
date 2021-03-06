import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Firebase_Auth_Service{
    final FirebaseAuth _firebaseAuth;

    Firebase_Auth_Service(this._firebaseAuth);

    Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

    Future<UserCredential?> signIn({String? email, String? password}) async {
        try{
            return await _firebaseAuth.signInWithEmailAndPassword(email: email!, password: password!);
        } on FirebaseAuthException catch (e){
            if (e.code == 'user-not-found') {
                throw Exception('No user found for that email.');
            } else if (e.code == 'wrong-password') {
                throw Exception('Wrong password provided for that user.');
            }
        }
    }

    Future<String?> signUp({String? email, String? password}) async{
        try{
            await _firebaseAuth.createUserWithEmailAndPassword(
                email: email!, password: password!
            );
        }on FirebaseAuthException catch (e){
            if (e.code == 'weak-password') {
                return 'The password provided is too weak.';
            } else if (e.code == 'email-already-in-use') {
                return 'The account already exists for that email.';
            }
            return null;
        } catch (e) {
            print(e);
        }
    }

    Future<UserCredential?> signInWithGoogle() async {
        // Trigger the authentication flow
        try {
            final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

            if (googleUser != null) {
                // Obtain the auth details from the request
                final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;

                // Create a new credential
                final credential = GoogleAuthProvider.credential(
                    accessToken: googleAuth.accessToken,
                    idToken: googleAuth.idToken,
                );

                // Once signed in, return the UserCredential
                return await FirebaseAuth.instance.signInWithCredential(credential);
            }
        } catch (e) {
            print(e);
        }

        return null;
    }

    Future<void> signOut() => _firebaseAuth.signOut();

}
