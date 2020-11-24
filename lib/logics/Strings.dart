class facePageStrings {
  facePageStrings._();

  static const title = "Face Detection";
  static const initialMessage = "No image selected";
  static const imageSelected = "Wait...";
  static const noFaces = "No face was found";
  static const manyFaces = "Too many faces";
}

class homePageStrings {
  homePageStrings._();

  static const title = "Documents";
  static const emptyDocuments = "No documents";
  static const titleOfDialog = "Decryption...";
  static const pathToGif = "assets/images/loading.gif";
}

class passwordSettingPageStrings {
  passwordSettingPageStrings._();

  static const pattern = r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$";
  static const buttonText = "Set";
  static const passwordDoesntMatchPattern =
      "Password must contain at least 1 alphabet and 1 digit";
  static const pathToImage = "assets/images/lock.png";
}

class passwordEnteringPageStrings {
  passwordEnteringPageStrings._();

  static const buttonText = "Enter";
  static const pathToGif = "assets/images/unlock.gif";
  static const pathToSound = "assets/sounds/";
  static const soundName = "unlock.mp3";
  static const incorrectPasswordMessage = "Incorrect password";
  static const titleOfDialog = "Error";
}
