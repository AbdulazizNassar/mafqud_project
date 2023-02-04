
class User{

  final String uid;

  User({required this.uid});

}

class UserData{
  final String firstName, lastName, email,password,phoneNum;
  UserData({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.phoneNum
  });
}