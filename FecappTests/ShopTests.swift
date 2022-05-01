//
//  ShopTests.swift
//  FecappTests
//
//  Created by Ezequiel Becerra on 23/04/2022.
//

import XCTest
@testable import Pluma
@testable import Fecapp

class ShopTests: XCTestCase {

    func testDecode() throws {
        let shop = try Pluma.defaultDecoder().decode(Shop.self, from: try! shopData())
        XCTAssertEqual(shop.id, 1)
        XCTAssertEqual(shop.slug, "tres")
        XCTAssertEqual(shop.title, "Tres")
        XCTAssertEqual(shop.address, "Teodoro García 2806")
        XCTAssertEqual(shop.coordinates.latitude, -34.5733)
        XCTAssertEqual(shop.coordinates.longitude, -58.4483)
        XCTAssertEqual(shop.instagram, "servimos.cafe")
        XCTAssertEqual(shop.hasDelivery, false)
        XCTAssertEqual(shop.createdAt, Date(timeIntervalSince1970: 1609799767))
        XCTAssertEqual(shop.updatedAt, Date(timeIntervalSince1970: 1644594616))
        XCTAssertEqual(shop.neighborhood?.title, "Colegiales")
        XCTAssertEqual(shop.thumbnail?.regular.absoluteString, "https://cdn.betzerra.com/mrpoopypants/production/shop/thumbnail/98/C76C9E31-CAFA-4AEC-95C7-A9ED8C148A9C.jpeg")
        XCTAssertEqual(shop.thumbnail?.small.absoluteString, "https://cdn.betzerra.com/mrpoopypants/production/shop/thumbnail/98/thumb_C76C9E31-CAFA-4AEC-95C7-A9ED8C148A9C.jpeg")
    }
}

func shopData() throws -> Data {
    let testBundle = Bundle(for: ShopTests.self)
    let path = testBundle.path(forResource: "shop_mock", ofType: "json")
    let url = URL(fileURLWithPath: path!)
    return try Data(contentsOf: url)
}
