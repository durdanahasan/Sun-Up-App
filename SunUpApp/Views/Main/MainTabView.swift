import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var session: AppSession
    @State private var selection = 0

    var body: some View {
        TabView(selection: $selection) {
            NavigationStack { HomeView(viewModel: .init(service: session.dependencies.beachService)) }.tabItem { Label("Home", systemImage: selection == 0 ? "house.fill" : "house") }.tag(0)
            NavigationStack { MapScreen(viewModel: .init(service: session.dependencies.beachService)) }.tabItem { Label("Map", systemImage: selection == 1 ? "mappin.circle.fill" : "mappin.circle") }.tag(1)
            NavigationStack { OrdersView(viewModel: .init(service: session.dependencies.orderService)) }.tabItem { Label("Orders", systemImage: selection == 2 ? "bag.fill" : "bag") }.tag(2)
            NavigationStack { SettingsView() }.tabItem { Label("Settings", systemImage: selection == 3 ? "gearshape.fill" : "gearshape") }.tag(3)
        }.tint(.black)
    }
}
