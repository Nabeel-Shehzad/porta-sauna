// ignore_for_file: avoid_print

encryptPassword(String password) {
  final pass =
      '$password\$'; //adding additonal $ at the end for basic encryption. better than saving direct pass to db

  return pass;
}

decryptPassword(String password) {
  final pass = password.substring(
      0,
      password.length -
          1); //removing the last character, because as encryption a $ was added with password when saved to db

  print('decrypted pass $pass');
  return pass;
}
