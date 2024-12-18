import 'package:flutter/material.dart';
import 'screens/loading/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Management App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}


// This is a test commit check































// import 'package:flutter/material.dart';
// import 'dart:async';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Gym Management App',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: LoadingScreen(),
//     );
//   }
// }

// // Loading Screen
// class LoadingScreen extends StatefulWidget {
//   @override
//   _LoadingScreenState createState() => _LoadingScreenState();
// }

// class _LoadingScreenState extends State<LoadingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _animationController;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Duration(seconds: 1),
//     )..repeat(reverse: true);

//     // Navigate to LoginScreen after 4 seconds
//     Timer(Duration(seconds: 4), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Center(
//         child: ScaleTransition(
//           scale: Tween(begin: 0.8, end: 1.2).animate(
//             CurvedAnimation(
//               parent: _animationController,
//               curve: Curves.easeInOut,
//             ),
//           ),
//           child: Image.asset(
//             'assets/icons/logo.png', // Make sure your logo is in the assets folder
//             width: 250,
//             height: 250,
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Login Screen
// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//      appBar: AppBar(
//         title: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(
//                   'assets/icons/logo.png',
//                   width: 30,
//                   height: 30,
//                 ),
//                 SizedBox(width: 10),
//                 Text('Level Up'),
//               ],
//             ),
//             SizedBox(height: 10),
//             Divider(thickness: 1, color: Colors.grey[400]),
//           ],
//         ),
//         backgroundColor: Colors.grey[100],
// ),
  
//       body: Container(
        
//         color: Colors.white,
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
            

//             SizedBox(height: 150),
//             Text(
//               'Log in with your Account',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
            

//             SizedBox(height: 50), 
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(
//                 labelText: 'Username',
//                 border: OutlineInputBorder(),
//               ),
//             ),


//             SizedBox(height: 16),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),


//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (context) => QuestionnaireScreen()),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.orange[700], // White text color
//                 minimumSize: Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: Text('Login'),
//             ),
//             SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text("Don't have an account?"),
//                 TextButton(
//                   onPressed: () {
//                     // Add Sign-Up functionality here
//                   },
//                   child: Text(
//                     'Sign up',
//                     style: TextStyle(decoration: TextDecoration.underline),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Questionnaire Screen
// class QuestionnaireScreen extends StatelessWidget {
//   final List<String> questions = [
//     'How many hours of sleep do you get on average per night?',
//     'How would you describe your current diet?',
//     'Do you have any dietary restrictions or allergies?',
//     'How many times per week do you exercise?',
//     'What type of exercises do you prefer (e.g., cardio, strength training)?',
//     'Have you been a member of a gym before?',
//     'Do you have any past or current injuries?',
//     'What are your fitness goals (e.g., weight loss, muscle gain, general health)?',
//     'How much water do you drink daily?',
//     'Do you experience any stress or anxiety frequently?',
//   ];

//  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         titleSpacing: 16.0,
//         title: Padding(
//           padding: const EdgeInsets.only( right: 46.0),
//           child: Center(
//             child: Text(
//               'Client Details Form',
//               style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
//             ),
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(4.0),
//           child: Divider(color: Colors.grey[400], thickness: 1),
//         ),
//         backgroundColor: Colors.grey[200],
// ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
              
//               child: ListView.builder(
//                 itemCount: questions.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 12.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           questions[index],
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
//                         ),
//                         SizedBox(height: 8),
//                         TextField(
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Add submit functionality here
//               },
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.white, backgroundColor: Colors.orange[700],
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

