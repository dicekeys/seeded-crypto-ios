#import "DSCSigningKey.h"
#import "DSCHelper.h"
#include "signing-key.hpp"

@interface DSCSigningKey ()
- (instancetype)initWithSigningKeyObject:(SigningKey*)signingKey;
@end

@implementation DSCSigningKey {
    SigningKey* _signingKeyObject;
}

+ (NSData*)generateSignatureWithMessage:(NSString *)message seedString:(NSString *)seedString derivationOptionsJson:(NSString *)derivationOptionsJson {
    return [[DSCSigningKey deriveFromSeedWithSeedString:seedString derivationOptionsJson:derivationOptionsJson] generateSignatureWithMessage:message];
}

- (instancetype)initWithSigningKeyObject:(SigningKey *)signingKey {
    self = [[DSCSigningKey alloc] init];
    if (self != NULL) {
        _signingKeyObject = signingKey;
    }
    return self;
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString*)seedString derivationOptionsJson:(NSString*)derivationOptionsJson {
    SigningKey signingKey = SigningKey::deriveFromSeed([seedString UTF8String], [derivationOptionsJson UTF8String]);
    return [[DSCSigningKey alloc] initWithSigningKeyObject: new SigningKey(signingKey)];
}

+ (instancetype)fromJsonWithSeedAsString:(NSString*)seedAsString {
    SigningKey obj = SigningKey::fromJson([seedAsString UTF8String]);
    return [[DSCSigningKey alloc] initWithSigningKeyObject: new SigningKey(obj)];
}

+ (instancetype)fromSerializedBinaryFrom:(NSData*)serializedBinaryForm {
    SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
    SigningKey obj = SigningKey::fromSerializedBinaryForm(sodiumBuffer);
    return [[DSCSigningKey alloc] initWithSigningKeyObject: new SigningKey(obj)];
}

- (NSString*)toJson {
    return [NSString stringWithUTF8String:_signingKeyObject->toJson().c_str()];
}

- (NSData*)toSerializedBinaryForm {
    SodiumBuffer sodiumBuffer = _signingKeyObject->toSerializedBinaryForm();
    return sodiumBufferToData(sodiumBuffer);
}

- (NSData*)generateSignatureWithMessage:(NSString *)message {
    return unsignedCharVectorToData(_signingKeyObject->generateSignature(stringToUnsignedCharArray(message), message.length));
    
}

- (NSString*)derivationOptionsJson {
    return [NSString stringWithUTF8String:_signingKeyObject->derivationOptionsJson.c_str()];
}

- (DSCSignatureVerificationKey*)signatureVerificationKey {
    SignatureVerificationKey key = _signingKeyObject->getSignatureVerificationKey();
    return [[DSCSignatureVerificationKey alloc] initWithSignatureVerificationKeyObject: new SignatureVerificationKey(key)];
}

- (NSData*)signingKeyBytes {
    return sodiumBufferToData(_signingKeyObject->signingKeyBytes);
}

- (NSData*)signatureVerificationKeyBytes {
    return sodiumBufferToData(_signingKeyObject->getSignatureVerificationKey().signatureVerificationKeyBytes);
}

- (void)dealloc {
    delete _signingKeyObject;
}

@end
