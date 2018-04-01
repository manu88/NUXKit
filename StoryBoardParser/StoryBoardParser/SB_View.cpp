//
//  SB_View.cpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include "SB_View.hpp"


std::size_t Storyboard::View::getSubViewsCount() const noexcept
{
    return _subViews.size();
}

bool Storyboard::View::addSubView( View &view)
{
    _subViews.push_back(view);
    return true;
}

bool Storyboard::View::addConnection( Connection &c)
{
    _connections.push_back(c);
    return true;
}
