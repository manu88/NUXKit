//
//  SB_View.hpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef SB_View_hpp
#define SB_View_hpp

#include <list>
#include <string>
#include <map>
#include "SB_Parameters.hpp"

namespace Storyboard
{
    class Connection
    {
    public:
        std::string destination;
        std::string type;
        
        std::map<std::string , std::string> parameters;
        
    };
    
    
    class View
    {
    public:
        using SubViews = std::list<View>;
        using Connections = std::list<Connection>;
        
        std::string name;
        
        std::size_t getSubViewsCount() const noexcept;
        
        bool addSubView( View &view);
        
        const SubViews getSubViews() const noexcept
        {
            return _subViews;
        }
        
        bool addConnection( Connection &c);
        
        const Connections getConnections() const noexcept
        {
            return _connections;
        }
        
        std::map<std::string , std::string> parameters;
        Storyboard::Rect rect;
    private:
        SubViews _subViews;
        Connections _connections;
    };
}

#endif /* SB_View_hpp */
