//
//  main.cpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include <unistd.h>
#include <iostream>
#include "StoryboardDocument.hpp"

int main(int argc, const char * argv[])
{
    Storyboard::Document sboard("/Users/manueldeneu/Documents/projets/TestPortUIKit/TestSimpleView/TestSimpleView/Base.lproj/Main.storyboard"); 

    
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
            printf("\t\t\t%s (%zi properties)\n" , v.name.c_str() , v.parameters.size() );
            
            
            printf("\t\t\t\tBounds %.2f %.2f %.2f %.2f \n" , v.rect.origin.x , v.rect.origin.y , v.rect.size.width , v.rect.size.height );
            if( v.getConnections().empty() == false)
            {
                for( const auto &c : v.getConnections())
                {
                    printf("\t\t\t\t%s dest :%s \n" , c.type.c_str() , c.destination.c_str() );
                    
                    for( const auto &param : c.parameters)
                    {
                        printf("\t\t\t\t\t'%s':'%s'\n" , param.first.c_str() , param.second.c_str() );
                    }
                }
            }
        }
        
    }
    // sleep(5);
    return 0;
}
