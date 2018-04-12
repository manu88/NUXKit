//
//  StoryBoardPlugin.m
//  TestAPI
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#import  "UIStoryBoard.h"
#import "CustomCoder.h"
#include "../StoryBoardParser/include/StoryboardDocument.hpp"
//#include "TestNoStoryboard-Swift.h"
#include "XMLDocument.hpp"


@implementation UIStoryboard
{
    //Storyboard::Document* _doc;
    XMLDocument *doc;
    
    XMLNode scenesNode;
    XMLNode initialVCNode;
    
    std::string initialViewControllerID;
    
}

-(nonnull id) initWithName:(NSString*)name bundle: (NSBundle*) bundle
{
    if ( self = [super init])
    {
        self->doc = new XMLDocument( [ name cStringUsingEncoding:NSUTF8StringEncoding ] );
        
        if (doc->isValid() == false)
        {
            return nil;
        }
        //initialViewControllerID = nil;
        
        
        
        return self;
    }
    return nil;
}


- (BOOL)prepareDoc
{
    assert(initialViewControllerID.empty());
    
    assert(doc);
    assert(doc->isValid());
    
    
    if( doc->getRoot().getName() != "document")
        return NO;
    
    
    if( doc->getRoot().hasProperty("targetRuntime"))
    {
        //sb.setTargetRuntime( doc.getRoot().getProperty("targetRuntime") );
    }
    
    if( doc->getRoot().hasProperty("initialViewController"))
    {
        initialViewControllerID = doc->getRoot().getProperty("initialViewController");
        
        //sb.setInitialViewControllerID( doc.getRoot().getProperty("initialViewController") );
    }
    
    scenesNode = doc->getRoot().getChildByName("scenes");
    
    if (scenesNode.isValid() == false)
    {
        printf("Error : no 'scene' node found\n");
        return NO;
    }
    
    
    for( const auto &scene : scenesNode.getChildren())
    {
        const auto objects = scene.second.getChildByName("objects");
        
        if( objects.isValid() == false)
        {
            return false;
        }
        
        const auto viewControlerNode = objects.getChildByName("viewController");
        
        if( viewControlerNode.isValid() == false)
        {
            return false;
        }
        
        if( viewControlerNode.getProperty("id") == initialViewControllerID)
        {
            initialVCNode = viewControlerNode;
        }
        
        
    }
    
    
    return initialVCNode.isValid();
}



-(void)dealloc
{
    delete doc;
}

- (__kindof UIViewController *_Nullable )instantiateInitialViewController
{
    
    if( initialViewControllerID.empty())
    {
        if( [self prepareDoc] == NO)
        {
            return nil;
        }
    }
    
    assert(initialViewControllerID.empty() == false);
    assert(initialVCNode.isValid());
    
    const auto initialVCName = initialVCNode.getProperty("customClass");
    const auto initialVCModuleName = initialVCNode.getProperty("customModule");
    
    assert( initialVCName.empty() == false);
    assert( initialVCModuleName.empty() == false); // Sure?
    
    const auto initialVCFullName = initialVCModuleName + "." + initialVCName;
    
    Class instanceClass = NSClassFromString( [NSString stringWithFormat:@"%s", initialVCFullName.c_str() ] );
    
    if( instanceClass )
    {
        NSCoder* decoder = [[CustomCoder alloc] initWithXMLNode: initialVCNode ];
        UIViewController * vc =[ [instanceClass alloc] initWithCoder:decoder];
        
        return vc;
    }
    //NSLog(@"VCName = %s , VCModule = %s " , initialVCName.c_str() , initialVCModuleName.c_str());
    /*
    const auto initialVC =  _doc->getInitialViewController();
    const auto initialVCName = initialVC->customModule + "." + initialVC ->customClass;
    
    Class instanceClass = NSClassFromString( [NSString stringWithFormat:@"%s", initialVCName.c_str() ] );
    
    NSLog(@"InitialVCName is '%s'" ,initialVCName.c_str());
    
    if( instanceClass )
    {
        NSCoder* decoder = [[CustomCoder alloc] initWithXMLNode: _doc->getRootNode() ];
        UIViewController * vc =[ [instanceClass alloc] initWithCoder:decoder];

        return vc;
    }
     */
    return nil;
}

@end
