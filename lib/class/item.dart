class Item {
  late List<dynamic> weights;
  late String id;

  Item({required this.weights});

  void standardized() {
    if (weights.length < 5) {
      for (int i = weights.length; i < 5; i++) {
        weights.add(0);
      }
    }
  }

  double total() {
    double total = 0;
    for (var weight in weights) {
      total += double.parse(weight.toString());
    }
    return total;
  }

  bool isEmty() {
    for (int i = 0; i < 5; i++) {
      if (weights[i] == 0.0) return false;
    }
    return true;
  }

  void add(double value) {
    for (int i = 0; i < 5; i++) {
      if (weights[i] == 0) {
        weights[i] = value;
        return;
      }
    }
  }

  Item.fromJson(json) : weights = json['weight'];
}
