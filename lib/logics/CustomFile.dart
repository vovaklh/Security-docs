class CustomFile{
  String filePath;
  String fileName;
  String fileExtension;

  CustomFile({String filePath, String fileName, String fileExtension}){
    this.filePath = filePath;
    this.fileName = fileName;
    this.fileExtension = fileExtension;
  }

  bool operator == (other){
    if (this.filePath == other.filePath && this.fileName == other.fileName && this.fileExtension == other.fileExtension){
      return true;
    }
    else{
      return false;
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;

}