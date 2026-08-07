import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: AppSession
    @StateObject var viewModel: LoginViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Log in").font(.sunUpTitle()).padding(.top, 48)
            Text("Enter your email and password to log in").fontWeight(.semibold).foregroundStyle(SunUpTheme.secondaryText)
            IconTextField(icon: "envelope", placeholder: "Email", text: $viewModel.email, revealSecure: .constant(true), keyboard: .emailAddress)
            IconTextField(icon: "lock", placeholder: "Password", text: $viewModel.password, isSecure: true, revealSecure: $viewModel.isPasswordVisible)
            Button("Forgot password") { session.route = .forgotPassword }.font(.caption.bold()).foregroundStyle(.black).frame(maxWidth: .infinity, alignment: .trailing)
            HStack(spacing: 4) { Text("Don't have an account?"); Button("Sign up") { session.route = .signUp }.foregroundStyle(SunUpTheme.teal).fontWeight(.bold) }.font(.subheadline).frame(maxWidth: .infinity)
            ErrorText(message: viewModel.errorMessage)
            Spacer()
            PrimaryButton(title: "Login", isEnabled: viewModel.isValid, isLoading: viewModel.isLoading) { Task { if let user = await viewModel.login() { session.authenticate(user) } } }
        }.padding(20).background(SunUpTheme.background.ignoresSafeArea())
    }
}
