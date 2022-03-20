import 'package:charts_flutter/flutter.dart' as charts;

class TimeSeriesWpm {
  final DateTime time;
  final int wpm;

  TimeSeriesWpm(this.time, this.wpm);
}

var records = <charts.Series<TimeSeriesWpm, DateTime>>[
  charts.Series<TimeSeriesWpm, DateTime>(
    id: "WPM",
    colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
    domainFn: (TimeSeriesWpm wpms, _) => wpms.time,
    measureFn: (TimeSeriesWpm wpms, _) => wpms.wpm,
    data: [
      TimeSeriesWpm(DateTime(2020, 2, 24), 11),
      TimeSeriesWpm(DateTime(2020, 2, 25), 13),
      TimeSeriesWpm(DateTime(2020, 2, 26), 15),
      TimeSeriesWpm(DateTime(2020, 2, 27), 17),
      TimeSeriesWpm(DateTime(2020, 2, 28), 18),
      TimeSeriesWpm(DateTime(2020, 3, 1), 19),
      TimeSeriesWpm(DateTime(2020, 3, 2), 20),
      TimeSeriesWpm(DateTime(2020, 3, 3), 21),
      TimeSeriesWpm(DateTime(2020, 3, 4), 22), 
      TimeSeriesWpm(DateTime(2020, 3, 5), 23),
      TimeSeriesWpm(DateTime(2020, 3, 6), 24),
      TimeSeriesWpm(DateTime(2020, 3, 7), 25),
      TimeSeriesWpm(DateTime(2020, 3, 8), 26),
      TimeSeriesWpm(DateTime(2020, 3, 9), 27),
      TimeSeriesWpm(DateTime(2020, 3, 10), 28),
      TimeSeriesWpm(DateTime(2020, 3, 11), 29),
      TimeSeriesWpm(DateTime(2020, 3, 12), 30),
      TimeSeriesWpm(DateTime(2020, 3, 13), 31),
      TimeSeriesWpm(DateTime(2020, 3, 14), 33),
      TimeSeriesWpm(DateTime(2020, 3, 15), 31),
      TimeSeriesWpm(DateTime(2020, 3, 17), 31),
      TimeSeriesWpm(DateTime(2020, 3, 18), 33),
      TimeSeriesWpm(DateTime(2020, 3, 19), 31),
      TimeSeriesWpm(DateTime(2020, 3, 20), 33),
    ],
  )
];