import 'package:flutter/material.dart';

class HPModel {
  final String name;
  final String address;
  bool isConnected;
  String accessDate;
  List<String> accessibleData;
  String timeframe;

  HPModel(this.name, this.address, this.isConnected, this.accessDate, this.accessibleData, this.timeframe);
}

class HPProvider extends ChangeNotifier {
  List<HPModel> providers = [
    HPModel("Hospital 1", "123 Medical Center Blvd, Suite 100", true, "Valid Until: 12 Oct 2025", ["Heart Rate", "Steps"], "2 Weeks"),
    HPModel("Hospital 2", "456 Health Way, Building B", false, "", [], "None"),
    HPModel("Hospital 3", "789 Care Ave, Floor 3", true, "Valid Until: 05 Nov 2025", ["Glucose Level", "Calories", "Hearing Data"], "1 Month"),
    HPModel("Clinic A", "101 Wellness Drive", false, "", [], "None"),
    HPModel("Dr. Sarah's Cardiology", "Private Clinic, Block A", false, "", [], "None"),
  ];

  int get connectedCount => providers.where((hp) => hp.isConnected).length;

  void grantAccess(HPModel hp, List<String> data, String timeframe, String expiryDate) {
    hp.isConnected = true;
    hp.accessibleData = List.from(data);
    hp.timeframe = timeframe;
    hp.accessDate = expiryDate;
    notifyListeners(); 
  }

  void revokeAccess(HPModel hp) {
    hp.isConnected = false;
    hp.accessibleData = [];
    hp.timeframe = "None";
    hp.accessDate = "";
    notifyListeners(); 
  }
}