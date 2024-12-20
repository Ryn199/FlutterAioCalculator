import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthStateInitial()) {
    // Emit state loading saat proses login dimulai
    FirebaseAuth auth = FirebaseAuth.instance; // Inisialisasi FirebaseAuth
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    on<AuthEventLogin>((event, emit) async {
      try {
        emit(AuthStateLoading());
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );

        // Cek apakah pengguna sudah ada di Firestore
        DocumentSnapshot userDoc =
            await users.doc(userCredential.user!.uid).get();

        if (!userDoc.exists) {
          
          await users.doc(userCredential.user!.uid).set({
            'email': userCredential.user!.email,
            'uid': userCredential.user!.uid,
            'name': userCredential.user!.displayName,
            'photoUrl': userCredential.user!.photoURL,
            'createAt': Timestamp.now(),
            'lastLoginAt': Timestamp.now(),
          });
        } else {
          
          await users.doc(userCredential.user!.uid).set({
            'lastLoginAt': Timestamp.now(),
          }, SetOptions(merge: true)); 
        }

        emit(AuthStateLoaded());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user tidak ditemukan') {
          emit(AuthStateError(message: 'tidak ada user dengan email tersebut.'));
        } else if (e.code == 'password salah') {
          emit(AuthStateError(
              message: 'Password Salah.'));
        } else {
          emit(AuthStateError(message: 'Login Gagal, Username atau passwprd salah'));
        }
      } catch (e) {
        emit(AuthStateError(
            message: 'An unknown error occurred: ${e.toString()}'));
      }
    });

    on<AuthEventRegister>((event, emit) async {
  try {
    emit(AuthStateLoading());
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: event.email,
      password: event.password,
    );

    // Simpan data pengguna baru di Firestore
    await users.doc(userCredential.user!.uid).set({
      'email': event.email,
      'uid': userCredential.user!.uid,
      'photoUrl': userCredential.user!.photoURL,
      'createAt': Timestamp.now(),
      'lastLoginAt': Timestamp.now(),
    });

    emit(AuthStateLoaded());
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      emit(AuthStateError(message: 'Email sudah digunakan.'));
    } else if (e.code == 'weak-password') {
      emit(AuthStateError(message: 'Password terlalu lemah.'));
    } else {
      emit(AuthStateError(message: 'Registrasi gagal: ${e.message}'));
    }
  } catch (e) {
    emit(AuthStateError(
        message: 'An unknown error occurred: ${e.toString()}'));
  }
});

  }
}