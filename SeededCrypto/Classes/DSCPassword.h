#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(Password)
@interface DSCPassword : NSObject

+ (instancetype)
    deriveFromSeedAndWordListWithSeedString:(NSString *)seedString
                      derivationOptionsJson:(NSString *)derivationOptionsJson
                     wordListAsSingleString:(NSString *)wordListAsSingleString;

+ (instancetype)deriveFromSeedWithSeedString:(NSString *)seedString
                       derivationOptionsJson:(NSString *)derivationOptionsJson;

+ (instancetype)fromJsonWithSeedAsJson:(NSString *)seedAsJson;

+ (instancetype)fromSerializedBinaryFrom:(NSData *)serializedBinaryForm;

//- (instancetype)init NS_UNAVAILABLE;

- (NSString *)toJson;
- (NSString *)toJsonWithIndent:(int)indent;
- (NSString *)toJsonWithIndent:(int)indent indentChar:(char)indentChar;

- (NSData *)toSerializedBinaryForm;

@property(readonly) NSString *password;
@property(readonly) NSString *derivationOptionsJson;

@end

NS_ASSUME_NONNULL_END
