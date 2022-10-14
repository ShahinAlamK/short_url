import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'as http;
import 'package:short_url/api_status.dart';


String _baseUrl="https://cleanuri.com/api/v1/shorten";

class Controller{

  static TextEditingController controller=TextEditingController();



  static Future getUrl()async{
    try{
      final response=await http.post(Uri.parse(_baseUrl),body:{"url":controller.text}).timeout(const Duration(seconds:10));
      if(response.statusCode==200){
        final decode=jsonDecode(response.body);
        final data=decode['result_url'];
        return Success(data);
      }
      return Failure(
       "Invalid Request"
      );
    }on SocketException{
      return Failure("No Internet");
    }on HttpException{
      return Failure(
         "Invalid Host"
      );
    }on TimeoutException{
      return Failure(
          "TimeOut"
      );
    }on FormatException{
      return Failure(
        "Bad Request"
      );
    } catch(error){
      return Failure(
       error.toString()
      );
    }
  }
}

