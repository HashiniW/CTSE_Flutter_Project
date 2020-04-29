class FruitSliderModel {
  String img;
  String name;

  FruitSliderModel(
      {this.img,
        this.name});

  FruitSliderModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['img'] = this.img;
    data['name'] = this.name;
    return data;
  }
}