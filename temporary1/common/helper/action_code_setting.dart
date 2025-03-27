import 'package:firebase_auth/firebase_auth.dart';

var acs = ActionCodeSettings(
  url: "http://startopreneur.com/auth",
  handleCodeInApp: true,
  iOSBundleId: 'com.nextsavy.startopreneur',
  androidPackageName: 'com.nextsavy.startopreneur',
  androidInstallApp: false,
  androidMinimumVersion: '12',
);