// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

/// [Splitter] is a splitter component for Angular Dart
@Component(
  selector: 'splitter',
  styleUrls: const ['splitter.css'],
  templateUrl: 'splitter.html',
  directives: const [
    CORE_DIRECTIVES,
    materialDirectives,
  ],
  providers: const [],
  host: const {
    '[class.horizontal]': 'horizontal',
    '[class.active]': 'active',
  },
)
class Splitter {
  @Input()
  bool horizontal = false;

  /// Is the splitter locked?
  @Input()
  bool locked = false;

  // Temporary subsciptions to event streams, active only during dragging.

  StreamSubscription<MouseEvent> _trackSubscr;

  StreamSubscription<MouseEvent> _trackEndSubscr;

  bool active = false;

  Element _host;

  Splitter(ElementRef e) : _host = e.nativeElement;

  /// When dragging starts, cache the target's size and temporarily subscribe
  /// to necessary events to track dragging.
  @HostListener('mousedown', const [r'$event'])
  void trackStart(MouseEvent e) {
    if (_trackSubscr != null) {
      _trackSubscr.cancel();
      _trackSubscr = null;
      _trackEndSubscr.cancel();
      _trackEndSubscr = null;
    }

    if (e.button == 0) {
      // Make active regardless of [locked], to appear responsive.
      active = true;

      if (!locked) {
        // To avoid sticky dragging state
        _trackSubscr = _host.parent.onMouseMove.listen(track);
        _trackEndSubscr = document.onMouseUp.listen(trackEnd);
      }
    }
  }

  /// While dragging, update the target's size based on the mouse movement.
  void track(MouseEvent e) {
    // Recheck [locked], in case it's been changed externally in mid-flight.
    if (!locked) {
      final Element prev = _host.previousElementSibling;
      final Element next = _host.nextElementSibling;

      int offset = horizontal ? e.offset.y : e.offset.x;

      final Element ct = e.target as Element;
      offset += horizontal ? ct.offsetTop : ct.offsetLeft;

      offset -= horizontal ? prev.offsetTop : prev.offsetLeft;

      final event = new SplitterSlideEvent(
          this,
          horizontal ? e.movement.y : e.movement.x,
          offset,
          horizontal ? e.client.y : e.client.x,
          horizontal);
      _slideEventController.add(event);

      if (horizontal) {
        final int total =
            prev.clientHeight + next.clientHeight + _host.clientHeight;
        int firstHeightUpd = event.offsetPos - (_host.clientHeight ~/ 2);
        final int secondHeightUpd =
            total - event.offsetPos - (_host.clientHeight ~/ 2);
        firstHeightUpd +=
            total - (firstHeightUpd + secondHeightUpd + _host.clientHeight);
        prev.style.height = '${firstHeightUpd}px';
        next.style.height = '${secondHeightUpd}px';
      } else {
        final int total =
            prev.clientWidth + next.clientWidth + _host.clientWidth;
        int firstWidthUp = event.offsetPos - (_host.clientWidth ~/ 2);
        final int secondWidthUpd =
            total - event.offsetPos - (_host.clientWidth ~/ 2);
        firstWidthUp +=
            total - (firstWidthUp + secondWidthUpd + _host.clientWidth);
        prev.style.width = '${firstWidthUp}px';
        next.style.width = '${secondWidthUpd}px';
      }
    }
  }

  /// When dragging stops, unsubscribe from monitoring dragging events except
  /// the starting one.
  void trackEnd(MouseEvent e) {
    // Do this regardless of [locked]. The only case [locked] can be true here
    // is when it's been changed externally in mid-flight. If it's already true
    // when onMouseDown is fired, these subsciptions (and this event handler!)
    // are not activated in the first place.

    if (_trackSubscr != null) {
      _trackSubscr.cancel();
      _trackSubscr = null;
      _trackEndSubscr.cancel();
      _trackEndSubscr = null;
    }

    active = false;
  }

  final _slideEventController =
      new StreamController<SplitterSlideEvent>.broadcast();

  /// Event fired when the splitter is slided
  // @Output()
  // Stream<SplitterSlideEvent> get slide => _slideEventController.stream;
}

class SplitterSlideEvent {
  /// The splitter emitting the event
  final Splitter target;

  /// The amount of change
  final int delta;

  /// The offset position
  final int offsetPos;

  /// The client position
  final int clientPos;

  /// The orientation of the splitter
  final bool horizontal;

  SplitterSlideEvent(
      this.target, this.delta, this.offsetPos, this.clientPos, this.horizontal);
}
