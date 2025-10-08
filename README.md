# RippleModifier

A lightweight, customizable **Metal-powered ripple effect** for SwiftUI views — inspired by the smooth water-like animation seen in apps like Telegram for iOS.

---

## ✨ Features

- 🔮 Beautiful **real-time ripple animation** powered by Metal.
- 🪶 Lightweight — implemented as a single SwiftUI modifier.
- 🎛️ Customizable parameters (speed, chromatic aberration, ring thickness, intensity).
- 📱 Designed for **iOS**, written entirely in **Swift** and **Metal**.

---

## 🧩 Installation

### Swift Package Manager

Add `RippleModifier` directly from Xcode:

1. Go to **File ▸ Add Packages…**
2. Enter the repository URL:

   ```
   https://github.com/nozhana/RippleModifier.git
   ```

3. Add the package to your target.

---

## 🚀 Usage

```swift
import RippleModifier
import SwiftUI

struct ContentView: View {
    @State private var speed: Float = 1.0
    @State private var aberration: Float = 0.2
    @State private var ringThickness: Float = 0.45
    @State private var intensity: Float = 0.15
    
    var body: some View {
        Image("test")
            .resizable()
            .scaledToFit()
            .rippling(speed: speed, 
                      aberration: aberration,
                      ringThickness: ringThickness,
                      intensity: intensity)
    }
}
```

You can attach `RippleModifier` to **any SwiftUI View that can act as a drawingGroup**.

Beware that applying `RippleModifier` to navigation views and complex hierarchies will cause problems – for now.

---

## ⚙️ Customization

```swift
SomeView()
    .rippling(speed: speed, // how fast the ripple moves
              aberration: aberration, // the intensity of separation for RGB channels
              ringThickness: thickness, // the thickness of the bump in normalized coordinates (0...1)
              intensity: intensity) // the strength of the ripple, e.g. how far it "lifts" the view off the Z-axis
```

---

## 🧠 How It Works

The modifier uses a Metal fragment shader (`RippleShader.metal`) to distort the view’s texture in real time, based on a dynamic sine-wave pattern that radiates from the interaction point.

The Swift side manages the timing, event triggers, and Metal pipeline configuration.

---

## 🎥 Demo

https://raw.githubusercontent.com/nozhana/RippleModifier/refs/heads/main/Demo.mp4

---

## 🛠️ Project Structure

```
RippleModifier/
├── Package.swift
└── Sources/
    └── RippleModifier/
        ├── RippleModifier.swift      # SwiftUI modifier implementation
        ├── RippleShader.metal        # Metal shader logic
        └── Media.xcassets/           # Demo assets
```

---

## 💡 Inspiration

The ripple animation effect was inspired by **Telegram iOS**, where subtle physical motion adds delight and depth to user interactions.

---

## 🧑‍💻 Author

**Nozhan Amiri**  
iOS Developer & Shader Enthusiast  
[LinkedIn Profile](https://linkedin.com/in/nozhana) • [Twitter/X](https://x.com/get__swifty) • [ShaderToy](https://shadertoy.com/nozhana) 

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE.md) file for details.
