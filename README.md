# Understanding PreferenceKey in SwiftUI

## The Secret Sauce for Passing Data Up the View Hierarchy

If you’ve ever worked with SwiftUI, you probably know that data flows *down* the view tree really well — like with `@State`, `@Binding`, `@ObservedObject`, etc. But what if you need to pass data **up** the view hierarchy?

That’s where **`PreferenceKey`** comes in — the mighty hero of SwiftUI that lets child views send data back to their ancestors.

Let’s unpack what it is, when to use it, and some neat edge cases you might run into.

---

## 🤔 What is a `PreferenceKey`?

In short, a `PreferenceKey` is a protocol you conform to when you want a child view to communicate something **upward** to its parent.

It’s kinda like:

> "Hey, dad! Here's some info you might wanna know!"
> 

### The `PreferenceKey` protocol requires:

```swift
static var defaultValue: Value { get }
static func reduce(value: inout Value, nextValue: () -> Value)

```

- `defaultValue`: The default value if nothing is set.
- `reduce`: This combines values when multiple children provide them — think like a fold operation.

---

## 🧠 Simple Example: Getting a Child View's Size

Let’s say you want to know the size of a child view — maybe to adjust a parent layout dynamically.

### Step 1: Define the Preference Key

```swift
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

```

### Step 2: Apply a `GeometryReader` and set the preference

```swift
struct MyChildView: View {
    var body: some View {
        Text("Hello")
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SizePreferenceKey.self, value: proxy.size)
                }
            )
    }
}

```

### Step 3: Use `.onPreferenceChange` in the parent

```swift
struct MyParentView: View {
    @State private var size: CGSize = .zero

    var body: some View {
        VStack {
            MyChildView()
                .onPreferenceChange(SizePreferenceKey.self) { newSize in
                    size = newSize
                }

            Text("Child size: \(Int(size.width)) x \(Int(size.height))")
        }
    }
}

```

Boom 💥! Now the parent knows how big the child is.

---

## 🔁 The `reduce` Function: Merging Values from Many Children

Here’s the twist: if multiple child views set a preference, the `reduce` method decides how to merge them.

Imagine you want to collect all the titles from a bunch of views:

```swift
struct TitlePreferenceKey: PreferenceKey {
    static var defaultValue: [String] = []

    static func reduce(value: inout [String], nextValue: () -> [String]) {
        value.append(contentsOf: nextValue())
    }
}

```

Each child view sets a title:

```swift
Text("Item 1")
    .preference(key: TitlePreferenceKey.self, value: ["Item 1"])

```

The parent gets the whole array. 🎉

---

## 🧩 Use Cases

Here are some real-world scenarios where `PreferenceKey` shines:

- **Sticky headers**: Get the position of a scroll view section header.
- **Tab bar / custom navigation**: Let inner views control outer UI (e.g., hide/show tab bar).
- **Alignment tricks**: Pass alignment guides from children to help the parent line things up.
- **Offset detection**: Know when a view scrolls offscreen.

---

## ⚠️ Gotchas and Special Cases

1. **You can’t read preferences during the layout pass.** You need to use `.onPreferenceChange` — which is kinda like a reactive callback, not synchronous.
2. **You can't use preferences like bindings.** They're more like “notifications” going up — not a way to constantly sync state both ways.
3. **Preferences don't update immediately.** SwiftUI will schedule an update pass, so don’t expect it to fire instantly on a frame change.
4. **GeometryReader inside .background is the best combo.** Use it to measure views without affecting layout.

---

## 🧙‍♂️ Bonus Trick: Creating Your Own Custom Alignment

You can mix `PreferenceKey` with `AnchorPreference` and `alignmentGuide` to create complex layouts — but that’s a topic for another day unless you’re feeling brave 😄.

---

## 🏁 TL;DR

- `PreferenceKey` helps child views pass data up to parent views.
- It’s great for layout info, scroll tracking, and collecting values.
- You define a custom key, set preferences in children, and read them in parents.
- It’s a one-way upward data channel — not meant for syncing or bindings.

There is an [article (https://medium.com/@edu.hoyos/understanding-preferencekey-in-swiftui-4e9946ec6a4a)][article] on this
