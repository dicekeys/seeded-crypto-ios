#import "DSCPassword.h"
#import "DSCHelper.h"
#include "password.hpp"
#include <string>

@interface DSCPassword ()
- (instancetype)initWithPassword:(Password *)password;
@end

@implementation DSCPassword {
  Password *_passwordObject;
}

- (instancetype)initWithPassword:(Password *)password {
  self = [self init];
  if (self != NULL) {
    _passwordObject = password;
  }
  return self;
}

+ (instancetype)
    deriveFromSeedAndWordListWithSeedString:(NSString *)seedString
                      derivationOptionsJson:(NSString *)derivationOptionsJson
                     wordListAsSingleString:(NSString *)wordListAsSingleString {
  Password obj = Password::deriveFromSeedAndWordList(
      [seedString UTF8String], [derivationOptionsJson UTF8String],
      [wordListAsSingleString UTF8String]);
  return [[DSCPassword alloc] initWithPassword:new Password(obj)];
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson {
  Password obj = Password::deriveFromSeed([seedString UTF8String],
                                          [derivationOptionsJson UTF8String]);
  return [[DSCPassword alloc] initWithPassword:new Password(obj)];
}

+ (instancetype)fromJsonWithSeedAsJson:(NSString *)seedAsJson {
  Password obj = Password::fromJson([seedAsJson UTF8String]);
  return [[DSCPassword alloc] initWithPassword:new Password(obj)];
}

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm {
  SodiumBuffer sodiumBuffer = dataToSodiumBuffer(serializedBinaryForm);
  Password password = Password::fromSerializedBinaryForm(sodiumBuffer);
  return [[DSCPassword alloc] initWithPassword:new Password(password)];
}

- (NSString *)password {
  return [NSString stringWithUTF8String:_passwordObject->password.c_str()];
}

- (NSString *)toJson {
  return [NSString stringWithUTF8String:_passwordObject->toJson().c_str()];
}

- (NSString *)toJsonWithIndent:(int)indent {
  return
      [NSString stringWithUTF8String:_passwordObject->toJson(indent).c_str()];
}

- (NSString *)toJsonWithIndent:(int)indent indentChar:(char)indentChar {
  return [NSString
      stringWithUTF8String:_passwordObject->toJson(indent, indentChar).c_str()];
}

- (NSData *)toSerializedBinaryForm;
{
  return sodiumBufferToData(
      _passwordObject
          ->toSerializedBinaryForm()); // [DSCHelper
                                       // dataWithSodiumBuffer:_passwordObject->toSerializedBinaryForm()];
}

- (NSString *)derivationOptionsJson {
  return [NSString
      stringWithUTF8String:_passwordObject->derivationOptionsJson.c_str()];
}

- (void)dealloc {
  delete _passwordObject;
}

@end
