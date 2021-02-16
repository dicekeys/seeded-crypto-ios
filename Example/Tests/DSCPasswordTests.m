#import <SeededCrypto/DSCPassword.h>
#import <XCTest/XCTest.h>

@interface DSCPasswordTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *recipe = @"{}";
static NSString *orderedTestKey = @"A1tB2rC3bD4lE5tF6bG1tH1tI1tJ1tK1tL1tM1tN1tO"
                                  @"1tP1tR1tS1tT1tU1tV1tW1tX1tY1tZ1t";

@implementation DSCPasswordTests

- (void)testGenerate {
  NSError *error;
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          recipe:recipe
                                          error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(password.recipe, recipe);
}

- (void)testToAndFromBinaryForm {
  NSError *error;
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          recipe:recipe
                                          error:&error];
  XCTAssertNil(error);
  DSCPassword *copy =
      [DSCPassword fromSerializedBinaryFrom:[password toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.recipe,
                        password.recipe);
  XCTAssertEqualObjects(copy.password, password.password);
}

- (void)testToAndFromJson {
  NSError *error;
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          recipe:recipe
                                          error:&error];
  XCTAssertNil(error);
  DSCPassword *copy = [DSCPassword fromJsonWithSeedAsJson:[password toJson]
                                                    error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(copy.recipe,
                        password.recipe);
  XCTAssertEqualObjects(copy.password, password.password);
}

- (void)testArgon2 {
  NSError *error;
  DSCPassword *oldPassword =
      [DSCPassword deriveFromSeedWithSeedString:seedString
                          recipe:recipe
                                          error:&error];
  XCTAssertNil(error);
  DSCPassword *password = [DSCPassword
      deriveFromSeedWithSeedString:seedString
             recipe:
                 @"{\"hashFunction\": \"Argon2id\",\"lengthInBytes\": 64}"
                             error:&error];
  XCTAssertNil(error);
  XCTAssertNotEqualObjects(oldPassword.password, password.password);
}

- (void)testGeneratesExtraBytes {
  NSError *error;
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          recipe:@"{\"lengthInBits\": 300}"
                                          error:&error];
  XCTAssertNil(error);
  DSCPassword *copy =
      [DSCPassword fromSerializedBinaryFrom:[password toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.password, password.password);
  XCTAssertEqualObjects(
      @"34-", [password.password substringWithRange:NSMakeRange(0, 3)]);
}

- (void)testTenWordsViaLengthInWords {
  NSError *error;
  NSString *recipeJson = @"{\n\
\t\"type\": "
                                @"\"Password\",\n\
\t\"lengthInBits\": 90\n\
}";
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          recipe:recipeJson
                                          error:&error];
  XCTAssertNil(error);

  XCTAssertEqualObjects(
      password.password,
      @"10-Ionic-buzz-shine-theme-paced-bulge-cache-water-shown-baggy");
}

- (void)testElevenWordsViaLengthInWords {
  NSError *error;
  NSString *recipeJson = @"{\n\
\t\"type\": "
                                @"\"Password\",\n\
\t\"lengthInWords\": "
                                @"11\n\
}";
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          recipe:recipeJson
                                          error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(
      password.password,
      @"11-Clean-snare-donor-petty-grimy-payee-limbs-stole-roman-aloha-dense");
}

- (void)testThirteenWordsViaDefaultWithAltWordList {
  NSError *error;
  NSString *recipeJson = @"{\n\
\t\"wordList\": "
                                @"\"EN_1024_words_6_chars_max_ed_4_"
                                @"20200917\"\n\
}";
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          recipe:recipeJson
                                          error:&error];
  XCTAssertNil(error);

  XCTAssertEqualObjects(password.password,
                        @"13-Curtsy-jersey-juror-anchor-catsup-parole-kettle-"
                        @"floral-agency-donor-dealer-plural-accent");
}

- (void)testFifteenWordsViaDefaults {
  NSError *error;
  DSCPassword *password =
      [DSCPassword deriveFromSeedWithSeedString:orderedTestKey
                          recipe:@"{}"
                                          error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(password.password,
                        @"15-Unwed-agent-genre-stump-could-limit-shrug-shout-"
                        @"udder-bring-koala-essay-plaza-chaos-clerk");
}

@end
