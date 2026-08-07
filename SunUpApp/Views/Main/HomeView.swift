import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var session: AppSession
    @StateObject var viewModel: HomeViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 18) {
                    HStack { Image(systemName: "person.circle"); Text(session.user?.fullName ?? MockData.user.fullName).font(.subheadline); Spacer(); NavigationLink { NotificationsView(viewModel: .init(service: session.dependencies.notificationService)) } label: { Image(systemName: "bell") }.foregroundStyle(.black) }
                    Text("Which beach today?").font(.sunUpTitle(32))
                    HStack { Image(systemName: "location"); TextField("Search beach", text: $viewModel.search); if !viewModel.search.isEmpty { Button { viewModel.search = "" } label: { Image(systemName: "xmark") } } }.padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 14)).foregroundStyle(.black)
                }.padding(20).background(SunUpTheme.yellow).clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 32, bottomTrailingRadius: 32))

                VStack(alignment: .leading, spacing: 18) {
                    if viewModel.search.isEmpty {
                        HStack(alignment: .top, spacing: 12) { ForEach(viewModel.kits) { KitCardView(kit: $0) } }
                    }
                    Text(viewModel.search.isEmpty ? "Nearby beaches" : "Search results").font(.headline).foregroundStyle(.secondary)
                    ForEach(viewModel.filteredBeaches) { beach in
                        NavigationLink { CheckoutView(viewModel: .init(beach: beach, kits: viewModel.kits, service: session.dependencies.orderService)) } label: { BeachRow(beach: beach) }.buttonStyle(.plain)
                    }
                    ErrorText(message: viewModel.errorMessage)
                }.padding(16)
            }
        }.background(SunUpTheme.background).ignoresSafeArea(edges: .top).task { await viewModel.load() }.navigationBarHidden(true)
    }
}



