#import <SeededCrypto/DSCDerivationOptions.h>
#import <XCTest/XCTest.h>

@interface DSCDerivationOptionsTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *derivationOptionsJson = @"{\"lengthInBytes\": 64}";

@implementation DSCDerivationOptionsTests

- (void)testDerivePrimarySecret {
  NSError *error;
  NSData *options = [DSCDerivationOptions
      derivePrimarySecretWithSeedString:seedString
                  derivationOptionsJson:derivationOptionsJson
                                  error:&error];
  XCTAssertEqual(options.length, 64 * sizeof(unsigned char));
  XCTAssertNil(error);
}

@end
