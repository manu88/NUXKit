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

@interface UISegue : NSObject
{
    //NSString* _id;
    NSString* _identifier;
    NSString* _destinationID;
    NSString* _kind;
    id        _sender;
}

-(id) initWithIdentifier : (NSString*) iden destinationID:(NSString*) destID kind:(NSString*) kind sender:(id) sender;

@property (readonly) NSString* identifier;
@property (readonly) NSString* destinationID;
@property (readonly) NSString* kind;
@property (readonly) id        sender;
@end


/* **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** */
/* **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** */

@interface UIStoryboard : NSObject

@property (readonly) NSMutableDictionary* segueSenders;

-(nonnull id) initWithName:(NSString*)name bundle: (nullable NSBundle*) bundle;

-(void)dealloc;

- (__kindof UIViewController * _Nullable)instantiateInitialViewController;

- (__kindof UIViewController * _Nullable)instantiateViewControllerWithID:(NSString*) vcID;


- (__kindof UIViewController * _Nullable)getViewControllerWithID:(NSString*) id_;


-(BOOL) addInstance: (id) object forKey:(NSString*) key;

-(BOOL) registerSegueSender: (id ) object segue:(nonnull UISegue* ) segue;

-(UISegue* _Nullable) getSegueTargetFromSender: (id) sender;
//-(bool) loadStoryboard:(  NSString* _Nullable) file;

@end
NS_ASSUME_NONNULL_END
