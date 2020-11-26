#import <SeededCrypto/DSCSignatureVerificationKey.h>
#import <SeededCrypto/DSCSigningKey.h>
#import <XCTest/XCTest.h>

@interface DSCSigningKeyTests : XCTestCase

@end

static NSString *seedString = @"Avocado";
static NSString *derivationOptionsJson = @"{\"HumorStyle\": \"Boomer\"}";
static NSString *plaintext = @"This seals the deal!";

@implementation DSCSigningKeyTests

- (void)testSignAndVerify {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            derivationOptionsJson:derivationOptionsJson
                                            error:&error];
  XCTAssertNil(error);
  DSCSignatureVerificationKey *signatureVerificationKey =
      signingKey.signatureVerificationKey;
  XCTAssertEqualObjects(derivationOptionsJson,
                        signingKey.derivationOptionsJson);
  XCTAssertEqual(32,
                 signatureVerificationKey.signatureVerificationKeyBytes.length);
  XCTAssertEqual(64, signingKey.signingKeyBytes.length);
  XCTAssertEqualObjects(derivationOptionsJson,
                        signatureVerificationKey.derivationOptionsJson);

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
                            derivationOptionsJson:derivationOptionsJson
                                            error:&error];
  XCTAssertNil(error);
  DSCSigningKey *copy =
      [DSCSigningKey fromJsonWithSeedAsString:[signingKey toJson] error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(signingKey.derivationOptionsJson,
                        copy.derivationOptionsJson);
  XCTAssertEqualObjects(signingKey.signingKeyBytes, copy.signingKeyBytes);
  XCTAssertEqualObjects(signingKey.signatureVerificationKeyBytes,
                        copy.signatureVerificationKeyBytes);
}

- (void)testSingatureVerificationKeyToAndFromJson {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            derivationOptionsJson:derivationOptionsJson
                                            error:&error];
  XCTAssertNil(error);
  DSCSignatureVerificationKey *signatureVerificationKey =
      signingKey.signatureVerificationKey;
  DSCSignatureVerificationKey *copy = [DSCSignatureVerificationKey
      fromJsonWithSignatureVerificationKeyAsJson:[signatureVerificationKey
                                                     toJson]
                                           error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(signatureVerificationKey.derivationOptionsJson,
                        copy.derivationOptionsJson);
  XCTAssertEqualObjects(signatureVerificationKey.signatureVerificationKeyBytes,
                        copy.signatureVerificationKeyBytes);
}

- (void)testRawSignAndVerify {
  NSError *error;
  DSCSigningKey *signingKey =
      [DSCSigningKey deriveFromSeedWithSeedString:seedString
                            derivationOptionsJson:derivationOptionsJson
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
