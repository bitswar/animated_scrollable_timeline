/// Represents the direction in which timeline elements should be drawn.
///
/// This enum is used to determine the vertical positioning and styling of timeline
/// elements, such as divisions and time labels. It helps distinguish between past
/// and future elements in the timeline visualization.
enum DrawDirection {
  /// Represents future timeline elements.
  ///
  /// When used, elements are drawn before the main timeline line and use the
  /// future styling (typically grey color).
  future(1),

  /// Represents past timeline elements.
  ///
  /// When used, elements are drawn after the main timeline line and use the
  /// past styling (typically indigo accent color).
  past(-1);

  /// The multiplier value used to determine the vertical offset of timeline elements.
  ///
  /// - For [future]: multiplier is 1, elements are drawn before middle line of the timeline
  /// - For [past]: multiplier is -1, elements are drawn after middle line of the timeline
  final int multiplier;

  /// Creates a new [DrawDirection] with the specified [multiplier].
  const DrawDirection(this.multiplier);
}
