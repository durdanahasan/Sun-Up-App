# SUN UP iOS App

Complete SwiftUI implementation of the SUN UP beach-kit delivery flow. Open `SunUp.xcodeproj`, select the **SUN UP** scheme and an iPhone simulator, then Run.

```text
SwiftUI Views → ViewModels → Service Protocols ← Mock/API Services
                              ↓
                         Domain Models
```

- `Domain/Models`: UI- and transport-independent entities.
- `Domain/Services`: async protocol boundaries consumed by future ViewModels.
- `Data/Mock`: deterministic local fixtures and stateful actor-based services.
- `Data/API`: URLSession/async-await REST adapters.
- `App/AppEnvironment`: composition root and the single mock/API switch.
- `SunUpApp`: app entry point, MVVM presentation layer, reusable design system, authentication, tabs, checkout, tracking, notifications, orders and settings.

The mock password reset OTP is `402456`. The configured mock login is `durdanahasanova@gmail.com` with any password of at least six characters.

Run `swift test` to verify this layer independently of an Xcode project.
