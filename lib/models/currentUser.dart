
class currentUser{

  final String uid;

  currentUser({required this.uid});

}

class UserData{
  final String uid,firstName, lastName, email,password,phoneNum;
  UserData({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNum
  });
}