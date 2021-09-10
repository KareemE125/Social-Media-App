import 'package:flutter/material.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';


ShiftingTab shiftingTab( IconData icon,  String label) => ShiftingTab(
  icon: Icon( icon, color: Colors.white, size: 22,),
  text: label,
);