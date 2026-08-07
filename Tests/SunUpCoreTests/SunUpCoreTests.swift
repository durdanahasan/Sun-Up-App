import XCTest
@testable import SunUpCore

final class SunUpCoreTests: XCTestCase {
    func testMockCatalogMatchesDesign() async throws {
        let service = MockBeachService()
        let kits = try await service.fetchKits()
        let beaches = try await service.fetchBeaches()
        XCTAssertEqual(kits.map(\.priceAED), [30, 50])
        XCTAssertEqual(beaches.first?.name, "JBR Beach")
    }

    func testOrderCalculatesDynamicTotal() {
        let order = MockData.orders[0]
        XCTAssertEqual(order.totalAED, 80)
    }

    func testDependencyContainerUsesMocks() async throws {
        let dependencies = AppDependencies.make(useMockData: true)
        let beaches = try await dependencies.beachService.fetchBeaches()
        XCTAssertEqual(beaches.count, 3)
    }
}
