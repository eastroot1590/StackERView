# StackERView

[![CI Status](https://img.shields.io/travis/eastroot1590@gmail.com/StackERView.svg?style=flat)](https://travis-ci.org/eastroot1590@gmail.com/StackERView)
[![Version](https://img.shields.io/cocoapods/v/StackERView.svg?style=flat)](https://cocoapods.org/pods/StackERView)
[![License](https://img.shields.io/cocoapods/l/StackERView.svg?style=flat)](https://cocoapods.org/pods/StackERView)
[![Platform](https://img.shields.io/cocoapods/p/StackERView.svg?style=flat)](https://cocoapods.org/pods/StackERView)

## Requirements

- Swift Version : 5.0
- iOS deployment target : 13.0

## Installation

StackERView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'StackERView'
```

## Example 

### VStackERView

You can simply add vertical stack laoyut by code.

```swift
let stack = VStackERView()
stack.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(stack)
NSLayoutConstraint.activate([
    stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

it's empty at first, you can add any `UIView` into stack by code.

```swift
let label = UILabel()
label.text = "Hello StackERView"
stack.push(label)
```

<center><img src="https://user-images.githubusercontent.com/71330311/140025738-2dff38c4-b9fb-444a-b015-4368cc509ad8.png" height="700"></center>

can `push` image too. and you can set space between current pushing view and old view. this can be deferent every stack nodes.

```swift
let image = UIImageView(image: UIImage(named: "sample"))
stack.push(image, spacing: 50)
```

<center><img src="https://user-images.githubusercontent.com/71330311/140026625-9bed6c1e-49c1-4ae7-9bfa-298ae9137dcf.png" height="700"></center>

### HStackERView

basically it's almost same with `VStackERView` but this stack the nodes **horizontally**

```swift
let stack = HStackERView()
stack.backgroundColor = .systemBlue
stack.translatesAutoresizingMaskIntoConstraints = false
view.addSubview(stack)
NSLayoutConstraint.activate([
    stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
])
```

<center><img src="https://user-images.githubusercontent.com/71330311/140026698-13c835c3-f1f5-42b8-bd96-06abbc58fee2.png" height="700"></center>

both of StackERView can add separator between nodes

```swift
stack.separatorType = .line
```

<center><img src="https://user-images.githubusercontent.com/71330311/140026858-f3a90f1d-4c1a-4d7b-9df5-32c09297ab53.png" height="700"></center>

`StackERView` also can add another `StackERView`.

```swift
let otherStack = VStackERView()
stack.push(otherStack, spacing: 20)

for _ in 0 ..< 5 {
    let otherLabel = UILabel()
    otherLabel.text = "I'm in HStack"
    otherStack.push(otherLabel, spacing: 10)
}
```

<center><img src="https://user-images.githubusercontent.com/71330311/140026903-512f692c-6aee-4c9e-af1d-61f2fe2e5f6b.png" height="700"></center>

### StackERScrollView

if your contents of stack can be larger than screen, use `StackERScrollView`. it has almost same usage but scrollable.

## Author

eastroot1590@gmail.com, eastroot1590@gmail.com

## License

StackERView is available under the MIT license. See the LICENSE file for more info.
