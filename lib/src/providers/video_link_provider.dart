import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'video_link_provider.g.dart';

@Riverpod(keepAlive: true)
class VideoLinkState extends _$VideoLinkState {
  @override
  String build() {
    return "";
  }

  void setLink(String link) {
    state = link;
  }
}
