class Data {
  String image;
  String title;
  String text;

  Data({required this.image, required this.title, required this.text});

  static List<Data> data() {
    return [
      Data(
        image: "assets/images/welcome.png",
        title: "Find Trusted Doctors",
        text:
            "Access a network of verified healthcare experts.\nFind trusted doctors near you with ease.\nYour health journey starts here.",
      ),

      Data(
        image: "assets/images/welcome1.png",
        title: "Choose Best Doctors",
        text:
            "Explore detailed profiles and patient feedback.\nSelect the specialist that matches your needs.\nQuality care is just a tap away.",
      ),

      Data(
        image: "assets/images/welcome2.png",
        title: "Easy Appointments",
        text:
            "Schedule visits anytime, anywhere.\nSkip long waiting times and manage bookings effortlessly.\nStay on top of your healthcare with smart reminders.",
      ),
    ];
  }
}
