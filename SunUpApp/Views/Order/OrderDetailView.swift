import SwiftUI

struct OrderDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let order: Order
    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Order \(order.reference)", backAction: { dismiss() })
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    HStack { Image(systemName: "beach.umbrella.fill").frame(width: 52, height: 52).background(SunUpTheme.yellow.opacity(0.25)).clipShape(RoundedRectangle(cornerRadius: 11)); VStack(alignment: .leading) { Text(order.beach.name).font(.sunUpCardTitle()); Text(order.deliveryDate.formatted(date: .abbreviated, time: .shortened)).foregroundStyle(.secondary) }; Spacer(); StatusBadge(status: order.status) }.padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("Delivery status").font(.headline).foregroundStyle(.secondary)
                    OrderTimeline(status: order.status)
                    Text("Kits ordered").font(.headline).foregroundStyle(.secondary)
                    VStack(spacing: 12) { ForEach(order.items) { item in HStack { Text("\(item.kit.name)   x \(item.quantity)"); Spacer(); Text(item.subtotal.aed) } }; Divider(); if order.deliveryFeeAED > 0 { HStack { Text("Delivery fee"); Spacer(); Text(order.deliveryFeeAED.aed) } }; Divider(); HStack { Text("Total").fontWeight(.heavy); Spacer(); Text(order.totalAED.aed).fontWeight(.heavy) } }.padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
                    Text("Details").font(.headline).foregroundStyle(.secondary)
                    detailRow("clock", "Delivery time", order.deliveryDate.formatted(date: .omitted, time: .shortened))
                    detailRow("banknote", "Payment", paymentName)
                    detailRow("tag", "Order id", order.reference)
                    if let runner = order.runner { RunnerCard(runner: runner) }
                }.padding(18)
            }
        }.background(SunUpTheme.background).ignoresSafeArea(edges: .top).navigationBarHidden(true)
    }
    private var paymentName: String { switch order.paymentMethod { case .applePay: "Apple Pay"; case .cash: "Cash on delivery"; case .card: "Card" } }
    private func detailRow(_ icon: String, _ label: String, _ value: String) -> some View { HStack { Image(systemName: icon).foregroundStyle(.secondary); Text(label).foregroundStyle(.secondary); Spacer(); Text(value).fontWeight(.semibold) }.padding().frame(height: 60).background(.white).clipShape(RoundedRectangle(cornerRadius: 15)).overlay(RoundedRectangle(cornerRadius: 15).stroke(.gray.opacity(0.35))) }
}

struct OrderTimeline: View {
    let status: OrderStatus
    private var currentIndex: Int { OrderStatus.allCases.firstIndex(of: status) ?? 0 }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(OrderStatus.allCases.enumerated()), id: \.offset) { index, step in
                HStack(spacing: 16) {
                    VStack(spacing: 0) {
                        Image(systemName: index <= currentIndex ? "checkmark.circle.fill" : "circle.fill")
                            .font(.title)
                            .foregroundStyle(index <= currentIndex ? SunUpTheme.teal : .gray.opacity(0.4))
                        if index < OrderStatus.allCases.count - 1 {
                            Rectangle()
                                .fill(index < currentIndex ? SunUpTheme.teal : Color.gray.opacity(0.3))
                                .frame(width: 2, height: 34)
                        }
                    }
                    Text(step.displayName)
                        .fontWeight(index == currentIndex ? .bold : .regular)
                        .foregroundStyle(index <= currentIndex ? .primary : .secondary)
                    Spacer()
                }
            }
        }
    }
}

struct RunnerCard: View {
    let runner: Runner
    var body: some View { HStack { Image(systemName: "figure.outdoor.cycle").frame(width: 50, height: 50).background(SunUpTheme.yellow.opacity(0.25)).clipShape(RoundedRectangle(cornerRadius: 12)); VStack(alignment: .leading) { Text("\(runner.name), your runner").fontWeight(.bold); Text("\(runner.transport)  •  \(runner.rating, specifier: "%.1f") rating").font(.caption).foregroundStyle(.secondary) }; Spacer(); Link(destination: URL(string: "tel:\(runner.phoneNumber)")!) { Image(systemName: "phone").padding(10).background(SunUpTheme.yellow.opacity(0.2)).clipShape(Circle()).foregroundStyle(.black) }; Link(destination: URL(string: "sms:\(runner.phoneNumber)")!) { Image(systemName: "message").padding(10).background(SunUpTheme.yellow.opacity(0.2)).clipShape(Circle()).foregroundStyle(.black) } }.padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 16)) }
}
