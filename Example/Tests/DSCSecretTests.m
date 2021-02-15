#import <SeededCrypto/DSCSecret.h>
#import <XCTest/XCTest.h>

@interface DSCSecretTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *recipe = @"{\"lengthInBytes\": 64}";
static NSString *plaintext = @"This seals the deal!";
static NSString *unsealingInstructions =
    @"Go to jail. Go directly to jail. Do not pass go. Do not collected $200.";

@implementation DSCSecretTests

- (void)testGenerate {
  NSError *error;
  DSCSecret *secret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        recipe:recipe
                                        error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(secret.recipe, recipe);
  XCTAssertEqual(secret.secretBytes.length * sizeof(unsigned char), 64);
}

- (void)testToAndFromBinaryForm {
  NSError *error;
  DSCSecret *secret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        recipe:recipe
                                        error:&error];
  DSCSecret *copy =
      [DSCSecret fromSerializedBinaryFrom:[secret toSerializedBinaryForm]];
  XCTAssertNil(error);
  XCTAssertEqualObjects(copy.recipe,
                        secret.recipe);
  XCTAssertEqualObjects(copy.secretBytes, secret.secretBytes);
}

- (void)testToAndFromJson {
  NSError *error;
  DSCSecret *secret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        recipe:recipe
                                        error:&error];
  XCTAssertNil(error);
  DSCSecret *copy = [DSCSecret fromJsonWithSeedAsString:[secret toJson]
                                                  error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(copy.recipe,
                        secret.recipe);
  XCTAssertEqualObjects(copy.secretBytes, secret.secretBytes);
}

- (void)testUseArgon2 {
  NSError *error;
  DSCSecret *oldSecret =
      [DSCSecret deriveFromSeedWithSeedString:seedString
                        recipe:recipe
                                        error:&error];
  DSCSecret *secret = [DSCSecret
      deriveFromSeedWithSeedString:seedString
             recipe:
                 @"{\"hashFunction\": \"Argon2id\", \"lengthInBytes\": 64}"
                             error:&error];
  XCTAssertNil(error);
  XCTAssertNotEqualObjects(secret.secretBytes, oldSecret.secretBytes);
}

- (void)testMatchesCPP {
  // DSCSecret* secret = [DSCSecret
  // deriveFromSeedWithSeedString:@"A1tB2rC3bD4lE5tF6bG1tH1tI1tJ1tK1tL1tM1tN1tO1tP1tR1tS1tT1tU1tV1tW1tX1tY1tZ1t"
  // recipe:@"{}"];
}
@end
