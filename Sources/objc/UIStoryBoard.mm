//
//  StoryBoardPlugin.m
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import  "UIStoryBoard.h"
#include "../StoryBoardParser/include/StoryboardDocument.hpp"
//#include "TestNoStoryboard-Swift.h"


@implementation UIStoryboard
{
    Storyboard::Document* _doc;
}

-(nonnull id) initWithName:(NSString*)name bundle: (NSBundle*) bundle
{
    if ( self = [super init])
    {
        _doc = new Storyboard::Document( [ name cStringUsingEncoding:NSUTF8StringEncoding ] );
        
        return self;
    }
    return nil;
}

-(void)dealloc
{
    delete _doc;
}

- (__kindof UIViewController *_Nullable )instantiateInitialViewController
{
    const auto initialVC =  _doc->getInitialViewController();
    const auto initialVCName = initialVC->customModule + "." + initialVC ->customClass;
    
    Class instanceClass = NSClassFromString( [NSString stringWithFormat:@"%s", initialVCName.c_str() ] );
    
    NSLog(@"InitialVCName is '%s'" ,initialVCName.c_str());
    
    if( instanceClass )
    {
        UIViewController * vc = [[instanceClass alloc] init];
        
        if( vc)
        {
            
        }
        
        return vc;
    }
    return nil;
}



/*
-(bool) loadStoryboard:(  NSString*) file
{
    Storyboard::Document sboard([ file cStringUsingEncoding:NSUTF8StringEncoding ] );
    
    
    printf("------------------------------\n");
    
    printf("targetRuntime : %s\n" , sboard.getTargetRuntime().c_str() );
    printf("type : %s\n" , sboard.getType().c_str() );
    printf("Got %zi scenes \n" , sboard.getScenes().size() );
    printf("Initial view Controller '%s' \n" , sboard.getInitialViewController().c_str() );
    for( const auto &scene : sboard.getScenes() )
    {
        printf("+Scene id '%s'\n" , scene.getID().c_str() );
        
        printf("\t\tView Controller '%s'" , scene.getViewController().getID().c_str() );
        
        if( scene.getViewController().getID() == sboard.getInitialViewController() )
        {
            printf(" <- initial view controller");
        }
        printf("\n");
        
        printf("\t\t View: '%s' %zi subviews\n", scene.getViewController().view.name.c_str() , scene.getViewController().view.getSubViewsCount() );
        
        for( const auto &v : scene.getViewController().view.getSubViews())
        {
            printf("\t\t\t%s\n" , v.name.c_str());
        }
        
    }

    
    return false;
}
*/
@end
