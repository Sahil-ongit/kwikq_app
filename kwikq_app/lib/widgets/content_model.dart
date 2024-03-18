class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description: 'Pick your food from our menu\n ',
      image: "images/screen1.png",
      title: 'Select from Our\n Best Menu'),
  UnboardingContent(
      description: 'Card payment is available',
      image: "images/screen2.png",
      title: 'Easy and Online Payment')
];
