import 'package:flutter/material.dart';
import 'package:learner_space_app/Data/Models/UserModel.dart';
import 'package:learner_space_app/State/auth_provider.dart';
import 'package:provider/provider.dart';

class UserSignup extends StatefulWidget {
  const UserSignup({super.key});

  @override
  State<UserSignup> createState() => _UserSignupState();
}

class _UserSignupState extends State<UserSignup> {
  bool isObscured = true;
  int step = 1;

  // Step 1 Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController reenterPasswordController =
      TextEditingController();

  // Step 2 Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    reenterPasswordController.dispose();
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  void nextStep() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = reenterPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please fill all fields.")));
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    setState(() {
      step = 2;
    });
  }

  void signup(AuthProvider authProvider) async {
    final firstName = firstNameController.text.trim();
    final middleName = middleNameController.text.trim();
    final lastName = lastNameController.text.trim();
    final age = ageController.text.trim();
    final phone = phoneNumberController.text.trim();

    if (firstName.isEmpty || lastName.isEmpty || age.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    final user = UserSignUpFormValues(
      firstName: firstName,
      middleName: middleName,
      lastName: lastName,
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: passwordController.text.trim(),
      age: int.parse(age),
      number: int.parse(phoneNumberController.text),
    );

    await authProvider.signup(context, user);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Stack(
            children: [
              // background
              Column(
                children: [
                  Container(height: size.height * 0.5, color: Colors.orange),
                  Container(height: size.height * 0.5, color: Colors.white),
                ],
              ),

              // form card
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      step == 1 ? "Create Account" : "Personal Details",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: size.width * 0.9,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: step == 1
                            ? _buildStep1(isLoading)
                            : _buildStep2(isLoading, authProvider),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // STEP 1 UI
  Widget _buildStep1(bool isLoading) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 1: Account Information",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),

        const Text("Email"),
        const SizedBox(height: 5),
        TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter Your Email",
          ),
        ),

        const SizedBox(height: 16),

        const Text("Password"),
        const SizedBox(height: 5),
        TextField(
          controller: passwordController,
          obscureText: isObscured,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Enter Your Password",
            suffixIcon: IconButton(
              icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility),
              onPressed: () {
                setState(() {
                  isObscured = !isObscured;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 16),

        const Text("Re-enter Password"),
        const SizedBox(height: 5),
        TextField(
          controller: reenterPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Re-enter Your Password",
          ),
        ),

        const SizedBox(height: 24),

        GestureDetector(
          onTap: isLoading ? null : nextStep,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Center(
              child: isLoading
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  // STEP 2 UI
  Widget _buildStep2(bool isLoading, AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Step 2: Personal Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 20),

        const Text("First Name"),
        const SizedBox(height: 5),
        TextField(
          controller: firstNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter Your First Name",
          ),
        ),

        const SizedBox(height: 16),

        const Text("Middle Name (Optional)"),
        const SizedBox(height: 5),
        TextField(
          controller: middleNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter Your Middle Name",
          ),
        ),

        const SizedBox(height: 16),

        const Text("Last Name"),
        const SizedBox(height: 5),
        TextField(
          controller: lastNameController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter Your Last Name",
          ),
        ),

        const SizedBox(height: 16),

        const Text("Age"),
        const SizedBox(height: 5),
        TextField(
          controller: ageController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter Your Age",
          ),
        ),

        const SizedBox(height: 16),

        const Text("Phone Number"),
        const SizedBox(height: 5),
        TextField(
          controller: phoneNumberController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Enter Your Phone Number",
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => setState(() => step = 1),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: const Center(
                    child: Text(
                      "Back",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: isLoading ? null : () => signup(authProvider),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
