#import <SeededCrypto/DSCSymmetricKey.h>
#import <XCTest/XCTest.h>

@interface DSCSymmetricKeyTests : XCTestCase

@end

static NSString *seedString = @"yo";
static NSString *derivationOptionsJson = @"{\"ValidJson\": \"This time!\"}";
static NSString *plaintext = @"perchance to SCREAM!";
static NSString *unsealingInstructions =
    @"run, do not walk, to the nearest cliche.";

NSData *plainTextBuffer() {
  return [plaintext dataUsingEncoding:NSUTF8StringEncoding];
}

@implementation DSCSymmetricKeyTests

- (void)testSealAndUnsealWithInstrucations {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);

  XCTAssertEqual(32, symmetricKey.keyBytes.length);

  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(unsealingInstructions, message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testToAndFromJson {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCSymmetricKey *copy =
      [DSCSymmetricKey fromJsonWithSymmetricKeyAsJson:[symmetricKey toJson]];
  XCTAssertEqualObjects(symmetricKey.derivationOptionsJson,
                        copy.derivationOptionsJson);
  XCTAssertEqualObjects(symmetricKey.keyBytes, copy.keyBytes);
}

- (void)testPackagedSealedMessageToJsonAndBack {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *psm =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  DSCPackagedSealedMessage *copy = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:[psm toJson]];
  XCTAssertEqualObjects(copy.derivationOptionsJson, psm.derivationOptionsJson);
  XCTAssertEqualObjects(copy.unsealingInstructions, psm.unsealingInstructions);
  XCTAssertEqualObjects(copy.ciphertext, psm.ciphertext);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:copy];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testPackagedSealedMessageToBinaryAndBack {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *psm =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  DSCPackagedSealedMessage *copy = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:[psm toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.derivationOptionsJson, psm.derivationOptionsJson);
  XCTAssertEqualObjects(copy.unsealingInstructions, psm.unsealingInstructions);
  XCTAssertEqualObjects(copy.ciphertext, psm.ciphertext);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:copy];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testFailedCaseInApi {
  NSString *derivationOptionsJson = @"{}";
  NSString *testMessage = @"The secret ingredient is dihydrogen monoxide";
  DSCPackagedSealedMessage *psm =
      [DSCSymmetricKey sealWithMessage:testMessage
                            seedString:@"A1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1t"
                     derivationOptions:derivationOptionsJson];
  XCTAssertEqualObjects(psm.derivationOptionsJson, derivationOptionsJson);
}

- (void)testSealNoInstructionsAndStaticUnseal {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);
  XCTAssertEqual(32, symmetricKey.keyBytes.length);

  DSCPackagedSealedMessage *message = [symmetricKey sealWithMessage:plaintext];
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(@"", message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testRawSeal {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);

  NSData *ciphertext = [symmetricKey sealToCiphertextOnlyWithMessage:plaintext];
  DSCPackagedSealedMessage *message =
      [[DSCPackagedSealedMessage alloc] initWithCipherText:ciphertext
                                     derivationOptionsJson:derivationOptionsJson
                                     unsealingInstructions:@""];
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(@"", message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testRawSealWithInstructions {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);

  NSData *ciphertext =
      [symmetricKey sealToCiphertextOnlyWithMessage:plaintext
                              unsealingInstructions:unsealingInstructions];
  DSCPackagedSealedMessage *message = [[DSCPackagedSealedMessage alloc]
         initWithCipherText:ciphertext
      derivationOptionsJson:derivationOptionsJson
      unsealingInstructions:unsealingInstructions];
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(unsealingInstructions, message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testRawUnseal {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealCiphertext:message.ciphertext
               unsealingInstructions:unsealingInstructions];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testStaticUnseal {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  NSData *recoveredPlainTextBytes =
      [DSCSymmetricKey unsealWithPackagedSealedMessage:message
                                            seedString:seedString];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testUnsealFromJson {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealJsonPackagedSealedMessage:[message toJson]];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testUnsealFromBinary {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  NSData *recoveredPlainTextBytes = [symmetricKey
      unsealBinaryPackagedSealedMessage:[message toSerializedBinaryForm]];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testStaticUnsealFromJson {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  NSData *recoveredPlainTextBytes =
      [DSCSymmetricKey unsealWithJsonPackagedSealedMessage:[message toJson]
                                                seedString:seedString];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testStaticUnsealFromBinary {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions];
  NSData *recoveredPlainTextBytes = [DSCSymmetricKey
      unsealWithBinaryPackagedSealedMessage:[message toSerializedBinaryForm]
                                 seedString:seedString];
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testSealEmptyPlainText {
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson];
  XCTAssertThrows([symmetricKey sealWithMessage:@""
                          unsealingInstructions:unsealingInstructions]);
}
@end
