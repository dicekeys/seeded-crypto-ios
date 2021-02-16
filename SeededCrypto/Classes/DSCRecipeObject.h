#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NS_SWIFT_NAME(RecipeObject)
@interface DSCRecipeObject : NSObject
+ (NSData *)derivePrimarySecretWithSeedString:(NSString *)seedString
                        recipe:(NSString *)recipe
                                        error:(NSError **)error
    __attribute__((swift_error(nonnull_error)));
@end

NS_ASSUME_NONNULL_END
