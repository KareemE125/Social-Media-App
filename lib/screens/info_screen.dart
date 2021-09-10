import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget
{
  static const routeName = '/info-screen';

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('What You Can Do ?'),
          centerTitle: true,
        ),
        body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: 5,
            separatorBuilder: (_,i)=>Divider(height: 20,color: Colors.white,indent: 5,endIndent: 5,),
            itemBuilder: (_, i) => Card(
              clipBehavior: Clip.antiAlias,
              elevation: 3,
              shadowColor: Colors.white,
              child: Image.asset('assets/images/pic_${i+1}.jpg'),
            ),
          ),
        ),
      ),
    );
  }
}
