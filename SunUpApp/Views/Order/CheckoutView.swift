import SwiftUI

struct CheckoutView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CheckoutViewModel
    @State private var showTracking = false
    private let times = ["Now (15 min)", "11:00", "12:00", "14:00"]

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    BeachRow(beach: viewModel.beach).padding(.top, 12)
                    sectionTitle("Choose your kit")
                    HStack(alignment: .top, spacing: 12) { ForEach(viewModel.kits) { kit in KitCardView(kit: kit, quantity: viewModel.quantities[kit.id, default: 0], decrement: { viewModel.change(kit, by: -1) }, increment: { viewModel.change(kit, by: 1) }) } }
                    sectionTitle("Delivering time")
                    ScrollView(.horizontal, showsIndicators: false) { HStack { ForEach(times, id: \.self) { time in Button(time) { viewModel.selectedTime = time }.font(.subheadline).foregroundStyle(.black).padding(.horizontal, 14).frame(height: 43).background(viewModel.selectedTime == time ? SunUpTheme.yellow.opacity(0.15) : .white).clipShape(RoundedRectangle(cornerRadius: 11)).overlay(RoundedRectangle(cornerRadius: 11).stroke(viewModel.selectedTime == time ? .black : .clear)) } } }
                    sectionTitle("Add contact information")
                    TextField("Phone number", text: $viewModel.phoneNumber).keyboardType(.phonePad).padding().frame(height: 55).background(.white).clipShape(RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(.gray.opacity(0.5)))
                    TextField("Additional note", text: $viewModel.note, axis: .vertical).lineLimit(2...4).padding().frame(minHeight: 70, alignment: .top).background(.white).clipShape(RoundedRectangle(cornerRadius: 14)).overlay(RoundedRectangle(cornerRadius: 14).stroke(.gray.opacity(0.5)))
                    sectionTitle("Payment method")
                    HStack { paymentButton(.applePay, "apple.logo", "Apple Pay"); paymentButton(.cash, "banknote.fill", "Cash"); paymentButton(.card, "plus", "Add Card") }
                    sectionTitle("Your order")
                    VStack(spacing: 10) { ForEach(viewModel.items) { item in HStack { Text("\(item.kit.name)  x \(item.quantity)"); Spacer(); Text(item.subtotal.aed) } }; Divider(); HStack { Text("Total"); Spacer(); Text(viewModel.total.aed).fontWeight(.heavy) } }.font(.subheadline).padding().background(.white).clipShape(RoundedRectangle(cornerRadius: 15))
                    ErrorText(message: viewModel.errorMessage)
                }.padding(16)
            }
            PrimaryButton(title: "Continue checkout", isEnabled: viewModel.canCheckout) { Task { await viewModel.submit(); showTracking = viewModel.createdOrder != nil } }.padding(16).background(SunUpTheme.background)
        }.background(SunUpTheme.background).navigationTitle("Select kit and order").navigationBarTitleDisplayMode(.inline).navigationDestination(isPresented: $showTracking) { if let order = viewModel.createdOrder { DeliveryTrackingView(order: order) } }
    }
    private func sectionTitle(_ text: String) -> some View { Text(text).font(.subheadline).foregroundStyle(.secondary) }
    private func paymentButton(_ method: PaymentMethod, _ icon: String, _ title: String) -> some View { Button { viewModel.paymentMethod = method } label: { VStack(spacing: 8) { Image(systemName: icon).font(.title3); Text(title).font(.caption) }.frame(maxWidth: .infinity).frame(height: 72).foregroundStyle(.black).background(viewModel.paymentMethod == method ? SunUpTheme.yellow.opacity(0.15) : .white).clipShape(RoundedRectangle(cornerRadius: 13)).overlay(RoundedRectangle(cornerRadius: 13).stroke(viewModel.paymentMethod == method ? .black : .clear)) } }
}

struct DeliveryTrackingView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var status: OrderStatus
    let order: Order
    init(order: Order) { self.order = order; _status = State(initialValue: order.status) }
    var body: some View {
        VStack(spacing: 0) {
            ScreenHeader(title: "Order \(order.reference)")
            VStack(spacing: 25) {
                Image(systemName: status == .delivered ? "checkmark" : "shippingbox.fill").font(.largeTitle.bold()).foregroundStyle(.white).frame(width: 64, height: 64).background(SunUpTheme.teal).clipShape(Circle()).padding(.top, 28)
                Text(status == .delivered ? "Delivered to spot" : status.displayName).font(.sunUpTitle(26))
                Text("Order \(order.reference)  •  \(order.beach.name)").foregroundStyle(.secondary)
                OrderTimeline(status: status)
                if let runner = order.runner { RunnerCard(runner: runner) }
                Text("Total paid \(order.totalAED.aed)  •  \(order.paymentMethod == .cash ? "Cash" : "Card")").font(.subheadline).foregroundStyle(.secondary)
                Spacer()
                PrimaryButton(title: status == .delivered ? "Done" : "Refresh status") { if status == .delivered { dismiss() } else { advance() } }
            }.padding(20)
        }.background(SunUpTheme.background).ignoresSafeArea(edges: .top).navigationBarBackButtonHidden(true)
    }
    private func advance() { let all = OrderStatus.allCases; if let index = all.firstIndex(of: status), index + 1 < all.count { withAnimation { status = all[index + 1] } } }
}
