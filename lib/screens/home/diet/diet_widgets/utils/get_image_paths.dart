List<String> getImagePathsForTiming(String time, String period) {
  // First check if the time belongs to the selected period
  int hour = int.parse(time.split(':')[0]);
  if (time.contains('PM') && hour != 12) hour += 12;
  
  bool isCorrectPeriod = false;
  switch (period) {
    case 'morning':
      isCorrectPeriod = hour >= 6 && hour < 12;
      break;
    case 'afternoon':
      isCorrectPeriod = hour >= 12 && hour < 18;
      break;
    case 'evening':
      isCorrectPeriod = hour >= 18 || hour < 6;
      break;
  }
  
  // If time doesn't belong to selected period, return default image
  if (!isCorrectPeriod) {
    return ['assets/images/diet/timed_food/food.png'];
  }

  // If time belongs to selected period, return appropriate images
  switch (time) {
    // Morning timings
    case '6:00AM':
      return [
        'assets/images/diet/timed_food/6_am/6_am_image1.jpg',
        'assets/images/diet/timed_food/6_am/6_am_image2.jpg',
        'assets/images/diet/timed_food/6_am/6_am_image3.jpg',
      ];

    case '6:30AM':
      return [
        'assets/images/diet/timed_food/6_30_am/6_30_am_image1.jpg',
        'assets/images/diet/timed_food/6_30_am/6_30_am_image2.jpeg',
        'assets/images/diet/timed_food/6_30_am/6_30_am_image3.jpeg'
      ];

    case '8:00AM':
      return [
        'assets/images/diet/detox/8_am/8_am_image1.jpg',
        'assets/images/diet/detox/8_am/8_am_image2.jpg',
      ];

    case '8:30AM':
      return [
        'assets/images/diet/timed_food/8_30_am/8_30_am_image1.jpeg',
        'assets/images/diet/timed_food/8_30_am/8_30_am_image2.jpeg',
        'assets/images/diet/timed_food/8_30_am/8_30_am_image3.jpg',
        'assets/images/diet/timed_food/8_30_am/8_30_am_image4.jpg',
        'assets/images/diet/timed_food/8_30_am/8_30_am_image5.jpg',
        'assets/images/diet/timed_food/8_30_am/8_30_am_image6.jpg',        
      ];

    case '11:00AM':
      return [
        'assets/images/diet/timed_food/11_am/11_am_image1.jpeg',
        'assets/images/diet/timed_food/11_am/11_am_image2.jpg',
        'assets/images/diet/timed_food/11_am/11_am_image3.jpeg',
        'assets/images/diet/timed_food/11_am/11_am_image4.jpeg',
      ];

    // Afternoon timings
    case '1:00PM':
      return [
        'assets/images/diet/timed_food/1_pm/1_pm_image1.jpeg',
        'assets/images/diet/timed_food/1_pm/1_pm_image2.jpeg',
        'assets/images/diet/timed_food/1_pm/1_pm_image3.jpg',
        'assets/images/diet/timed_food/1_pm/1_pm_image4.jpeg',
        'assets/images/diet/timed_food/1_pm/1_pm_image5.jpeg',
      ];

    case '3:00PM':
      return [
        'assets/images/diet/detox/3_pm/3_pm_image1.jpg',

      ];

    case '4:00PM':
      return [
        'assets/images/diet/timed_food/4_pm/4_pm_image1.jpeg',
        'assets/images/diet/timed_food/4_pm/4_pm_image2.jpeg',
        'assets/images/diet/timed_food/4_pm/4_pm_image3.jpeg',        
      ];

    // Evening timings
    case '7:00PM':
      return [
        'assets/images/diet/timed_food/7_pm/7_pm_image1.jpeg',
        'assets/images/diet/timed_food/7_pm/7_pm_image2.jpeg',
        'assets/images/diet/timed_food/7_pm/7_pm_image3.jpeg',
        'assets/images/diet/timed_food/7_pm/7_pm_image4.jpeg',
      ];

    case '9:00PM':
      return [
        'assets/images/diet/timed_food/9_pm/9_pm_image1.jpg',
        'assets/images/diet/timed_food/9_pm/9_pm_image2.jpeg',
      ];

    default:
      return ['assets/images/diet/timed_food/food.png'];
  }
}