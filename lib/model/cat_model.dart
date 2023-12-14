class Cat {
  final String url;

  Cat({required this.url});

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
    url: json['url'],
  );

  Map<String, dynamic> toJson() => {
    'url': url,
  };
}
