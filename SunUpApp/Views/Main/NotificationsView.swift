import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: NotificationsViewModel
    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Notifications", backAction: { dismiss() })
            ScrollView { LazyVStack(spacing: 14) { ForEach(viewModel.notifications) { item in HStack(alignment: .top, spacing: 14) { Image(systemName: icon(for: item.kind)).font(.title3).frame(width: 50, height: 50).background(SunUpTheme.background).clipShape(RoundedRectangle(cornerRadius: 12)).overlay(RoundedRectangle(cornerRadius: 12).stroke(.gray.opacity(0.4))); VStack(alignment: .leading, spacing: 5) { Text(item.title).fontWeight(.heavy); Text(item.message).foregroundStyle(.secondary); Text(item.createdAt, style: .relative).font(.caption).foregroundStyle(.secondary) }; Spacer() }.padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16)) } }.padding(16) }
        }.background(SunUpTheme.background).ignoresSafeArea(edges: .top).navigationBarHidden(true).task { await viewModel.load() }
    }
    private func icon(for kind: NotificationKind) -> String { switch kind { case .order: "shippingbox"; case .promotion: "tag"; case .welcome: "sun.max" } }
}
