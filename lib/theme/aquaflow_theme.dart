import 'package:flutter/material.dart';

class AquaFlowColors {
  // Earth tones
  static const soil = Color(0xFF1a1208);
  static const earth = Color(0xFF2d1f0a);
  static const moss = Color(0xFF1e3020);
  static const leaf = Color(0xFF2d5a27);
  static const sage = Color(0xFF6b8f4e);
  static const mint = Color(0xFFa8c97a);

  // Water tones
  static const water = Color(0xFF4a9eba);
  static const sky = Color(0xFF7ec8e3);
  static const mist = Color(0xFFc4e8f5);

  // Accent colors
  static const cream = Color(0xFFf5f0e8);
  static const sun = Color(0xFFe8c547);
  static const ember = Color(0xFFe07840);

  // Text colors
  static const textMain = Color(0xFFf0ece4);
  static const textDim = Color(0xFF8a8070);

  // Background
  static const panel = Color(0xF0120C04);
  static const panelBorder = Color(0x12FFFFFF);

  // Gradients
  static const leafGradient = LinearGradient(
    colors: [leaf, sage],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const waterGradient = LinearGradient(
    colors: [water, sky],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const flowGradient = LinearGradient(
    colors: [leaf, mint],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

class AquaFlowTextStyles {
  static const serifDisplay = TextStyle(
    fontFamily: 'serif',
    letterSpacing: -0.3,
  );

  static const monoLabel = TextStyle(
    fontFamily: 'monospace',
    fontSize: 9,
    letterSpacing: 2,
    fontWeight: FontWeight.w500,
  );

  static TextStyle pageTitle = const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
    color: AquaFlowColors.textMain,
  );

  static TextStyle panelTitle = const TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    color: AquaFlowColors.textMain,
  );

  static TextStyle statValue = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );
}
