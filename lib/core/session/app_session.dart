enum UserRole { guest, user, employee, admin }

class Appointment {
  final String serviceTitle;      
  String subServiceTitle;         
  final String duration;          
  String date;                    
  String time;                    
  String status;                  

  Appointment({
    required this.serviceTitle,
    required this.subServiceTitle,
    required this.duration,
    required this.date,
    required this.time,
    this.status = 'Zakazano',
  });
}

class AppSession {
  static UserRole role = UserRole.guest;
  static String? email;

  // ime korisnika 
  static String? firstName;

  //  “baza”
  static final List<Appointment> appointments = [];

  static bool get isGuest => role == UserRole.guest;
  static bool get isLoggedUser => role == UserRole.user;

  static void login(UserRole newRole, {String? userEmail, String? name}) {
    role = newRole;
    email = userEmail;
    if (name != null && name.trim().isNotEmpty) {
      firstName = name.trim();
    }
  }

  static void logout() {
    role = UserRole.guest;
    email = null;
    firstName = null;
  }
}
