import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:short_url/controller.dart';
import 'package:short_url/url_provider.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  final _key=GlobalKey<FormState>();
  bool isActive=true;

  delete()async{
    await Future.delayed(const Duration(days:2,hours: 12,minutes: 00,seconds: 00)).whenComplete((){
      Provider.of<UrlProvider>(context,listen: false).clearData();
    });
  }

  validUrl()async{
    if(_key.currentState!.validate()){
      if(Controller.controller.text.isEmpty){
      }else{
        Provider.of<UrlProvider>(context,listen: false).fetchUrl();
      }
    }
  }
  @override
  void initState(){
    delete();
    Provider.of<UrlProvider>(context,listen: false).loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data=Provider.of<UrlProvider>(context);
    data.loadData();
    return Scaffold(
      appBar:AppBar(
        backgroundColor:const Color(0xff007557),
        elevation: 0,
        centerTitle: true,
        title:Text("Short Url".toUpperCase(),style:GoogleFonts.roboto(fontSize: 22,fontWeight:FontWeight.w500),),
      ),

      body:Padding(
        padding: const EdgeInsets.symmetric(horizontal:20,vertical: 5),
        child: Column(
          children: [

            const SizedBox(height: 20,),
            Container(
              alignment: Alignment.center,
              height:50,
              width:double.infinity,
              decoration: BoxDecoration(
                color:Colors.grey[200],
                borderRadius: BorderRadius.circular(7)
              ),
              child:Form(
                key: _key,
                child:Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller:Controller.controller,
                        decoration:const InputDecoration(
                          hintText: "Past the link",
                          border:InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder:InputBorder.none,
                          contentPadding:EdgeInsets.symmetric(vertical: 6,horizontal: 10)
                        ),
                      ),
                    ),
                    Visibility(
                     visible:false,
                     child: GestureDetector(
                       onTap:(){Controller.controller.clear();},
                       child: const Icon(Icons.clear_rounded)),),
                    const SizedBox(width: 5,)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25,),
            SizedBox(
              height:45,
              width: double.infinity,
              child: ElevatedButton(
                  style:ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:MaterialStateProperty.all(const Color(0xff007557))
                  ),
                  onPressed:(){
                    validUrl();
                  }, child:Text('Get Link',style:GoogleFonts.roboto(fontSize: 18),)),
            ),

            SizedBox(height:data.shortUrl.isEmpty?10:15,),
            data.isLoading?const CircularProgressIndicator(
              color:Color(0xff007557),
              strokeWidth: 2,
            ):
            GestureDetector(
                onTap:(){
                  Clipboard.setData(ClipboardData(text:data.shortUrl,)).whenComplete((){
                    messageSnack(context,const Color(0xff007557),"Copied this link");
                  });
                },
                child: data.error!=null?Text(data.error!):Text(data.shortUrl,style:GoogleFonts.roboto(fontSize: 17),)),

            SizedBox(height:data.shortUrl.isEmpty?10:15,),
            Expanded(child:
            ListView.builder(
              physics:const BouncingScrollPhysics(),
              itemCount:data.urlList.length,
                itemBuilder:(_,index){
                  return GestureDetector(
                    onTap:(){
                      Clipboard.setData(ClipboardData(text:data.shortUrl,)).whenComplete((){
                        messageSnack(context,const Color(0xff007557),"Copied this link");
                      });
                    },
                    child: Card(child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      child: Row(
                        children: [
                          Text(data.urlList[index].url!,style:GoogleFonts.roboto(fontSize: 14),),
                          const Spacer(),
                          Text(data.urlList[index].date!,style:GoogleFonts.roboto(fontSize: 14),),
                        ],
                      ),
                    )),
                  );
                }))

          ],
        ),
      ),
    );
  }
}




messageSnack(BuildContext context,Color bg,String title)async{
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          decoration: BoxDecoration(
              color:bg,
              borderRadius: BorderRadius.circular(10)
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline,color:Colors.white,),
              const SizedBox(width: 10,),
              Expanded(child:  Text(title,style: GoogleFonts.roboto(color: Colors.white),),)
            ],
          ))));
}