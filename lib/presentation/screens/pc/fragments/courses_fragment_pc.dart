import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tsscourses/core/setting.dart';
import 'package:tsscourses/core/sizeconfig.dart';
import 'package:tsscourses/domain/entities/formation.dart';
import 'package:tsscourses/presentation/components/view_models/data_view_model.dart';
import 'package:tsscourses/presentation/components/widgets/course_box_pc.dart';
import 'package:tsscourses/presentation/components/widgets/empty_data.dart';
import 'package:tsscourses/presentation/components/widgets/two_dimension_scrool.dart';

class CoursesFragmentPc extends StatefulHookConsumerWidget {  
  
  CoursesFragmentPc();

  @override
  CoursesFragmentPcState createState() => CoursesFragmentPcState();
}

class CoursesFragmentPcState extends ConsumerState<CoursesFragmentPc> {

  List<Formation> courses = []; 
  bool isSearch = true;
  bool isOk = false;

   getData() async { 

      isSearch = true; 
  
      Future<List<Formation>> retour = ref.read(dataViewModelProvider).getMyCourses();
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
      child : 
          (isSearch) ? const Center( child: CircularProgressIndicator(color: Setting.primaryColor,), ) :  (courses.isEmpty) ? 
          EmptyData() : LayoutBuilder(
            builder: (context, constraints) {
              // Define the minimum width per grid item
              double itemWidth = 350;

              // Calculate the number of columns based on the available width
              int crossAxisCount = (constraints.maxWidth / itemWidth).floor();

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: courses.length,
                
                itemBuilder: (context, index) {
                  return Container(margin: const EdgeInsets.only(left: 10, right: 10), child: CourseBoxPc(item: courses[index]));
                },
              );
            }
          )
          
    );
  }

}