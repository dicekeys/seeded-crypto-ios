import XCTest
import SeededCrypto

class DSCSwiftPlayground: XCTestCase {

    func testTry() throws {
        let secret = try Secret.deriveFromSeed(withSeedString: "Avocado", derivationOptionsJson: "{\"lengthInBytes\": 64}")
        XCTAssertNotNil(secret)
    }
    
    func testTryTrhows() throws {
        let symmetricKey = try SymmetricKey.deriveFromSeed(withSeedString: "yo", derivationOptionsJson: "{\"ValidJson\": \"This time!\"}")
        XCTAssertThrowsError(try symmetricKey.seal(withMessage: "", unsealingInstructions: "run, do not walk, to the nearest cliche.")) { error in
            XCTAssertEqual("Invalid message length", error.localizedDescription)
        }
    }
}

