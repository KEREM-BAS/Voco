class Transaction {
  int id = 0;
  DateTime? createdAt;
  double amount = 0.0;
  String description = '';
  String company = '';

  Transaction({
    this.id = 0,
    this.createdAt,
    this.amount = 0.0,
    this.description = '',
    this.company = '',
  });
}
