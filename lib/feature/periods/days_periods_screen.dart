import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetable_generation_application/core/color/color_constants.dart';
import 'package:timetable_generation_application/core/global/custom_textfield.dart';
import 'package:timetable_generation_application/core/global/helper_function.dart';
import 'package:timetable_generation_application/core/utils/loading.dart';
import 'package:timetable_generation_application/feature/periods/controller/days_periods_controller.dart';

class DaysAndPeriodsScreen extends StatefulWidget {
  @override
  _DaysAndPeriodsScreenState createState() => _DaysAndPeriodsScreenState();
}

class _DaysAndPeriodsScreenState extends State<DaysAndPeriodsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<PeriodsController>(context, listen: false).loadPeriods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        surfaceTintColor: AppColor.white,
        title: Text(
          'Periods',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColor.primary)),
              onPressed: () {
                Provider.of<PeriodsController>(context, listen: false)
                    .saveTimetable(context);
              },
              child: Text(
                "Save",
                style: TextStyle(color: AppColor.white),
              ),
            ),
          )
        ],
      ),
      body: Consumer<PeriodsController>(builder: (context, provider, _) {
        return provider.isLoading
            ? Center(
                child: Loading(
                color: AppColor.primary,
              ))
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: provider.days.length,
                  itemBuilder: (context, dayIndex) {
                    return Container(
                      decoration: boxDecoration(),
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.days[dayIndex],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            for (int periodIndex = 0;
                                periodIndex < 4;
                                periodIndex++)
                              GestureDetector(
                                onTap: () => provider.pickTime(
                                    context, dayIndex, periodIndex),
                                child: AbsorbPointer(
                                  child: CustomTextField(
                                    controller:
                                        provider.periodControllers[dayIndex]
                                            [periodIndex],
                                    hintText: 'Period ${periodIndex + 1} Time',
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
      }),
    );
  }
}
