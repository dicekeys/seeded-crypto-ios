#import "DSCSecret.h"
#import "DSCHelper.h"
#include "secret.hpp"
#include <string>

@interface DSCSecret ()
- (instancetype)initWithSecretObject:(Secret *)secret;
@end

@implementation DSCSecret {
  Secret *_secretObject;
}

- (instancetype)initWithSecretObject:(Secret *)secret {
  self = [self init];
  if (self != NULL) {
    _secretObject = secret;
  }
  return self;
}

+ (instancetype)fromJsonWithSeedAsString:(NSString *)seedAsString
                                   error:(NSError **)error {
  try {
    Secret obj = Secret::fromJson([seedAsString UTF8String]);
    return [[DSCSecret alloc] initWithSecretObject:new Secret(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  Secret secret = Secret::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCSecret alloc] initWithSecretObject:new Secret(secret)];
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson
                                       error:(NSError **)error {
  try {
    Secret secret = Secret::deriveFromSeed([seedString UTF8String],
                                           [derivationOptionsJson UTF8String]);
    return [[DSCSecret alloc] initWithSecretObject:new Secret(secret)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

- (NSString *)toJson {
  return [NSString stringWithUTF8String:_secretObject->toJson().c_str()];
}

- (NSData *)toSerializedBinaryForm {
  SodiumBuffer sodiumBuffer = _secretObject->toSerializedBinaryForm();
  return sodiumBufferToData(sodiumBuffer);
}

- (NSData *)secretBytes {
  return sodiumBufferToData(_secretObject->secretBytes);
}

- (NSString *)derivationOptionsJson {
  return [NSString
      stringWithUTF8String:_secretObject->derivationOptionsJson.c_str()];
}

- (void)dealloc {
  delete _secretObject;
}

@end
