import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var session: AppSession
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Image(systemName: "person.crop.circle.fill").resizable().scaledToFit().frame(width: 104, height: 104).foregroundStyle(.white)
                Text(session.user?.fullName ?? MockData.user.fullName).font(.sunUpTitle(24))
            }.frame(maxWidth: .infinity).padding(.top, 70).padding(.bottom, 32).background(SunUpTheme.yellow).clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 36, bottomTrailingRadius: 36))
            VStack(spacing: 14) {
                SettingsRow(icon: "creditcard", title: "Payment method") {}
                SettingsRow(icon: "bell", title: "Notifications") {}
                SettingsRow(icon: "message", title: "Help and support") {}
                SettingsRow(icon: "rectangle.portrait.and.arrow.right", title: "Log out", destructive: true) { Task { try? await session.dependencies.authService.logout(); session.logOut() } }
            }.padding(18)
            Spacer()
        }.background(SunUpTheme.background).ignoresSafeArea(edges: .top).navigationBarHidden(true)
    }
}

private struct SettingsRow: View {
    let icon: String; let title: String; var destructive = false; let action: () -> Void
    var body: some View { Button(action: action) { HStack { Image(systemName: icon).font(.title3).frame(width: 52, height: 52).background((destructive ? Color.red : Color.gray).opacity(0.1)).clipShape(RoundedRectangle(cornerRadius: 13)); Text(title).font(.headline); Spacer(); Image(systemName: "chevron.right") }.foregroundStyle(destructive ? .red : .black).padding(.horizontal, 14).frame(height: 78).background(.white).clipShape(RoundedRectangle(cornerRadius: 17)) } }
}
