//
//  XMLDocument.cpp
//  StoryBoardParser
//
//  Created by Manuel Deneu on 30/03/2018.
//  Copyright © 2018 Manuel Deneu. All rights reserved.
//

#include "include/XMLDocument.hpp"

#include <libxml/xmlreader.h>
#include <libxml/tree.h>





static bool loadFile( xmlDocPtr *docPtr, const std::string &file)
{
    LIBXML_TEST_VERSION
    
    xmlParserCtxtPtr ctx = xmlNewParserCtxt();
    
    xmlDocPtr ptr = xmlCtxtReadFile( ctx, file.c_str(), NULL, XML_PARSE_DTDATTR/*XML_PARSE_DTDVALID*/);
    
    
    xmlFreeParserCtxt(ctx);
    
    if( ptr == nullptr)
        return false;
    
    *docPtr = ptr;
    
    return true;
}

XMLDocument::XMLDocument( const std::string&file):
_impl(nullptr)
{
    //auto ptr = static_cast<xmlDocPtr>( _impl );
    if( loadFile( (xmlDocPtr*)&_impl , file) == false)
    {
        printf("Error loading file '%s'\n" , file.c_str() );
    }
    
}

XMLDocument::~XMLDocument()
{
    if( _impl)
    {
        xmlFreeDoc( static_cast<xmlDocPtr>( _impl ) );
    }
}

bool XMLDocument::isValid() const noexcept
{
    return _impl;
}

bool test()
{
    return false;
}


XMLNode XMLDocument::getRoot() const
{
    const auto root = xmlDocGetRootElement( static_cast<xmlDocPtr>( _impl ) );
    return XMLNode(root);
}


/* **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** */
/* **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** **** */

XMLNode::XMLNode():
_impl(nullptr)
{
    
}

XMLNode::XMLNode( void* data):
_impl(data)
{
    
}

std::string XMLNode::getName() const noexcept
{
    return (const char*) static_cast<xmlNodePtr>(_impl)->name;
}

bool XMLNode::isValid() const noexcept
{
    return _impl;
}


bool XMLNode::hasProperty( const std::string &name) const
{
    return xmlHasProp( static_cast<xmlNodePtr>(_impl), (const xmlChar *)name.c_str() );
}
std::string XMLNode::getProperty( const std::string &name) const
{
    std::string ret;
    
    xmlChar * v = xmlGetProp(static_cast<xmlNodePtr>(_impl), (const xmlChar *)name.c_str());
    
    if( v)
        ret =  (const char*) v;
    free(v);
    
    return  ret;
    
}

XMLNode::Properties XMLNode::getProperties() const
{
    XMLNode::Properties p;
    
    const xmlAttr* attribute = static_cast<xmlNodePtr>(_impl)->properties;
    
    while(attribute)
    {
        xmlChar* value = xmlNodeListGetString(static_cast<xmlNodePtr>(_impl)->doc, attribute->children, 1);
        
        p.insert(std::make_pair( (const char*) attribute->name , (const char*) value ) );
        //do something with value
        xmlFree(value);
        attribute = attribute->next;
    }
    
    return p;
}

std::size_t XMLNode::getChildrenCount() const noexcept
{
    return (std::size_t) xmlChildElementCount( static_cast<xmlNodePtr>(_impl) );
}

XMLNode::Children XMLNode::getChildren() const
{
    XMLNode::Children r;
    
    xmlNode *curNode = nullptr;
    for (curNode = static_cast<xmlNodePtr>(_impl)->children; curNode; curNode = curNode->next)
    {
        if( curNode->type == XML_ELEMENT_NODE)
        {
            r.insert( std::make_pair( std::string( (const char*) curNode->name ) , XMLNode( curNode) ) );
        }
    }
    
    return r;
}

XMLNode XMLNode::getChildByName( const std::string &name) const
{
    
    xmlNode *curNode = nullptr;
    for (curNode = static_cast<xmlNodePtr>(_impl)->children; curNode; curNode = curNode->next)
    {
        if( curNode->type == XML_ELEMENT_NODE && xmlStrcmp((const xmlChar*) name.c_str(), curNode->name) == 0)
        {
            return curNode;
        }
    }
    
    return XMLNode();
}
