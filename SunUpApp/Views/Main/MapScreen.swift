import SwiftUI
import MapKit

struct MapScreen: View {
    @EnvironmentObject private var session: AppSession
    @StateObject var viewModel: HomeViewModel
    @State private var selectedBeach: Beach?
    @State private var position: MapCameraPosition = .region(.init(center: .init(latitude: 25.12, longitude: 55.18), span: .init(latitudeDelta: 0.16, longitudeDelta: 0.16)))

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                ForEach(viewModel.beaches) { beach in
                    Annotation(beach.name, coordinate: .init(latitude: beach.coordinate.latitude, longitude: beach.coordinate.longitude)) {
                        Button { selectedBeach = beach } label: { Image(systemName: "star.fill").foregroundStyle(.white).padding(11).background(selectedBeach?.id == beach.id ? Color.orange : SunUpTheme.yellow).clipShape(.rect(topLeadingRadius: 20, bottomLeadingRadius: 20, bottomTrailingRadius: 20)).shadow(radius: 3) }
                    }
                }
            }.mapStyle(.standard(pointsOfInterest: .excludingAll)).ignoresSafeArea()
            VStack {
                HStack { Image(systemName: "location"); Text("\(viewModel.beaches.count) beaches near you").foregroundStyle(.secondary); Spacer() }.padding().frame(height: 62).background(.white).clipShape(RoundedRectangle(cornerRadius: 16)).padding(.horizontal, 18).padding(.top, 18)
                Spacer()
                if let beach = selectedBeach {
                    VStack(spacing: 14) {
                        HStack { Image(systemName: "beach.umbrella.fill").frame(width: 52, height: 52).background(SunUpTheme.yellow.opacity(0.3)).clipShape(RoundedRectangle(cornerRadius: 12)); VStack(alignment: .leading) { Text(beach.name).fontWeight(.heavy); Text("\(beach.distanceKilometers, specifier: "%.1f") km  •  \(beach.deliveryMinutes) min delivery  •  \(beach.rating, specifier: "%.1f") ★").font(.subheadline).foregroundStyle(.secondary) }; Spacer() }
                        NavigationLink { CheckoutView(viewModel: .init(beach: beach, kits: viewModel.kits, service: session.dependencies.orderService)) } label: { Text("Order here").fontWeight(.bold).frame(maxWidth: .infinity).frame(height: 50).background(SunUpTheme.yellow).foregroundStyle(.black).clipShape(RoundedRectangle(cornerRadius: 13)).overlay(RoundedRectangle(cornerRadius: 13).stroke(.black)) }
                    }.padding(16).background(.white).clipShape(RoundedRectangle(cornerRadius: 18)).padding(18)
                }
            }
        }.safeAreaInset(edge: .top, spacing: 0) { Color.clear.frame(height: 82).background(SunUpTheme.yellow) }.task { await viewModel.load() }.navigationBarHidden(true)
    }
}
