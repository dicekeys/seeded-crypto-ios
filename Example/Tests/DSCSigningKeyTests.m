#import <SeededCrypto/DSCSignatureVerificationKey.h>
#import <SeededCrypto/DSCSigningKey.h>
#import <XCTest/XCTest.h>

@interface DSCSigningKeyTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *recipe = @"{\"HumorStyle\": \"Boomer\"}";
static NSString *plaintext = @"This seals the deal!";

@implementation DSCSigningKeyTests

- (void)testSignAndVerify {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            recipe:recipe
                                            error:&error];
  XCTAssertNil(error);
  DSCSignatureVerificationKey *signatureVerificationKey =
      signingKey.signatureVerificationKey;
  XCTAssertEqualObjects(recipe,
                        signingKey.recipe);
  XCTAssertEqual(32,
                 signatureVerificationKey.signatureVerificationKeyBytes.length);
  XCTAssertEqual(64, signingKey.signingKeyBytes.length);
  XCTAssertEqualObjects(recipe,
                        signatureVerificationKey.recipe);

  NSData *signature = [signingKey generateSignatureWithMessage:plaintext
                                                         error:&error];
  XCTAssertNil(error);
  XCTAssertTrue([signatureVerificationKey verifyWithMessage:plaintext
                                                  signature:signature
                                                      error:&error]);
  XCTAssertNil(error);

  NSData *invalidSignature = [NSData dataWithBytes:[signature bytes]
                                            length:signature.length - 1];
  XCTAssertFalse([signatureVerificationKey verifyWithMessage:plaintext
                                                   signature:invalidSignature
                                                       error:&error]);
  XCTAssertNil(error);
}

- (void)testSigningKeyToAndFromJson {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            recipe:recipe
                                            error:&error];
  XCTAssertNil(error);
  DSCSigningKey *copy =
      [DSCSigningKey fromJsonWithSeedAsString:[signingKey toJson] error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(signingKey.recipe,
                        copy.recipe);
  XCTAssertEqualObjects(signingKey.signingKeyBytes, copy.signingKeyBytes);
  XCTAssertEqualObjects(signingKey.signatureVerificationKeyBytes,
                        copy.signatureVerificationKeyBytes);
}

- (void)testSingatureVerificationKeyToAndFromJson {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            recipe:recipe
                                            error:&error];
  XCTAssertNil(error);
  DSCSignatureVerificationKey *signatureVerificationKey =
      signingKey.signatureVerificationKey;
  DSCSignatureVerificationKey *copy = [DSCSignatureVerificationKey
      fromJsonWithSignatureVerificationKeyAsJson:[signatureVerificationKey
                                                     toJson]
                                           error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(signatureVerificationKey.recipe,
                        copy.recipe);
  XCTAssertEqualObjects(signatureVerificationKey.signatureVerificationKeyBytes,
                        copy.signatureVerificationKeyBytes);
}

- (void)testRawSignAndVerify {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            recipe:recipe
                                            error:&error];
  XCTAssertNil(error);
  DSCSignatureVerificationKey *signatureVerificationKey =
      signingKey.signatureVerificationKey;

  NSData *signature = [signingKey generateSignatureWithMessage:plaintext
                                                         error:&error];
  XCTAssertNil(error);
  XCTAssertTrue([signatureVerificationKey verifyWithMessage:plaintext
                                                  signature:signature
                                                      error:&error]);
  XCTAssertNil(error);
  NSData *invalidSignature = [NSData dataWithBytes:[signature bytes]
                                            length:signature.length - 1];
  XCTAssertFalse([signatureVerificationKey verifyWithMessage:plaintext
                                                   signature:invalidSignature
                                                       error:&error]);
  XCTAssertNil(error);
}

@end
