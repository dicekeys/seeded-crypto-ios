#import <SeededCrypto/DSCSecret.h>
#import <XCTest/XCTest.h>

@interface DSCSecretTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *derivationOptionsJson = @"{\"lengthInBytes\": 64}";
static NSString *plaintext = @"This seals the deal!";
static NSString *unsealingInstructions =
    @"Go to jail. Go directly to jail. Do not pass go. Do not collected $200.";

@implementation DSCSecretTests

- (void)testGenerate {
  DSCSecret *secret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqualObjects(secret.derivationOptionsJson, derivationOptionsJson);
  XCTAssertEqual(secret.secretBytes.length * sizeof(unsigned char), 64);
}

- (void)testToAndFromBinaryForm {
  DSCSecret *secret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        derivationOptionsJson:derivationOptionsJson];
  DSCSecret *copy =
      [DSCSecret fromSerializedBinaryFrom:[secret toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.derivationOptionsJson,
                        secret.derivationOptionsJson);
  XCTAssertEqualObjects(copy.secretBytes, secret.secretBytes);
}

- (void)testToAndFromJson {
  DSCSecret *secret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        derivationOptionsJson:derivationOptionsJson];
  DSCSecret *copy = [DSCSecret fromJsonWithSeedAsString:[secret toJson]];
  XCTAssertEqualObjects(copy.derivationOptionsJson,
                        secret.derivationOptionsJson);
  XCTAssertEqualObjects(copy.secretBytes, secret.secretBytes);
}

- (void)testUseArgon2 {
  DSCSecret *oldSecret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        derivationOptionsJson:derivationOptionsJson];
  DSCSecret *secret = [DSCSecret
      deriveFromSeedWithSeedString:seedString
             derivationOptionsJson:
                 @"{\"hashFunction\": \"Argon2id\", \"lengthInBytes\": 64}"];
  XCTAssertNotEqualObjects(secret.secretBytes, oldSecret.secretBytes);
}

- (void)testMatchesCPP {
  // DSCSecret* secret = [DSCSecret
  // deriveFromSeedWithSeedString:@"A1tB2rC3bD4lE5tF6bG1tH1tI1tJ1tK1tL1tM1tN1tO1tP1tR1tS1tT1tU1tV1tW1tX1tY1tZ1t"
  // derivationOptionsJson:@"{}"];
}
@end
