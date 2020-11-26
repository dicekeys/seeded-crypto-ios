#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Secret)
@interface DSCSecret : NSObject

+ (instancetype)fromJsonWithSeedAsString:(NSString *)seedAsString
                                   error:(NSError **)error
    __attribute__((swift_error(nonnull_error)))NS_SWIFT_NAME(from(json:));

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm
    NS_SWIFT_NAME(from(serializedBinaryForm:));

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson
                                       error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));

- (NSString *)toJson;

- (NSData *)toSerializedBinaryForm;

- (NSData *)secretBytes;

@property(readonly) NSString *derivationOptionsJson;

@end

NS_ASSUME_NONNULL_END
