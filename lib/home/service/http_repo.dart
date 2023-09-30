// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
//
// const String familyGet = "https://pattarya.besocial.pro/api/v1/getTableDatas?table=family_members&where=uid&value=$uid";
//
//
// class UserRepo{
//   static Future<List> fetchData() async {
//     final response = await http.get(Uri.parse(familyGet));
//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       var data = jsonData['data'][0];
//
//
//       List family = jsonDecode(response.body)['data'];
//       return family;
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }
// }
