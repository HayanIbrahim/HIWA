import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_constants.dart';

// Events
abstract class MapEvent extends Equatable {
  const MapEvent();
  @override
  List<Object?> get props => [];
}

class ChangeMapLayerEvent extends MapEvent {
  final String layer;
  const ChangeMapLayerEvent(this.layer);
  @override
  List<Object?> get props => [layer];
}

class ChangeMapOpacityEvent extends MapEvent {
  final double opacity;
  const ChangeMapOpacityEvent(this.opacity);
  @override
  List<Object?> get props => [opacity];
}

class MoveMapCenterEvent extends MapEvent {
  final LatLng center;
  const MoveMapCenterEvent(this.center);
  @override
  List<Object?> get props => [center];
}

// State
class MapState extends Equatable {
  final String activeLayer;
  final double layerOpacity;
  final LatLng center;
  final double zoom;

  const MapState({
    this.activeLayer = MapTileLayers.precipitation,
    this.layerOpacity = 0.75,
    this.center = const LatLng(AppConstants.defaultLatitude, AppConstants.defaultLongitude),
    this.zoom = 6.0,
  });

  MapState copyWith({
    String? activeLayer,
    double? layerOpacity,
    LatLng? center,
    double? zoom,
  }) {
    return MapState(
      activeLayer: activeLayer ?? this.activeLayer,
      layerOpacity: layerOpacity ?? this.layerOpacity,
      center: center ?? this.center,
      zoom: zoom ?? this.zoom,
    );
  }

  @override
  List<Object?> get props => [activeLayer, layerOpacity, center, zoom];
}

// BLoC
class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState()) {
    on<ChangeMapLayerEvent>((event, emit) {
      emit(state.copyWith(activeLayer: event.layer));
    });

    on<ChangeMapOpacityEvent>((event, emit) {
      emit(state.copyWith(layerOpacity: event.opacity));
    });

    on<MoveMapCenterEvent>((event, emit) {
      emit(state.copyWith(center: event.center));
    });
  }
}
