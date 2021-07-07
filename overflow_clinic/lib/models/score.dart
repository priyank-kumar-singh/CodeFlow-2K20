class CheckupScores {
  /// `0` means Eyecheckup and `1` means Earcheckup
  int type;
  int visionAcuity;
  int contrast;
  int colorBlindness;
  int astigmatism;
  int ears;

  CheckupScores({
    this.type = 0,
    this.visionAcuity = 0,
    this.contrast = 0,
    this.colorBlindness = 0,
    this.astigmatism = 0,
    this.ears = 0,
  });

  void scoreVisionAcuity(int x) {
    visionAcuity += x;
  }

  void scoreContrast(int x) {
    contrast += x;
  }

  void scoreColorBlindness(int x) {
    colorBlindness += x;
  }

  void scoreAstigmatism(int x) {
    astigmatism += x;
  }

  void scoreEars(int x) {
    ears += x;
  }
}

class CheckupResults {
  String visionAcuity;
  String contrast;
  String colorBlindness;
  String astigmatism;
  String ears;
  String remarks;
}
