#import <SeededCrypto/DSCDerivationOptions.h>
#import <XCTest/XCTest.h>

@interface DSCDerivationOptionsTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *derivationOptionsJson = @"{\"lengthInBytes\": 64}";

@implementation DSCDerivationOptionsTests

- (void)testDerivePrimarySecret {
  NSData *options = [DSCDerivationOptions
      derivePrimarySecretWithSeedString:seedString
                  derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqual(options.length, 64 * sizeof(unsigned char));
}

@end
