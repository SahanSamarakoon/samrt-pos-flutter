import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_pos/models/payment.dart';
import 'package:smart_pos/models/salesperson.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class DialyGoalProgress extends StatefulWidget {
  @override
  _DialyGoalProgressState createState() => _DialyGoalProgressState();
}

class _DialyGoalProgressState extends State<DialyGoalProgress> {
  @override
  Widget build(BuildContext context) {
    final dailytarget =
        Provider.of<SalesPersonProvider>(context).person.dialySalesTarget;
    final dailysales = Provider.of<PaymentsProvider>(context).dailySales();
    final double progressValue = (dailysales / dailytarget) * 100;
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
        minimum: 0,
        maximum: 100,
        showLabels: false,
        showTicks: false,
        startAngle: 270,
        endAngle: 270,
        axisLineStyle: AxisLineStyle(
          thickness: 0.03,
          color: const Color.fromARGB(100, 0, 169, 181),
          thicknessUnit: GaugeSizeUnit.factor,
        ),
        annotations: <GaugeAnnotation>[
          GaugeAnnotation(
              positionFactor: 0,
              angle: 90,
              widget: Text(
                progressValue.toStringAsFixed(1) + '% Tragets Covered ',
                style: TextStyle(fontSize: 14),
              ))
        ],
        pointers: <GaugePointer>[
          RangePointer(
              value: progressValue,
              width: 0.15,
              sizeUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.bothCurve,
              gradient: const SweepGradient(
                  colors: <Color>[Color(0xFF00a9b5), Color(0xFFa4edeb)],
                  stops: <double>[0.25, 0.75])),
        ],
      )
    ]);
  }
}
