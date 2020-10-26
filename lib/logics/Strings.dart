class facePageStrings{
  facePageStrings._();
  static const title = "Face Detection";
  static const initialMessage = "No image selected";
  static const imageSelected = "Wait...";
  static const noFaces = "No face was found";
  static const manyFaces = "Too many faces";
}

class homePageStrings{
  homePageStrings._();
  static const title = "Documents";
  static const emptyDocuments = "No documents";
}

class passwordPageStrings{
  passwordPageStrings._();
  static const passwordPattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
  static const pathToGif = "assets/images/unlock.gif";
  static const pathToSound = "assets/sounds/";
  static const soundName = "unlock.mp3";
  static const setIncorrectPassword = "Password must contain at least 1 alphabet and 1 digit";
  static const enterIncorrectPassword = "Incorrect password";
}