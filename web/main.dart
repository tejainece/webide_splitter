// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:webide_splitter/webide_splitter.dart';

@Component(
  selector: 'my-app',
  styles: const [
    '''
    :host {
      display: block;
      width: 100%;
      height: 100%;
    }
    
    .container {
      width: 50%;
      height: 100%;
      display: flex;
      flex-direction: row;
      background-color: black;
    }
    
    .panel {
      height: 100%;
      width: calc((100% - 14px) / 3);
    }
    '''
  ],
  template: r'''
  <div class="container">
    <div class="panel first" style="background-color: red;"></div>
    <splitter></splitter>
    <div class="panel second" style="background-color: blue;"></div>
    <splitter></splitter>
    <div class="panel third" style="background-color: green;"></div>
  </div>
  ''',
  directives: const [materialDirectives, Splitter],
  providers: const [materialProviders],
)
class AppComponent {
}

void main() {
  bootstrap(AppComponent);
}
