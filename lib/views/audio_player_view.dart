import 'dart:async';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../widgets/play_pause_widget.dart';

class AudioPlayerView extends StatefulWidget {
  final String? path;

  const AudioPlayerView({Key? key, required this.path}) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<AudioPlayerView> {
  PlayerMode mode = PlayerMode.MEDIA_PLAYER;

  late AudioPlayer _audioPlayer;
  Duration? _duration = const Duration();
  Duration? _position = const Duration();

  PlayerState _playerState = PlayerState.STOPPED;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<PlayerControlCommand>? _playerControlCommandSubscription;

  bool get _isPlaying => _playerState == PlayerState.PLAYING;
  bool get _isPaused => _playerState == PlayerState.PAUSED;
  String get _durationText => _duration!.inHours < 1
      ? (_duration
              ?.toString()
              .split('.')
              .first
              .substring(2, _position?.toString().split('.').first.length) ??
          '')
      : (_duration?.toString().split('.').first ?? '');

  String get _positionText => _duration!.inHours < 1
      ? (_position
              ?.toString()
              .split('.')
              .first
              .substring(2, _position?.toString().split('.').first.length) ??
          '')
      : (_position?.toString().split('.').first ?? '');

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _play();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: const Text("Musique"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          _isPlaying
              ? PlayPauseWidget(
                  key: const Key('pause_button'),
                  iconData: Icons.pause_circle_filled_outlined,
                  onPressed: _isPlaying ? _pause : null,
                  iconSize: 64,
                  color: Colors.transparent,
                )
              : PlayPauseWidget(
                  key: const Key('play_button'),
                  onPressed: _isPlaying ? null : _play,
                  iconData: Icons.play_circle_fill_outlined,
                  iconSize: 64,
                  color: Colors.transparent,
                ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _position != null
                      ? '$_positionText'
                      : _duration != null
                          ? _durationText
                          : '',
                  style: const TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: Slider(
                    activeColor: Colors.white,
                    inactiveColor: Colors.grey,
                    label: null,
                    onChanged: (v) {
                      final duration = _duration;
                      if (duration == null) {
                        return;
                      }
                      //final Position = v * duration.inMilliseconds;
                      _audioPlayer.seek(Duration(
                          milliseconds: (v * duration.inMilliseconds).round()));
                    },
                    value: (_position != null &&
                            _duration != null &&
                            _position!.inMilliseconds > 0 &&
                            _position!.inMilliseconds <
                                _duration!.inMilliseconds)
                        ? _position!.inMilliseconds / _duration!.inMilliseconds
                        : 0.0,
                  ),
                ),
                Text(
                  _position != null
                      ? '$_durationText'
                      : _duration != null
                          ? _durationText
                          : '',
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: mode);

    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      log('duration' + duration.toString());

      setState(() => _duration = duration);

      log('duration' + _durationText.toString());
    });

    _positionSubscription =
        _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
              log('onAudioPositionChanged');
              _position = p;
            }));

    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      log('onPlayerCompletion');
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });

    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      log('audioPlayer error : $msg');

      setState(() {
        _playerState = PlayerState.STOPPED;
        _duration = const Duration(milliseconds: 0);
        _position = const Duration(milliseconds: 0);
      });
    });

    _playerControlCommandSubscription =
        _audioPlayer.notificationService.onPlayerCommand.listen((command) {
      log('command: $command');
    });
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position!.inMilliseconds > 0 &&
            _position!.inMilliseconds < _duration!.inMilliseconds)
        ? _position
        : null;
    final result =
        await _audioPlayer.play(widget.path ?? '', position: playPosition);
    if (result == 1) {
      setState(() => _playerState = PlayerState.PLAYING);
    }

    // default playback rate is 1.0
    // this should be called after _audioPlayer.play() or _audioPlayer.resume()
    // this can also be called everytime the user wants to change playback rate in the UI
    _audioPlayer.setPlaybackRate(1.0);

    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) {
      setState(() => _playerState = PlayerState.PAUSED);
    }
    return result;
  }

  /* Future<int> _stop() async {
    final result = await _audioPlayer.stop();
    if (result == 1) {
      setState(() {
        _playerState = PlayerState.STOPPED;
        _position = const Duration();
      });
    }
    return result;
  } */

  void _onComplete() {
    setState(() => _playerState = PlayerState.STOPPED);
  }
}
