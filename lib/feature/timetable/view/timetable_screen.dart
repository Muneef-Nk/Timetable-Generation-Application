import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';
import 'package:timetable_generation_application/core/utils/loading.dart';
import 'package:timetable_generation_application/feature/timetable/controller/timetable_controller.dart';

class TimetableScreen extends StatelessWidget {
  final String selectedCourseId;

  TimetableScreen({required this.selectedCourseId});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TimetableController>(context, listen: false);
    return DefaultTabController(
      length: provider.daysOfWeek.length,
      child: Scaffold(
        backgroundColor: AppColor.bg,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          surfaceTintColor: AppColor.white,
          title: Text(
            'Timetable',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            dividerColor: Colors.transparent,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: AppColor.primary,
            indicator: BoxDecoration(
              color: AppColor.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            tabs: provider.daysOfWeek.map((day) {
              return Tab(
                height: 45,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    day[0].toUpperCase() + day.substring(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        body: Consumer<TimetableController>(
          builder: (context, provider, _) {
            return TabBarView(
              children: provider.daysOfWeek.map((day) {
                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: provider.fetchSubjects(
                      selectedCourseId: selectedCourseId),
                  builder: (context, subjectSnapshot) {
                    if (subjectSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(
                        child: Loading(color: AppColor.primary),
                      );
                    } else if (!subjectSnapshot.hasData ||
                        subjectSnapshot.data!.isEmpty) {
                      return Center(child: Text("No subjects found."));
                    } else {
                      List<Map<String, dynamic>> subjects =
                          subjectSnapshot.data!;

                      return FutureBuilder<Map<String, Map<String, String>>>(
                        future: provider.fetchPeriods(),
                        builder: (context, periodSnapshot) {
                          if (periodSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child: Loading(color: AppColor.primary));
                          } else if (!periodSnapshot.hasData ||
                              periodSnapshot.data!.isEmpty) {
                            return Center(
                                child: Text("No periods found for $day."));
                          } else {
                            final periodsForDay =
                                periodSnapshot.data![day] ?? {};
                            List<Map<String, dynamic>> assignedSubjects =
                                provider.assignSubjectsToPeriods(subjects);

                            return ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 20),
                              itemCount: periodsForDay.length,
                              itemBuilder: (context, periodIndex) {
                                String periodKey = "Period ${periodIndex + 1}";
                                String periodTime =
                                    periodsForDay[periodKey] ?? "N/A";
                                var subject = assignedSubjects[periodIndex];

                                return Container(
                                  decoration: boxDecoration(),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${periodIndex + 1}',
                                              style: TextStyle(
                                                color: AppColor.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "$periodTime",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(subject['subject'] ?? "N/A"),
                                            Text(
                                              subject['staff'] ?? "N/A",
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
