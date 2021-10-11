class CompareModel {
  String _image;
  String _name;
  String _price;
  String _id;

  CompareModel(this._image, this._name, this._price, this._id);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get image => _image;

  set image(String value) {
    _image = value;
  }
}
