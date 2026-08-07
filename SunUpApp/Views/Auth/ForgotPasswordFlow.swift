import SwiftUI

struct ForgotPasswordFlow: View {
    @EnvironmentObject private var session: AppSession
    @StateObject var viewModel: ForgotPasswordViewModel
    @State private var revealPassword = false
    @State private var revealConfirmation = false

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if viewModel.step != .success { Button { goBack() } label: { Image(systemName: "arrow.left").foregroundStyle(.black) }.padding(.top, 20) }
            switch viewModel.step {
            case .email: emailStep
            case .verification: verificationStep
            case .newPassword: passwordStep
            case .success: successStep
            }
        }.padding(20).background(SunUpTheme.background.ignoresSafeArea())
    }

    private var emailStep: some View {
        Group {
            Text("Forgot password").font(.sunUpTitle(34))
            Text("Enter your email and we will send an OTP code to your email address").foregroundStyle(.secondary)
            IconTextField(icon: "envelope", placeholder: "Email", text: $viewModel.email, revealSecure: .constant(true), keyboard: .emailAddress)
            ErrorText(message: viewModel.errorMessage); Spacer()
            PrimaryButton(title: "Continue", isEnabled: viewModel.isEmailValid) { Task { await viewModel.sendCode() } }
        }
    }

    private var verificationStep: some View {
        Group {
            Text("Verification code").font(.sunUpTitle(34))
            Text("We've sent a 6-digit verification code to \(viewModel.email). Please enter it below to continue.").foregroundStyle(.secondary)
            TextField("000000", text: $viewModel.code).keyboardType(.numberPad).multilineTextAlignment(.center).font(.title2.monospaced().bold()).tracking(18).padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 14)).onChange(of: viewModel.code) { _, value in viewModel.code = String(value.filter(\.isNumber).prefix(6)) }
            VStack { Text(viewModel.secondsRemaining > 0 ? "You can request a new code once the timer ends" : "Didn't receive a code?").font(.caption).foregroundStyle(.secondary); if viewModel.secondsRemaining > 0 { Text(String(format: "00:%02d", viewModel.secondsRemaining)).font(.caption.bold()) } else { Button("Resend code") { Task { await viewModel.resend() } }.font(.caption.bold()).foregroundStyle(.black) } }.frame(maxWidth: .infinity)
            ErrorText(message: viewModel.errorMessage); Spacer()
            PrimaryButton(title: "Continue", isEnabled: viewModel.code.count == 6) { Task { await viewModel.verify() } }
        }
    }

    private var passwordStep: some View {
        Group {
            Text("Set new password").font(.sunUpTitle(34))
            Text("Your identity has been verified. Please create a new password for your account.").foregroundStyle(.secondary)
            IconTextField(icon: "lock", placeholder: "New password", text: $viewModel.newPassword, isSecure: true, revealSecure: $revealPassword)
            IconTextField(icon: "lock", placeholder: "Confirm new password", text: $viewModel.confirmPassword, isSecure: true, revealSecure: $revealConfirmation)
            ErrorText(message: viewModel.errorMessage); Spacer()
            PrimaryButton(title: "Reset password", isEnabled: viewModel.newPassword.count >= 6 && viewModel.confirmPassword.count >= 6) { Task { await viewModel.reset() } }
        }
    }

    private var successStep: some View {
        VStack(spacing: 14) {
            Spacer(); Image(systemName: "checkmark").font(.title.bold()).foregroundStyle(.white).frame(width: 58, height: 58).background(SunUpTheme.teal).clipShape(Circle())
            Text("Password updated").font(.title3.bold())
            Text("Your password has been changed successfully. You can now log in with your new password.").font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
            Spacer(); PrimaryButton(title: "Back to login") { session.route = .login }
        }.frame(maxWidth: .infinity)
    }

    private func goBack() {
        switch viewModel.step { case .email: session.route = .login; case .verification: viewModel.step = .email; case .newPassword: viewModel.step = .verification; case .success: break }
    }
}
