String getGreeting() {
  final hour = DateTime.now().hour;

  if (hour >= 5 && hour < 12) {
    return "Good Morning";
  } else if (hour >= 12 && hour < 16) {
    return "Good Afternoon";
  } else if (hour >= 16 && hour < 21) {
    return "Good Evening";
  } else {
    return "Good Night";
  }
}
