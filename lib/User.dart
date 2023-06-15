class User {
  late String username;
  late String email;
  late String city;
  late String state;
  late String pincode;
  late String mobile;
  get getMobile => this.mobile;

  set setMobile(mobile) => this.mobile = mobile;
  get getUsername => this.username;

  set setUsername(username) => this.username = username;

  get getEmail => this.email;

  set setEmail(email) => this.email = email;

  get getCity => this.city;

  set setCity(city) => this.city = city;

  get getState => this.state;

  set setState(state) => this.state = state;

  //get getPincode => this.pincode;

  // set setPincode(pincode) => this.pincode = pincode;
}
