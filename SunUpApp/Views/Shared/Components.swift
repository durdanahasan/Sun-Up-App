import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isEnabled = true
    var isLoading = false
    var backgroundColor: Color = SunUpTheme.yellow
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group { if isLoading { ProgressView() } else { Text(title).fontWeight(.bold) } }
                .frame(maxWidth: .infinity).frame(height: 54)
                .background(isEnabled ? backgroundColor : Color.gray.opacity(0.25))
                .foregroundStyle(isEnabled ? .black : .gray)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(isEnabled ? Color.black : Color.clear))
        }.disabled(!isEnabled || isLoading)
    }
}

struct IconTextField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var isSecure = false
    @Binding var revealSecure: Bool
    var keyboard: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).frame(width: 20).foregroundStyle(.secondary)
            Group {
                if isSecure && !revealSecure { SecureField(placeholder, text: $text) }
                else { TextField(placeholder, text: $text).keyboardType(keyboard).textInputAutocapitalization(.never) }
            }
            if isSecure { Button { revealSecure.toggle() } label: { Image(systemName: revealSecure ? "eye" : "eye.slash").foregroundStyle(.black) } }
        }
        .padding(.horizontal, 16).frame(height: 56).background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16)).overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray.opacity(0.55)))
    }
}

struct ScreenHeader: View {
    let title: String
    var backAction: (() -> Void)?
    var body: some View {
        ZStack {
            SunUpTheme.yellow
            Text(title).font(.sunUpTitle(22))
            if let backAction { HStack { Button(action: backAction) { Image(systemName: "arrow.left").font(.title3).foregroundStyle(.black) }; Spacer() }.padding(.horizontal, 22) }
        }.frame(height: 115).clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 34, bottomTrailingRadius: 34))
    }
}

struct BeachRow: View {
    let beach: Beach
    var body: some View {
        HStack(spacing: 12) {
            ZStack { RoundedRectangle(cornerRadius: 10).fill(SunUpTheme.yellow.opacity(0.25)); Image(systemName: "beach.umbrella.fill").foregroundStyle(.orange) }.frame(width: 52, height: 52)
            VStack(alignment: .leading, spacing: 4) { Text(beach.name).font(.sunUpCardTitleBeach()); Text("\(beach.distanceKilometers, specifier: "%.1f") km  •  \(beach.deliveryMinutes) min delivery").font(.caption).foregroundStyle(.secondary) }
            Spacer(); Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }.padding(12).background(.white).clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

struct KitCardView: View {
    let kit: Kit
    var quantity: Int? = nil
    var decrement: (() -> Void)?
    var increment: (() -> Void)?
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack { Text("\(kit.peopleCount)").fontWeight(.bold).frame(width: 28, height: 28).background(SunUpTheme.teal).foregroundStyle(.white).clipShape(Circle()); Text(kit.name).font(.sunUpCardTitle()).minimumScaleFactor(0.8) }
            Divider()
            ForEach(kit.contents, id: \.name) { Text("\($0.quantity) \($0.name.lowercased())").font(.caption).foregroundStyle(.secondary) }
            HStack(alignment: .firstTextBaseline, spacing: 4) { Text(kit.priceAED.aed).fontWeight(.black); Text("/ for \(kit.peopleCount) people").font(.caption2).foregroundStyle(.secondary) }
            if let quantity, let decrement, let increment {
                HStack { circleButton("minus", action: decrement); Spacer(); Text("\(quantity)").fontWeight(.bold); Spacer(); circleButton("plus", filled: true, action: increment) }
            }
        }.padding(15).frame(maxWidth: .infinity, alignment: .leading).background(.white).clipShape(RoundedRectangle(cornerRadius: 16))
    }
    private func circleButton(_ icon: String, filled: Bool = false, action: @escaping () -> Void) -> some View {
        Button(action: action) { Image(systemName: icon).font(.caption.bold()).frame(width: 28, height: 28).background(filled ? SunUpTheme.yellow : SunUpTheme.background).clipShape(Circle()).foregroundStyle(.black) }
    }
}

struct StatusBadge: View {
    let status: OrderStatus
    var body: some View { Text(status == .delivered ? "Delivered" : status.displayName).font(.caption.bold()).foregroundStyle(status == .delivered ? .green : SunUpTheme.teal).padding(.horizontal, 12).padding(.vertical, 6).background((status == .delivered ? Color.green : SunUpTheme.teal).opacity(0.14)).clipShape(Capsule()) }
}

struct ErrorText: View {
    let message: String?
    var body: some View { if let message { Text(message).font(.caption).foregroundStyle(.red).frame(maxWidth: .infinity, alignment: .leading) } }
}
