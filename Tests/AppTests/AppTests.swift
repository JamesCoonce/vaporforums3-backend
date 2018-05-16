import App
import XCTest
import FluentPostgreSQL

final class AppTests: XCTestCase {
    var connection: PostgreSQLConnection!
    
    func testNothing() throws {
        // add your tests here
        XCTAssert(true)
    }
    
    override func setUp() {
        try! Application.reset()
        app = try! Application.testable()
        conn = try! app.newConnection(to: .psql).wait()
    }
    
    func testSomething() throws {
        
        XCTAssert(true)
    }

    static let allTests = [
        ("testNothing", testNothing),
        ("testSomething", testSomething)
    ]
}
