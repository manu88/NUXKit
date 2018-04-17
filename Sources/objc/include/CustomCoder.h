//
//  CustomCoder.h
//  NUXKit
//
//  Created by Manuel Deneu on 09/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import <Foundation/Foundation.h>


class XMLNode;
@class UIStoryboard;

@interface CustomCoder : NSCoder


// Returns YES if this coder requires secure coding. Secure coders check a list of allowed classes before decoding objects, and all objects must implement NSSecureCoding.
@property (readonly) BOOL requiresSecureCoding;
@property (readonly) BOOL allowsKeyedCoding;

- (nonnull id) initWithXMLNode:( const XMLNode& ) node storyboard:(UIStoryboard*_Nonnull) storyboard;
- (nullable id)decodeObjectForKey:(NSString *_Nonnull)key;
- (nullable id)decodeTopLevelObjectForKey:(NSString *_Nonnull)key error:(NSError *_Nullable*_Nullable)error API_AVAILABLE(macos(10.11), ios(9.0), watchos(2.0), tvos(9.0));

- (nullable id)decodeObjectOfClasses:(nullable NSSet<Class> *)classes forKey:(NSString *_Nonnull)key;
- (int64_t)decodeInt64ForKey:(NSString * _Nonnull)key;

@end
