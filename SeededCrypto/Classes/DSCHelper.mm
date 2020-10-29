#import "DSCHelper.h"
#include "sodium-buffer.hpp"

NSData *sodiumBufferToData(SodiumBuffer sodiumBuffer) {
  return [NSData dataWithBytes:(const void *)sodiumBuffer.data
                        length:(sizeof(unsigned char) * sodiumBuffer.length)];
}

SodiumBuffer dataToSodiumBuffer(NSData *data) {
  NSUInteger size = [data length] / sizeof(unsigned char);
  unsigned char *array = (unsigned char *)[data bytes];
  return SodiumBuffer(size, array);
}

std::vector<unsigned char> dataToUnsignedCharVector(NSData *data) {
  NSUInteger size = [data length] / sizeof(unsigned char);
  unsigned char *array = (unsigned char *)[data bytes];
  return std::vector<unsigned char>(array, array + size);
}

NSData *unsignedCharVectorToData(std::vector<unsigned char> v) {
  NSUInteger size = v.size() * sizeof(unsigned char);
  return [[NSData alloc] initWithBytes:v.data() length:size];
}

const unsigned char *stringToUnsignedCharArray(NSString *str) {
  return (const unsigned char *)[str UTF8String];
}
