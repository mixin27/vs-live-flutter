// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'native_ad_controller.g.dart';

class NativeAdModel extends Equatable {
  const NativeAdModel({
    this.ad,
    this.adLoaded = false,
  });

  final NativeAd? ad;
  final bool adLoaded;

  @override
  List<Object?> get props => [ad?.adUnitId, adLoaded];

  NativeAdModel copyWith({
    NativeAd? ad,
    bool? adLoaded,
  }) {
    return NativeAdModel(
      ad: ad ?? this.ad,
      adLoaded: adLoaded ?? this.adLoaded,
    );
  }
}

@riverpod
class NativeAdController extends _$NativeAdController {
  @override
  NativeAdModel build() {
    return const NativeAdModel();
  }

  void update(NativeAdModel item) {
    state = item;
  }
}
