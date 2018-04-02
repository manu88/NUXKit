//
//  StoryBoardPlugin.h
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIViewController;

/*
 For now, the storyboard parser is written in C++, so UIStoryboard can't be in pure swift.
 */
NS_ASSUME_NONNULL_BEGIN

@interface UIStoryboard : NSObject

-(nonnull id) initWithName:(NSString*)name bundle: (nullable NSBundle*) bundle;

-(void)dealloc;

- (__kindof UIViewController * _Nullable)instantiateInitialViewController;




//-(bool) loadStoryboard:(  NSString* _Nullable) file;

@end
NS_ASSUME_NONNULL_END
