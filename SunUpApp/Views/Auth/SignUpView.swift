import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var session: AppSession
    @StateObject var viewModel: SignUpViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Create account").font(.sunUpTitle()).padding(.top, 20)
            Text("Enter your name, email and password to create an account").fontWeight(.semibold).foregroundStyle(SunUpTheme.secondaryText)
            IconTextField(icon: "person", placeholder: "Full name", text: $viewModel.fullName, revealSecure: .constant(true))
            IconTextField(icon: "envelope", placeholder: "Email", text: $viewModel.email, revealSecure: .constant(true), keyboard: .emailAddress)
            IconTextField(icon: "lock", placeholder: "Password", text: $viewModel.password, isSecure: true, revealSecure: $viewModel.isPasswordVisible)
            HStack(spacing: 4) { Text("Already have an account?"); Button("Log in") { session.route = .login }.foregroundStyle(SunUpTheme.teal).fontWeight(.bold) }.font(.subheadline).frame(maxWidth: .infinity)
            ErrorText(message: viewModel.errorMessage)
            Spacer()
            PrimaryButton(title: "Sign up", isEnabled: viewModel.isValid, isLoading: viewModel.isLoading) { Task { if let user = await viewModel.signUp() { session.authenticate(user) } } }
        }.padding(20).background(SunUpTheme.background.ignoresSafeArea())
    }
}
