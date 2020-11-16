class CustomFile {
  String _filePath;
  String _fileName;
  String _fileExtension;

  String get filePath => _filePath;

  String get fileName => _fileName;

  String get fileExtension => _fileExtension;

  CustomFile({String filePath, String fileName, String fileExtension}) {
    this._filePath = filePath;
    this._fileName = fileName;
    this._fileExtension = fileExtension;
  }

  bool operator ==(other) {
    if (this._filePath == other.filePath &&
        this._fileName == other.fileName &&
        this._fileExtension == other.fileExtension) {
      return true;
    } else {
      return false;
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}
