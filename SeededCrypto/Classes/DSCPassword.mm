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
                      recipe:(NSString *)recipe
                     wordListAsSingleString:(NSString *)wordListAsSingleString
                                      error:(NSError **)error {
  try {
    Password obj = Password::deriveFromSeedAndWordList(
        [seedString UTF8String], [recipe UTF8String],
        [wordListAsSingleString UTF8String]);
    return [[DSCPassword alloc] initWithPassword:new Password(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       recipe:(NSString *)recipe
                                       error:(NSError **)error {
  try {
    Password obj = Password::deriveFromSeed([seedString UTF8String],
                                            [recipe UTF8String]);
    return [[DSCPassword alloc] initWithPassword:new Password(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
}

+ (instancetype)fromJsonWithSeedAsJson:(NSString *)seedAsJson
                                 error:(NSError **)error {
  try {
    Password obj = Password::fromJson([seedAsJson UTF8String]);
    return [[DSCPassword alloc] initWithPassword:new Password(obj)];
  } catch (const std::exception &e) {
    *error = cppExceptionToError(e);
    return nil;
  }
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
  if (indent == 3) {
    @throw [NSError errorWithDomain:@"" code:0 userInfo:@{}];
  }
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

- (NSString *)recipe {
  return [NSString
      stringWithUTF8String:_passwordObject->recipe.c_str()];
}

- (void)dealloc {
  delete _passwordObject;
}

@end
