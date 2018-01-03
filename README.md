# Splitter

Provides a splitter component for Angular Dart

# Demo

+ [Vertical layout](https://tejainece.github.com/webide_splitter/web/vertical)
+ [Horizontal layout](https://tejainece.github.com/webide_splitter/web/horizontal)
+ [Nested layout](https://tejainece.github.com/webide_splitter/web/nested)

# Simple example

```dart
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
      height: 50%;
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
class AppComponent {}
```

More examples:

+ [Vertical]()
+ [Horizontal]()
+ [Nested]()

# Usage

## Parent

### Layout
Parent must use flex layout. The direction of flex layout must be chosen
depending on the orientation of the panel layout.

For vertical layout,

```css
    .container {
      display: flex;
      flex-direction: row;
    }
```

For horizontal layout,

```css
    .container {
      display: flex;
      flex-direction: column;
    }
```

### Size
Parent must have defined size.

```
    .container {
      width: 50%;
      height: 100%;
    }
```

## Children/panels

Children's tran-section size must fill the parent. Care must be taken that
splitter's transaction size is deducted.

Children's cross-section size must fill the parent.

For vertical layout,

```
    .panel {
      height: 100%;
      width: calc((100% - 14px) / 3);
    }
```

For horizontal layout,

```
    .panel {
      width: 100%;
      height: calc((100% - 14px) / 3);
    }
```