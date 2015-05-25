//
//  main.cpp
//  xmlCmp
//
//  Created by Helios on 15/4/26.
//  Copyright (c) 2015年 Helios. All rights reserved.
//

#include <iostream>
#include <set>
#include <stdio.h>
#include <time.h>
//#include "xmldiff.h"
#include "libxml2/libxml/tree.h"
#include "libxml2/libxml/parser.h"

struct struNode{
    int userID;
    std::string username;
    std::string password;
    std::string website;
    unsigned long hashValue;
};

bool operator<(const struNode& lhs, const struNode& rhs)
{
    //return lhs.userID < rhs.userID;
    return lhs.hashValue < rhs.hashValue;
}

void traverse(xmlNodePtr node, std::set<struNode> &nodes){
    xmlChar *szKey;
    xmlNodePtr childPtr;
    int memberCursor;
    while (NULL != node) {
        printf("Node Name=%s\n",node->name);
        //szKey=xmlGetProp(node, (const xmlChar *)"ID");
        //xmlSetProp(node, (const xmlChar *)"ID", (const xmlChar *)std::to_string(counter).c_str()); //  sort
        szKey=xmlGetProp(node, (const xmlChar *)"ID");
        printf("%s ID = %s\n",node->name,szKey);
        struNode *newNode = new struNode;
        newNode->userID=atoi((char *)szKey);
        xmlFree(szKey);
        childPtr=node->children;
        memberCursor=0;
        //Start traverse this children's textfields like "Username, UserPassword" etc.
        while (NULL != childPtr) {
            printf("%s:",childPtr->name);
            szKey=xmlNodeGetContent(childPtr);
            printf("%s\n",szKey);
            
            switch (memberCursor++) {
                case 0:{
                    std::string str((char*)szKey);
                    newNode->username=str;
                    break;
                }
                case 1:{
                    std::string str((char*)szKey);
                    newNode->password=str;
                    break;
                }
                case 2:{
                    std::string str((char*)szKey);
                    newNode->website=str;
                    break;
                }
                default:
                    break;
            }
            
            xmlFree(szKey);
            childPtr=childPtr->next;//go go go
            
        }
        
        //printf("%d",counter++);
        
        std::hash<std::string> hash_fn;
        std::string str_cat(std::to_string(newNode->userID)+
                            newNode->username+
                            newNode->password+
                            newNode->website+"real_salts, haha");
        
        //Hash twice, just for fun.
        std::size_t str_hash = hash_fn(
                                       std::to_string(
                                                      hash_fn(str_cat
                                                              )));
        newNode->hashValue=str_hash;
        nodes.insert(*newNode);
        printf("hash value: %lu\n", str_hash);
        node=node->next;//go go go
        std::cout<<'\n';
    }

}

void tteesstt(){
    std::cout<<"tttttttttt"<<std::endl;
}

//bool comparator(const struNode& lhs, const struNode& rhs){
//
///////////////////TODO;
//
//}

int test(int argc, const char * argv[]) {
    std::cout << "Start\n";
    
    clock_t startTime,endTime;
    double time_spent;
    
    xmlDocPtr docA, docB;
    xmlNodePtr nodeA, nodeB;
    xmlKeepBlanksDefault(0);    //Avoid DOM "text".
    if (argc<2) {
        docA = xmlReadFile("/Users/Stephan/Desktop/passwdCap.xml", "UTF-8", XML_PARSE_RECOVER);
        docB = xmlReadFile("/Users/Stephan/Desktop/passwdCap2.xml", "UTF-8", XML_PARSE_RECOVER);
    }else{
        docA = xmlReadFile(argv[1], "UTF-8", XML_PARSE_RECOVER);
        docB = xmlReadFile(argv[2], "UTF-8", XML_PARSE_RECOVER);
    }
    
    //Walk into SubElements
    nodeA = xmlDocGetRootElement(docA);
    nodeB = xmlDocGetRootElement(docB);
    nodeA = nodeA->children;
    nodeB = nodeB->children;
    
    std::set<struNode> nodesA, nodesB, resultA, resultB;
    
    //startTime=clock();

    traverse(nodeA, nodesA);
    xmlFreeDoc(docA);
    traverse(nodeB, nodesB);
    xmlFreeDoc(docB);
    
    std::set_difference(nodesA.begin(), nodesA.end(),
                        nodesB.begin(), nodesB.end(),
                        std::inserter(resultA, resultA.begin()));
    
    std::set_difference(nodesB.begin(), nodesB.end(),
                        nodesA.begin(), nodesA.end(),
                        std::inserter(resultB, resultB.begin()));
    
    //endTime = clock();
    //time_spent = (double)(endTime - startTime)*1000 / CLOCKS_PER_SEC;
    //printf("Time elapsed in %f ms.\n",time_spent);
    //xmlSaveFile("/Users/Stephan/Desktop/passwdCap.xml", doc);
    return 0;
}