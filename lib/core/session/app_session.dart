enum UserRole { guest, user, admin }

class AppSession {
  static UserRole role = UserRole.guest;

  static String? uid;
  static String? email;
  static String? firstName;

  static bool get isGuest => role == UserRole.guest;
  static bool get isLoggedUser => role == UserRole.user || role == UserRole.admin;

  static void login({
    required UserRole newRole,
    required String userUid,
    String? userEmail,
    String? name,
  }) {
    role = newRole;
    uid = userUid;
    email = userEmail;
    if (name != null && name.trim().isNotEmpty) {
      firstName = name.trim();
    }
  }

  static void logout() {
    role = UserRole.guest;
    uid = null;
    email = null;
    firstName = null;
  }
}
