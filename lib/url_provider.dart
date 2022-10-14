import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:short_url/api_status.dart';
import 'package:short_url/controller.dart';
import 'package:short_url/short_model.dart';


class UrlProvider extends ChangeNotifier{

  SharedPreferences? sharedPreferences;
  List<ShortModel>_urlList=[];
  List<ShortModel>get urlList=>_urlList;

  bool _isLoading=false;
  bool get isLoading=>_isLoading;

  String?short_url='';
  String get shortUrl=>short_url!;

  String? error;

  setLoad(bool loading){
    _isLoading=loading;
    notifyListeners();
  }
  

  loadUrlData(String url)async{
    short_url=url;
    ShortModel data=ShortModel(url:url,date:DateFormat.yMMMd().format(DateTime.now()).toString());
    _urlList.add(data);
    saveNote();
    notifyListeners();
  }


   fetchUrl()async{
    setLoad(true);
    final response=await Controller.getUrl();

    if(response is Success){
      setLoad(false);
      loadUrlData(response.response as String);
      notifyListeners();

    }if(response is Failure){
      setLoad(false);
      error=response.response!;
      notifyListeners();
    }
    notifyListeners();
  }

  Future saveNote()async{
    sharedPreferences=await SharedPreferences.getInstance();
    List<String>listMap=_urlList.map((e) => jsonEncode(e.toMap())).toList();
    sharedPreferences!.setStringList("key",listMap);
    notifyListeners();
  }

  Future loadData()async{
    sharedPreferences=await SharedPreferences.getInstance();
    List<String>?dataList=sharedPreferences!.getStringList("key");
    _urlList=dataList!.map((e) =>ShortModel.fromMap(jsonDecode(e))).toList();
    notifyListeners();
  }

  Future clearData()async{
    sharedPreferences=await SharedPreferences.getInstance();
    sharedPreferences!.clear().whenComplete((){
      print("All Data Clear");
    });

  }

  Future deleteData(index)async{
    //sharedPreferences=await SharedPreferences.getInstance();
    _urlList.removeAt(index);
  }

}