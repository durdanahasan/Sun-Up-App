import Foundation

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let service: any AuthServiceProtocol

    init(service: any AuthServiceProtocol) { self.service = service }
    var isValid: Bool { email.contains("@") && email.contains(".") && password.count >= 6 }

    func login() async -> User? {
        guard isValid else { return nil }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { return try await service.login(email: email, password: password) }
        catch { errorMessage = error.localizedDescription; return nil }
    }
}

@MainActor
final class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var isPasswordVisible = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    private let service: any AuthServiceProtocol

    init(service: any AuthServiceProtocol) { self.service = service }
    var isValid: Bool { fullName.trimmingCharacters(in: .whitespaces).count >= 2 && email.contains("@") && email.contains(".") && password.count >= 6 }

    func signUp() async -> User? {
        guard isValid else { return nil }
        isLoading = true; errorMessage = nil
        defer { isLoading = false }
        do { return try await service.signUp(fullName: fullName, email: email, password: password) }
        catch { errorMessage = error.localizedDescription; return nil }
    }
}

@MainActor
final class ForgotPasswordViewModel: ObservableObject {
    enum Step { case email, verification, newPassword, success }
    @Published var step: Step = .email
    @Published var email = ""
    @Published var code = ""
    @Published var newPassword = ""
    @Published var confirmPassword = ""
    @Published var secondsRemaining = 54
    @Published var errorMessage: String?
    private var resetToken = ""
    private let service: any AuthServiceProtocol

    init(service: any AuthServiceProtocol) { self.service = service }
    var isEmailValid: Bool { email.contains("@") && email.contains(".") }
    var passwordsAreValid: Bool { newPassword.count >= 6 && newPassword == confirmPassword }

    func sendCode() async {
        guard isEmailValid else { return }
        do { try await service.requestPasswordReset(email: email); step = .verification; startCountdown() }
        catch { errorMessage = error.localizedDescription }
    }

    func verify() async {
        guard code.count == 6 else { return }
        do { resetToken = try await service.verifyResetCode(code, email: email); step = .newPassword }
        catch { errorMessage = error.localizedDescription }
    }

    func reset() async {
        guard passwordsAreValid else { errorMessage = "Passwords don't match"; return }
        do { try await service.resetPassword(newPassword, token: resetToken); step = .success }
        catch { errorMessage = error.localizedDescription }
    }

    func resend() async { code = ""; secondsRemaining = 54; await sendCode() }

    private func startCountdown() {
        Task { [weak self] in
            while let self, self.step == .verification, self.secondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                self.secondsRemaining -= 1
            }
        }
    }
}
