extension stringExtensions on String {
  bool isNullOrEmpty(){
    return this == "" || this == null;
  }
}