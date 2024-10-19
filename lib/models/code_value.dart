class CodeValue {
  int code = 0;
  String? value;

  CodeValue({
    this.code = 0,
    this.value,
  });

  @override
  String toString() {
    return value ?? '';
  }
}
