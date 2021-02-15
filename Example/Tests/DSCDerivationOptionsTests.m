#import <SeededCrypto/DSCRecipeObject.h>
#import <XCTest/XCTest.h>

@interface DSCRecipeObjectTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *recipe = @"{\"lengthInBytes\": 64}";

@implementation DSCRecipeObjectTests

- (void)testDerivePrimarySecret {
  NSError *error;
  NSData *options = [DSCRecipeObject
      derivePrimarySecretWithSeedString:seedString
                  recipe:recipe
                                  error:&error];
  XCTAssertEqual(options.length, 64 * sizeof(unsigned char));
  XCTAssertNil(error);
}

@end
