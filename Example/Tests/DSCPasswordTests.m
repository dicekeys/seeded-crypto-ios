#import <SeededCrypto/DSCPassword.h>
#import <XCTest/XCTest.h>

@interface DSCPasswordTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *derivationOptionsJson = @"{}";
static NSString *orderedTestKey = @"A1tB2rC3bD4lE5tF6bG1tH1tI1tJ1tK1tL1tM1tN1tO"
                                  @"1tP1tR1tS1tT1tU1tV1tW1tX1tY1tZ1t";

@implementation DSCPasswordTests

- (void)testGenerate {
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqualObjects(password.derivationOptionsJson, derivationOptionsJson);
}

- (void)testToAndFromBinaryForm {
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          derivationOptionsJson:derivationOptionsJson];
  DSCPassword *copy =
      [DSCPassword fromSerializedBinaryFrom:[password toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.derivationOptionsJson,
                        password.derivationOptionsJson);
  XCTAssertEqualObjects(copy.password, password.password);
}

- (void)testToAndFromJson {
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          derivationOptionsJson:derivationOptionsJson];
  DSCPassword *copy = [DSCPassword fromJsonWithSeedAsJson:[password toJson]];
  XCTAssertEqualObjects(copy.derivationOptionsJson,
                        password.derivationOptionsJson);
  XCTAssertEqualObjects(copy.password, password.password);
}

- (void)testArgon2 {
  DSCPassword *oldPassword =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          derivationOptionsJson:derivationOptionsJson];
  DSCPassword *password = [DSCPassword
      deriveFromSeedWithSeedString:seedString
             derivationOptionsJson:
                 @"{\"hashFunction\": \"Argon2id\",\"lengthInBytes\": 64}"];
  XCTAssertNotEqualObjects(oldPassword.password, password.password);
}

- (void)testGeneratesExtraBytes {
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          derivationOptionsJson:@"{\"lengthInBits\": 300}"];
  DSCPassword *copy =
      [DSCPassword fromSerializedBinaryFrom:[password toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.password, password.password);
  XCTAssertEqualObjects(
      @"34-", [password.password substringWithRange:NSMakeRange(0, 3)]);
}

- (void)testTenWordsViaLengthInWords {
  NSString *derivationOptions = @"{\n\
\t\"type\": "
                                @"\"Password\",\n\
\t\"lengthInBits\": 90\n\
}";
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          derivationOptionsJson:derivationOptions];

  XCTAssertEqualObjects(
      password.password,
      @"10-Ionic-buzz-shine-theme-paced-bulge-cache-water-shown-baggy");
}

- (void)testElevenWordsViaLengthInWords {
  NSString *derivationOptions = @"{\n\
\t\"type\": "
                                @"\"Password\",\n\
\t\"lengthInWords\": "
                                @"11\n\
}";
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          derivationOptionsJson:derivationOptions];

  XCTAssertEqualObjects(
      password.password,
      @"11-Clean-snare-donor-petty-grimy-payee-limbs-stole-roman-aloha-dense");
}

- (void)testThirteenWordsViaDefaultWithAltWordList {
  NSString *derivationOptions = @"{\n\
\t\"wordList\": "
                                @"\"EN_1024_words_6_chars_max_ed_4_"
                                @"20200917\"\n\
}";
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          derivationOptionsJson:derivationOptions];

  XCTAssertEqualObjects(password.password,
                        @"13-Curtsy-jersey-juror-anchor-catsup-parole-kettle-"
                        @"floral-agency-donor-dealer-plural-accent");
}

- (void)testFifteenWordsViaDefaults {
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          derivationOptionsJson:@"{}"];
  XCTAssertEqualObjects(password.password,
                        @"15-Unwed-agent-genre-stump-could-limit-shrug-shout-"
                        @"udder-bring-koala-essay-plaza-chaos-clerk");
}

@end
