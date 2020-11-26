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
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);

  XCTAssertEqual(32, symmetricKey.keyBytes.length);

  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(unsealingInstructions, message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testToAndFromJson {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCSymmetricKey *copy =
      [DSCSymmetricKey fromJsonWithSymmetricKeyAsJson:[symmetricKey toJson]
                                                error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(symmetricKey.derivationOptionsJson,
                        copy.derivationOptionsJson);
  XCTAssertEqualObjects(symmetricKey.keyBytes, copy.keyBytes);
}

- (void)testPackagedSealedMessageToJsonAndBack {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *psm =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *copy = [DSCPackagedSealedMessage
      fromJsonWithPackagedSealedMessageAsJson:[psm toJson]
                                        error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(copy.derivationOptionsJson, psm.derivationOptionsJson);
  XCTAssertEqualObjects(copy.unsealingInstructions, psm.unsealingInstructions);
  XCTAssertEqualObjects(copy.ciphertext, psm.ciphertext);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:copy error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testPackagedSealedMessageToBinaryAndBack {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *psm =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *copy = [DSCPackagedSealedMessage
      fromSerializedBinaryFrom:[psm toSerializedBinaryForm]];
  XCTAssertEqualObjects(copy.derivationOptionsJson, psm.derivationOptionsJson);
  XCTAssertEqualObjects(copy.unsealingInstructions, psm.unsealingInstructions);
  XCTAssertEqualObjects(copy.ciphertext, psm.ciphertext);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:copy error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testFailedCaseInApi {
  NSError *error;
  NSString *derivationOptionsJson = @"{}";
  NSString *testMessage = @"The secret ingredient is dihydrogen monoxide";
  DSCPackagedSealedMessage *psm =
      [DSCSymmetricKey sealWithMessage:testMessage
                            seedString:@"A1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1"
                                       @"tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1tA1t"
                     derivationOptions:derivationOptionsJson
                                 error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(psm.derivationOptionsJson, derivationOptionsJson);
}

- (void)testSealNoInstructionsAndStaticUnseal {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);
  XCTAssertEqual(32, symmetricKey.keyBytes.length);

  DSCPackagedSealedMessage *message = [symmetricKey sealWithMessage:plaintext
                                                              error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(@"", message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testRawSeal {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);

  NSData *ciphertext = [symmetricKey sealToCiphertextOnlyWithMessage:plaintext
                                                               error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [[DSCPackagedSealedMessage alloc] initWithCipherText:ciphertext
                                     derivationOptionsJson:derivationOptionsJson
                                     unsealingInstructions:@""];
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(@"", message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testRawSealWithInstructions {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  XCTAssertEqualObjects(derivationOptionsJson,
                        symmetricKey.derivationOptionsJson);

  NSData *ciphertext =
      [symmetricKey sealToCiphertextOnlyWithMessage:plaintext
                              unsealingInstructions:unsealingInstructions
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message = [[DSCPackagedSealedMessage alloc]
         initWithCipherText:ciphertext
      derivationOptionsJson:derivationOptionsJson
      unsealingInstructions:unsealingInstructions];
  XCTAssertEqualObjects(derivationOptionsJson, message.derivationOptionsJson);
  XCTAssertEqualObjects(unsealingInstructions, message.unsealingInstructions);

  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithPackagedSealedMessage:message error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testRawUnseal {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealCiphertext:message.ciphertext
               unsealingInstructions:unsealingInstructions
                               error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testStaticUnseal {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  NSData *recoveredPlainTextBytes =
      [DSCSymmetricKey unsealWithPackagedSealedMessage:message
                                            seedString:seedString
                                                 error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testUnsealFromJson {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  NSData *recoveredPlainTextBytes =
      [symmetricKey unsealWithJsonPackagedSealedMessage:[message toJson]
                                                  error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testUnsealFromBinary {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  NSData *recoveredPlainTextBytes = [symmetricKey
      unsealWithBinaryPackagedSealedMessage:[message toSerializedBinaryForm]
                                      error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testStaticUnsealFromJson {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  NSData *recoveredPlainTextBytes =
      [DSCSymmetricKey unsealWithJsonPackagedSealedMessage:[message toJson]
                                                seedString:seedString
                                                     error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testStaticUnsealFromBinary {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  DSCPackagedSealedMessage *message =
      [symmetricKey sealWithMessage:plaintext
              unsealingInstructions:unsealingInstructions
                              error:&error];
  XCTAssertNil(error);
  NSData *recoveredPlainTextBytes = [DSCSymmetricKey
      unsealWithBinaryPackagedSealedMessage:[message toSerializedBinaryForm]
                                 seedString:seedString
                                      error:&error];
  XCTAssertNil(error);
  NSString *recoveredPlainText =
      [NSString stringWithUTF8String:[recoveredPlainTextBytes bytes]];
  XCTAssertEqualObjects(plaintext, recoveredPlainText);
}

- (void)testSealEmptyPlainText {
  NSError *error;
  DSCSymmetricKey *symmetricKey =
      [DSCSymmetricKey deriveFromSeedWithSeedString:seedString
                              derivationOptionsJson:derivationOptionsJson
                                              error:&error];
  XCTAssertNil(error);
  [symmetricKey sealWithMessage:@""
          unsealingInstructions:unsealingInstructions
                          error:&error];
  XCTAssertNotNil(error);
}
@end
