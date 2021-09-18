import 'package:http/http.dart' as http;

void main() async {
  Uri url = Uri.parse('https://api.rajaongkir.com/starter/province');
  final response = await http.get(
    url,
    headers: {
      'key': 'be7f266ea8eda45d1f95f085e6e7979e',
    },
  );
  print(response.body);
}
