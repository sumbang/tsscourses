import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/components/widgets/course_box.dart';
import 'package:tsscourses/presentation/components/widgets/empty_data.dart';

class FreeFragment extends StatefulHookConsumerWidget {  
  
  FreeFragment();

  @override
  FreeFragmentState createState() => FreeFragmentState();
}

class FreeFragmentState extends ConsumerState<FreeFragment> {

  List<Formation> courses = []; 
  bool isSearch = true;
  bool isOk = false;

   getData() async { 

      isSearch = true; 
  
      Future<List<Formation>> retour = ref.read(dataViewModelProvider).getFreeCourses();
      await retour.then((result) {
           setState(() {
            for(int i = 0; i < result.length; i++) {
              courses.add(result[i]);
            }
            isSearch = false;
            isOk = true;
           });
                  
      }).catchError((e) {
        setState(() {
          isSearch = false;
          isOk = false;
        });
      });

   }

  @override
  void initState()  {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => getData());  
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width,
      child : (isSearch) ? const Center( child: CircularProgressIndicator(color: Setting.primaryColor,), ) :  (courses.isEmpty) ? 
          EmptyData() : SingleChildScrollView(
          child: GridView.count(
                        crossAxisCount: 1,
                        padding: const EdgeInsets.all(0),
                        childAspectRatio: 1,
                        mainAxisSpacing: 5,
                        controller:ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: courses.map((Formation data) {
                          return CourseBox(item:  data);
                        }).toList()) )
    );
  }

}