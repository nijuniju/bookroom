import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard.dart';

final ValueNotifier<bool> isLoggedIn = ValueNotifier(false);

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  // Fungsi login ke Firebase dan simpan data user
Future<void> _firebaseLogin(
    BuildContext context, String email, String password) async {
  try {
    UserCredential credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    final uid = credential.user!.uid;

    // Ambil token terbaru
    final token = await FirebaseAuth.instance.currentUser?.getIdToken(true);
    print("Token diperbarui: $token");

    // Cek dan simpan data user ke Firestore kalau belum ada
    final doc = FirebaseFirestore.instance.collection('users').doc(uid);
    if (!(await doc.get()).exists) {
      await doc.set({
        'uid': uid,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    isLoggedIn.value = true;
    Navigator.of(context).pop(); // tutup dialog login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Login berhasil')),
    );
  } on FirebaseAuthException catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Login gagal: ${e.message}')),
    );
  }
}

  void _showLoginDialog(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white.withOpacity(0.95),
        title: const Text('Login'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _firebaseLogin(
                  context, emailController.text, passwordController.text);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg_landing3.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  // Konten utama dengan blur dan info
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Tombol Login / Logout
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable: isLoggedIn,
                                  builder: (context, loggedIn, _) {
                                    return TextButton(
                                      onPressed: () {
                                        if (loggedIn) {
                                          FirebaseAuth.instance.signOut();
                                          isLoggedIn.value = false;
                                        } else {
                                          _showLoginDialog(context);
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        foregroundColor: const Color(0xFF006A4E),
                                      ),
                                      child: Text(loggedIn ? 'LOGOUT' : 'LOGIN'),
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Teks utama
                            Text(
                              'Hello!\nWelcome to BookRoom',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF37474F),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Deskripsi
                            Text(
                              'Kelola dan pantau jadwal peminjaman ruang meeting di satu tempat.',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                                color: const Color(0xFF37474F),
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Tombol Aksi
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {
                                    // Arahkan ke halaman jadwal
                                  },
                                  icon: const Icon(Icons.calendar_today),
                                  label: const Text('Lihat Jadwal'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFCFFFE5),
                                    foregroundColor: const Color(0xFF006A4E),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                OutlinedButton.icon(
                                  onPressed: () {
                                    if (isLoggedIn.value) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                      );
                                    } else {
                                      _showLoginDialog(context);
                                    }
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Tambah Booking'),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFF006A4E),
                                    foregroundColor: const Color(0xFFCFFFE5),
                                    side: const BorderSide(
                                        color: Color(0xFF98FF98)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Logo Watermark di kanan atas
          Positioned(
            top: 16,
            right: 16,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/logo.PNG',
                height: 20,
              ),
            ),
          ),

          // Watermark teks di kiri bawah
          Positioned(
            bottom: 16,
            left: 16,
            child: Opacity(
              opacity: 0.5,
              child: const Text(
                '2025 © IT SUPPORT',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}