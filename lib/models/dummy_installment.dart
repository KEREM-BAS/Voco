class DummyInstallment {
  int id = 0;
  String title;
  double rate = 0;

  DummyInstallment({
    this.id = 0,
    this.title = '',
    this.rate = 0,
  });

  @override
  String toString() {
    return id == 1 ? title : '$title ( %$rate )';
  }

  bool isEqual(DummyInstallment model) {
    return id == model.id;
  }
}
