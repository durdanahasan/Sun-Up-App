import SwiftUI

@main
struct SunUpApp: App {
    @StateObject private var session = AppSession(dependencies: .make())

    init() {
        AppFontRegistrar.registerFonts()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(session)
                .preferredColorScheme(.light)
        }
    }
}

@MainActor
final class AppSession: ObservableObject {
    enum Route { case splash, login, signUp, forgotPassword, main }
    @Published var route: Route = .splash
    @Published var user: User?
    let dependencies: AppDependencies

    init(dependencies: AppDependencies) { self.dependencies = dependencies }

    func authenticate(_ user: User) { self.user = user; route = .main }
    func logOut() { user = nil; route = .splash }
}

struct RootView: View {
    @EnvironmentObject private var session: AppSession

    var body: some View {
        Group {
            switch session.route {
            case .splash: SplashView()
            case .login: LoginView(viewModel: .init(service: session.dependencies.authService))
            case .signUp: SignUpView(viewModel: .init(service: session.dependencies.authService))
            case .forgotPassword: ForgotPasswordFlow(viewModel: .init(service: session.dependencies.authService))
            case .main: MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.2), value: session.route)
    }
}
