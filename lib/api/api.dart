import 'dart:convert';

import 'package:http/http.dart' as http;

// {
// 	"usuario": "angel",
// 	"contrasena": "123456789",
// 	"direccion": "la callecita",
// 	"telefono": "70209194"
// }

class CallApi {
  final String _url = 'http://10.0.2.2:3000/';

  postData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(fullUrl,
                           body: jsonEncode(data),
                           headers: _setHeaders());
  }

  getData(apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl,
                          headers: _setHeaders());
  }

  getDataUser(apiUrl, token) async {
    var fullUrl = _url + apiUrl;
    return await http.get(fullUrl,
                          headers: _setHeadersUser(token));
  }

  deleteData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + data;
    return await http.delete(fullUrl,
                             headers: _setHeaders());
  }

  editData(data, apiUrl) async {
    var fullUrl = _url + apiUrl + data['id'].toString();
    return await http.put(fullUrl,
                          body: jsonEncode(data),
                          headers: _setHeaders());
  }

  _setHeaders() => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
  };

  _setHeadersUser(String token) => {
    'Content-type' : 'application/json',
    'Accept' : 'application/json',
    'Authorization' : token,
  };
}