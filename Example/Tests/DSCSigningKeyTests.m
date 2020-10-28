#import <XCTest/XCTest.h>
#import <SeededCrypto/DSCSigningKey.h>
#import <SeededCrypto/DSCSignatureVerificationKey.h>

@interface DSCSigningKeyTests : XCTestCase

@end

static NSString* seedString = @"Avocado";
static NSString* derivationOptionsJson = @"{\"HumorStyle\": \"Boomer\"}";
static NSString* plaintext = @"This seals the deal!";

@implementation DSCSigningKeyTests

- (void)testSignAndVerify {
    DSCSigningKey* signingKey = [DSCSigningKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptionsJson];
    DSCSignatureVerificationKey* signatureVerificationKey = signingKey.signatureVerificationKey;
    XCTAssertEqualObjects(derivationOptionsJson, signingKey.derivationOptionsJson);
    XCTAssertEqual(32, signatureVerificationKey.signatureVerificationKeyBytes.length);
    XCTAssertEqual(64, signingKey.signingKeyBytes.length);
    XCTAssertEqualObjects(derivationOptionsJson, signatureVerificationKey.derivationOptionsJson);
    
    NSData* signature = [signingKey generateSignatureWithMessage:plaintext];
    XCTAssertTrue([signatureVerificationKey verifyWithMessage:plaintext signature:signature]);
    
    NSData* invalidSignature = [NSData dataWithBytes:[signature bytes] length:signature.length - 1];
    XCTAssertFalse([signatureVerificationKey verifyWithMessage:plaintext signature:invalidSignature]);
}

- (void)testSigningKeyToAndFromJson {
    DSCSigningKey* signingKey = [DSCSigningKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptionsJson];
    DSCSigningKey* copy = [DSCSigningKey fromJsonWithSeedAsString:[signingKey toJson]];
    XCTAssertEqualObjects(signingKey.derivationOptionsJson, copy.derivationOptionsJson);
    XCTAssertEqualObjects(signingKey.signingKeyBytes, copy.signingKeyBytes);
    XCTAssertEqualObjects(signingKey.signatureVerificationKeyBytes, copy.signatureVerificationKeyBytes);
}

- (void)testSingatureVerificationKeyToAndFromJson {
    DSCSigningKey* signingKey = [DSCSigningKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptionsJson];
    DSCSignatureVerificationKey* signatureVerificationKey = signingKey.signatureVerificationKey;
    DSCSignatureVerificationKey* copy = [DSCSignatureVerificationKey fromJsonWithSignatureVerificationKeyAsJson:[signatureVerificationKey toJson]];
    XCTAssertEqualObjects(signatureVerificationKey.derivationOptionsJson, copy.derivationOptionsJson);
    XCTAssertEqualObjects(signatureVerificationKey.signatureVerificationKeyBytes, copy.signatureVerificationKeyBytes);
}

- (void)testRawSignAndVerify {
    DSCSigningKey* signingKey = [DSCSigningKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptionsJson];
    DSCSignatureVerificationKey* signatureVerificationKey = signingKey.signatureVerificationKey;
    
    NSData* signature = [signingKey generateSignatureWithMessage:plaintext];
    XCTAssertTrue([signatureVerificationKey verifyWithMessage:plaintext signature:signature]);
    
    NSData* invalidSignature = [NSData dataWithBytes:[signature bytes] length:signature.length - 1];
    XCTAssertFalse([signatureVerificationKey verifyWithMessage:plaintext signature:invalidSignature]);
}

@end

