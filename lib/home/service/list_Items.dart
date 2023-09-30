class ListItems {

  static List<String> bloodGroup = [ "AB+",
    "A+",
    "B+",
    "O+",
    "AB-",
    "A-",
    "B-",
    'O-',];
  static List<String> naal = [  "Ashwathi",
    "Bharani",
    "Kaarthika",
    "Rohini",
    "Makeeryam",
    "Thiruvaathira",
    "Punartham",
    'Pooyam',
    'Aayilyam',
    "Makam",
    "Pooram",
    "Uthram",
    "Attham",
    "Chithra",
    "Chothi",
    "Vishaakham",
    'Anizham',
    "Thrukketta",
    "Moolam",
    "Pooraadam",
    "Uthraadam",
    "Thiruvonam",
    "Avittam",
    "Chathayam",
    "Poorooruttaathi",
    "Uthrattaathi",
    "Revathi", ];


  static List<String> relation = [  "Father",
    "Mother",
    "Wife",
    "Husband",
    "Daughter",
    "Son",
    "Grand Child",
    'Grand Parents',
    'Sister',
    'Brother'];
}

// date_utils.dart

String getMonthName(int month) {
  switch (month) {
    case 1:
      return 'January';
    case 2:
      return 'February';
    case 3:
      return 'March';
    case 4:
      return 'April';
    case 5:
      return 'May';
    case 6:
      return 'June';
    case 7:
      return 'July';
    case 8:
      return 'August';
    case 9:
      return 'September';
    case 10:
      return 'October';
    case 11:
      return 'November';
    case 12:
      return 'December';
    default:
      return '';
  }
}
