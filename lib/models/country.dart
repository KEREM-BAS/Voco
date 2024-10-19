class Country {
  String? code;
  String? name;

  Country({
    this.code,
    this.name,
  });

  ///custom comparing function to check if two users are equal
  bool isEqual(Country model) {
    return code == model.code;
  }

  @override
  String toString() => '$name';
}
