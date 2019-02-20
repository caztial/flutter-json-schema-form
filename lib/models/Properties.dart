class Properties {
  String id;
  String type;
  String title;
  dynamic defaultValue;
  bool required;

  Properties({
    this.id,
    this.type,
    this.title,
    this.defaultValue,
    this.required,
  });

  factory Properties.fromJson(String propertyId, Map<String, dynamic> json) {
    return Properties(
      id: propertyId,
      type: json['type'],
      title: json['title'],
      defaultValue: json['default'],
    );
  }
}
