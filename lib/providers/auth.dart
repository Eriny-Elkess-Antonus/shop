import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http.dart';
import 'dart:convert';
import 'dart:async'; // 3shan a3ml timer
import 'package:shared_preferences/shared_preferences.dart'; // 3shan astore 7aga 3la gehaz

class Auth with ChangeNotifier {
  //3shan at2akd an logic at3amlo update
  String _token; //ha3ml datetime 3shan hwa byfsl b3d sa3a mn firebase
  DateTime _expiryDate;
  String _userId;

  Timer _authTimer;
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    _userId;
  }

  void _autologout() {
    // ha3l timer 3shan lma a3ml logout autmaticl klo yt2gl
    if (_authTimer != null) {
      _authTimer.cancel();
    }
  }

  Future<void> _authenticate(
      String email, String password, String urlsegment) async {
    //3ammlnaha 3shan bnkarr nfs klam fe signup w login
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlsegment?key=AIzaSyB0LRjHfQ6lKkA_LUU6lf6Qvcw0koWetvM';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      ); //3amlna'' 3shan map
      final responseData =
          json.decode(response.body); //3shan lma uzharli error ytsl7
      if (responseData['error'] != null) {
        throw Http(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expireIn'],
          ),
        ),
      ); // drive expiredate
      _autologout();

      notifyListeners();
      final prefs =
          await SharedPreferences.getInstance(); // 3amlna nfa2 fe zakra gehaz
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate.toIso8601String()
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    //bntezer elemail w password
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    //bntezer elemail w password

    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> truAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extracteduserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extracteduserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extracteduserData['token'];
    _userId = extracteduserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autologout();
    return true;
  }

  Future<void> logout() async {
    //3amlna function hnst5dmha 3shan logout
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();

    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
