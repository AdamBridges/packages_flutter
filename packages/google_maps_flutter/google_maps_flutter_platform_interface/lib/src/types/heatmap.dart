// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart' show Color;
import 'package:flutter/foundation.dart' show immutable;

import 'types.dart';

/// Uniquely identifies a [Heatmap] among [GoogleMap] heatmaps.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class HeatmapId extends MapsObjectId<Heatmap> {
  /// Creates an immutable identifier for a [Heatmap].
  const HeatmapId(String value) : super(value);
}

/// Draws a heatmap on the map.
@immutable
class Heatmap implements MapsObject<Heatmap> {
  /// Creates an immutable representation of a [Heatmap] to draw on
  /// [GoogleMap].
  const Heatmap({
    required this.heatmapId,
    this.data = const [],
    this.dissipating = false,
    this.gradient,
    this.maxIntensity,
    this.opacity = 0.6,
    this.radius = 20,
  })  : assert(gradient == null || gradient.length > 0),
        // Docs for iOS say [radius] must be between 10 and 50, but anything
        // higher than 45 causes EXC_BAD_ACCESS.
        assert(radius >= 10 && radius <= 45);

  /// Uniquely identifies a [Heatmap].
  final HeatmapId heatmapId;

  @override
  HeatmapId get mapsId => heatmapId;

  /// The data points to display.
  final List<WeightedLatLng> data;

  /// Specifies whether heatmaps dissipate on zoom. By default, the radius of
  /// influence of a data point is specified by the radius option only. When
  /// dissipating is disabled, the radius option is interpreted as a radius at
  /// zoom level 0.
  ///
  /// TODO: Not on android or ios
  final bool dissipating;

  /// The color gradient of the heatmap
  final List<Color>? gradient;

  /// The maximum intensity of the heatmap. By default, heatmap colors are
  /// dynamically scaled according to the greatest concentration of points at
  /// any particular pixel on the map. This property allows you to specify a
  /// fixed maximum.
  ///
  /// TODO: Not on ios
  final double? maxIntensity;

  /// The opacity of the heatmap, expressed as a number between 0 and 1.
  /// Defaults to 0.6.
  final double opacity;

  /// The radius of influence for each data point, in pixels.
  final int radius;

  /// Creates a new [Heatmap] object whose values are the same as this
  /// instance, unless overwritten by the specified parameters.
  Heatmap copyWith({
    List<WeightedLatLng>? dataParam,
    bool? dissipatingParam,
    List<Color>? gradientParam,
    double? maxIntensityParam,
    double? opacityParam,
    int? radiusParam,
  }) {
    return Heatmap(
      heatmapId: heatmapId,
      data: dataParam ?? data,
      dissipating: dissipatingParam ?? dissipating,
      gradient: gradientParam ?? gradient,
      maxIntensity: maxIntensityParam ?? maxIntensity,
      opacity: opacityParam ?? opacity,
      radius: radiusParam ?? radius,
    );
  }

  /// Creates a new [Heatmap] object whose values are the same as this
  /// instance.
  Heatmap clone() => copyWith(
        dataParam: List.of(data),
        gradientParam: gradient != null ? List.of(gradient!) : null,
      );

  /// Converts this object to something serializable in JSON.
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('heatmapId', heatmapId.value);
    addIfPresent('data', data.map((e) => e.toJson()).toList());
    addIfPresent('dissipating', dissipating);
    addIfPresent('gradient', gradient?.map((e) => e.value).toList());
    addIfPresent('maxIntensity', maxIntensity);
    addIfPresent('opacity', opacity);
    addIfPresent('radius', radius);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Heatmap typedOther = other as Heatmap;
    return heatmapId == typedOther.heatmapId &&
        listEquals(data, typedOther.data) &&
        dissipating == typedOther.dissipating &&
        listEquals(gradient, typedOther.gradient) &&
        maxIntensity == typedOther.maxIntensity &&
        opacity == typedOther.opacity &&
        radius == typedOther.radius;
  }

  @override
  int get hashCode => heatmapId.hashCode;
}
