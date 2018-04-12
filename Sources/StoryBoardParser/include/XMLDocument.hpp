//
//  XMLDocument.hpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#ifndef XMLDocument_hpp
#define XMLDocument_hpp

#include <string>
#include <map>

class XMLNode;

class XMLDocument
{
public:
    
    XMLDocument();
    XMLDocument( const std::string& file);
    ~XMLDocument();
    bool test();
    
    bool isValid() const noexcept;

    XMLNode getRoot() const;
    
private:
    
    void* _impl;
};





class XMLNode
{
    friend class XMLDocument;
    
public:
    
    using Children = std::multimap<std::string, XMLNode>;
    using Properties = std::map<std::string, std::string>;
    
    XMLNode();
    
    std::string getName() const noexcept;
    bool isValid() const noexcept;
    
    
    // Properties
    bool hasProperty( const std::string &name) const;
    std::string getProperty( const std::string &name) const;
    Properties getProperties() const;
    // tree
    std::size_t getChildrenCount() const noexcept;
    XMLNode getChildByName( const std::string &name) const;
    
    Children getChildren() const;
private:
    
    
    
    XMLNode( void* data);
    
    void* _impl;
};

#endif /* XMLDocument_hpp */
