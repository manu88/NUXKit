//
//  SB_Parameters.hpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 31/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef SB_Parameters_hpp
#define SB_Parameters_hpp

#include <stdio.h>

namespace Storyboard
{
    typedef struct
    {
        float r;
        float g;
        float b;
        float a;
    } Color;
    
    
    typedef struct
    {
        float x;
        float y;
    } Point;
    
    typedef struct
    {
        float width;
        float height;
    } Size;
    
    typedef struct
    {
        Point origin;
        Size  size;
    } Rect;
}

#endif /* SB_Parameters_hpp */
