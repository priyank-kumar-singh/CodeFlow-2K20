import 'package:cloud_firestore/cloud_firestore.dart';

/// `Collection Reference` to the users collection in the firestore database.
final CollectionReference kUsersCollectionReference = Firestore.instance.collection('users');

/// `Slider Images` reference in assets data in `.jpg`
///
/// range `1 to 5`
final String kSliderImages = 'assets/images/slider';

/// `Tips Images` reference in assets data in `.jpg`
///
/// range `1 to 6`
final String kTipsImages = 'assets/images/tips';

/// `Team Member Images` reference in assets data in `.jpg`
///
/// range `1 to 4`
final String kTeamMemberImages = 'assets/images/team_member_';

/// `Vision Test Images` reference in assets data in `.png`
///
/// range `1 to 12`
final String kVisionTestImages = 'assets/images/vision';

/// `Contrast Test Images` reference in assets data in `.png`
///
/// range `1 to 10`
final String kContrastTestImages = 'assets/images/contrast';

/// `Color Blindness Test Images` reference in assets data in `.png`
///
/// range `1 to 6`
final String kColorBlindnessTestImages = 'assets/images/blind';

/// `Astigmatism Test Image` reference in assets data
final String kAstigmatismTestImage = 'assets/images/astigmatism.png';

/// `Other Image` reference in assets data in `.png`
///
/// `kAssetImages/team.png`
///
/// `kAssetImages/logo.png`
///
/// `kAssetImages/logo_green.png`
final String kAssetImages = 'assets/images';
