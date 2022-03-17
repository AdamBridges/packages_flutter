/// This setting controls how the API handles gestures on the map
enum GestureHandling {
  /// Scroll events and one-finger touch gestures scroll the page, and do not
  /// zoom or pan the map. Two-finger touch gestures pan and zoom the map.
  /// Scroll events with a ctrl key or ⌘ key pressed zoom the map. In this mode
  /// the map cooperates with the page.
  cooperative,

  /// All touch gestures and scroll events pan or zoom the map.
  greedy,

  /// The map cannot be panned or zoomed by user gestures.
  none,

  /// (default) Gesture handling is either cooperative or greedy, depending on
  /// whether the page is scrollable or in an iframe.
  auto,
}
