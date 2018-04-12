//
//  TestCoder.h
//  TestStoryBoard
//
//  Created by Manuel Deneu on 11/04/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface TestCoder : NSCoder

@property (readonly) BOOL allowsKeyedCoding;

-(nonnull id) init:(NSString *) name coder:(NSCoder*) coder;

-(id)decodeObjectOfClasses:(NSSet<Class> *)classes forKey:(NSString *)key;

-(BOOL) containsValueForKey:(NSString *)key;

- (CGRect)decodeRectForKey:(NSString *_Nonnull)key;
@end
