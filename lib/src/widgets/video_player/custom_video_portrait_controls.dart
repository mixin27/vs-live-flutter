// import 'package:flutter/material.dart';
// import 'package:flick_video_player/flick_video_player.dart';

// /// Custom portrait controls.
// class CustomVideoPortraitControls extends StatelessWidget {
//   const CustomVideoPortraitControls({
//     super.key,
//     this.iconSize = 20,
//     this.fontSize = 12,
//     this.progressBarSettings,
//     this.isLive = false,
//   });

//   /// Icon size.
//   ///
//   /// This size is used for all the player icons.
//   final double iconSize;

//   /// Font size.
//   ///
//   /// This size is used for all the text.
//   final double fontSize;

//   /// [FlickProgressBarSettings] settings.
//   final FlickProgressBarSettings? progressBarSettings;

//   final bool isLive;

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         Positioned.fill(
//           child: FlickShowControlsAction(
//             child: FlickSeekVideoAction(
//               child: Center(
//                 child: FlickVideoBuffer(
//                   child: FlickAutoHideChild(
//                     showIfVideoNotInitialized: false,
//                     child: FlickPlayToggle(
//                       size: 30,
//                       color: Colors.black,
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.white70,
//                         borderRadius: BorderRadius.circular(40),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned.fill(
//           child: FlickAutoHideChild(
//             child: Padding(
//               padding: const EdgeInsets.all(10.0),
//               child: Column(
//                 mainAxisAlignment:
//                     isLive ? MainAxisAlignment.start : MainAxisAlignment.end,
//                 children: <Widget>[
//                   if (isLive) ...[
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         IconButton(
//                           onPressed: () => Navigator.of(context).pop(true),
//                           icon: Icon(Icons.adaptive.arrow_back),
//                           iconSize: iconSize,
//                         ),
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.circle,
//                               size: iconSize / 2,
//                               color: Colors.red,
//                             ),
//                             const SizedBox(width: 4),
//                             const Text("LIVE"),
//                           ],
//                         ),
//                       ],
//                     ),
//                     const Spacer(),
//                   ],
//                   FlickVideoProgressBar(
//                     flickProgressBarSettings: progressBarSettings,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       FlickPlayToggle(
//                         size: iconSize,
//                       ),
//                       SizedBox(
//                         width: iconSize / 2,
//                       ),
//                       FlickSoundToggle(
//                         size: iconSize,
//                       ),
//                       SizedBox(
//                         width: iconSize / 2,
//                       ),
//                       Row(
//                         children: <Widget>[
//                           FlickCurrentPosition(
//                             fontSize: fontSize,
//                           ),
//                           FlickAutoHideChild(
//                             child: Text(
//                               ' / ',
//                               style: TextStyle(
//                                   color: Colors.white, fontSize: fontSize),
//                             ),
//                           ),
//                           FlickTotalDuration(
//                             fontSize: fontSize,
//                           ),
//                           // const SizedBox(width: 4),
//                           // const Text("LIVE"),
//                         ],
//                       ),
//                       Expanded(
//                         child: Container(),
//                       ),
//                       FlickSubtitleToggle(
//                         size: iconSize,
//                       ),
//                       SizedBox(
//                         width: iconSize / 2,
//                       ),
//                       FlickFullScreenToggle(
//                         size: iconSize,
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
