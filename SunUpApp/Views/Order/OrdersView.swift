import SwiftUI

struct OrdersView: View {
    @StateObject var viewModel: OrdersViewModel
    var body: some View {
        VStack(spacing: 0) {
            HStack { Text("Your orders").font(.sunUpTitle(34)); Spacer() }.padding(.horizontal, 20).padding(.top, 72).padding(.bottom, 28).background(SunUpTheme.yellow).clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 34, bottomTrailingRadius: 34))
            ScrollView {
                LazyVStack(spacing: 14) {
                    ForEach(viewModel.orders) { order in
                        NavigationLink { OrderDetailView(order: order) } label: {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack { Image(systemName: "beach.umbrella.fill").frame(width: 54, height: 54).background(SunUpTheme.yellow.opacity(0.25)).clipShape(RoundedRectangle(cornerRadius: 12)); Text(order.beach.name).font(.headline); Spacer(); Text(order.totalAED.aed).font(.headline).foregroundStyle(SunUpTheme.teal) }
                                Text("\(order.reference)  •  \(order.items.reduce(0) { $0 + $1.quantity }) kits  •  \(order.deliveryDate.formatted(date: .abbreviated, time: .shortened))").font(.subheadline).foregroundStyle(.secondary)
                                HStack { StatusBadge(status: order.status); Spacer(); Image(systemName: "chevron.right") }
                            }.padding(15).background(.white).clipShape(RoundedRectangle(cornerRadius: 17)).foregroundStyle(.black)
                        }.buttonStyle(.plain)
                    }
                    ErrorText(message: viewModel.errorMessage)
                }.padding(18)
            }
        }.background(SunUpTheme.background).ignoresSafeArea(edges: .top).navigationBarHidden(true).task { await viewModel.load() }.refreshable { await viewModel.load() }
    }
}
