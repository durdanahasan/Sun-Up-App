import SwiftUI

struct SplashView: View {
    @EnvironmentObject private var session: AppSession
    var body: some View {
        ZStack {
            SunUpTheme.yellow.ignoresSafeArea()
            Circle().fill(.white.opacity(0.12)).frame(width: 430).offset(x: 140, y: -110)
            Image(systemName: "beach.umbrella.fill").font(.system(size: 220)).foregroundStyle(.orange.opacity(0.28)).rotationEffect(.degrees(-12)).offset(x: 80, y: -80)
            VStack(alignment: .leading, spacing: 16) {
                Spacer()
                Text("Beach ready,\nwithout the bags.").font(.sunUpTitle()).lineSpacing(-2)
                PrimaryButton(title: "Continue with email", backgroundColor: .white) { session.route = .signUp }
                PrimaryButton(title: "I already have account") { session.route = .login }
            }.padding(24).padding(.bottom, 30)
        }
    }
}
