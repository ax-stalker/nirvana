import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class business_accounts extends StatelessWidget {
  
   business_accounts({super.key});
  final DraggableScrollableController sheetController = DraggableScrollableController();


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: DraggableScrollableSheet(builder: (context, scrollController){
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
               SliverToBoxAdapter(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).hintColor,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          height: 4,
          width: 40,
          margin: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    ),


              SliverList.list(children: [
                const ListTile(title: Text("Jane Doe"),),
                const ListTile(title:Text("Jack reacher"))
              ])
            ],
          ),
        );
      } ),
    );
  }
}
