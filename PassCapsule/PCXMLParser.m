//
//  PCXMLParser.m
//  PassCapsule
//
//  Created by 邵建勇 on 15/5/6.
//  Copyright (c) 2015年 John Shaw. All rights reserved.
//

#import "PCXMLParser.h"
#import "PCCapsule.h"

@implementation PCXMLParser

-(NSMutableArray *)paserWithPath:(NSString *)path{
    self.elementToParse = @[@"title",@"account",@"pass",@"site",@"icon",@"category"];
    //打开xml文件，读取数据到NSData
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"Books" ofType:@"xml"];
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:path];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    //测试从xml接受到的数据
//    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",dataString);
    
    NSXMLParser *m_parser = [[NSXMLParser alloc] initWithData:data];
    //设置该类本身为代理类，即该类在声明时要实现NSXMLParserDelegate委托协议
//    [m_parser setDelegate:self];  //设置代理为本地
    m_parser.delegate = self;
    BOOL flag = [m_parser parse]; //开始解析
    
    if(flag) {
        NSLog(@"解析指定路径的xml文件成功");
        return self.capsules;
    }
    else {
        NSLog(@"解析指定路径的xml文件失败");
        return nil;
    }
    
}


#pragma mark - XMLDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"Capsules"]) {
        //Initialize the array.
        //在这里初始化用于存储最终解析结果的数组变量,我们是在当遇到Books根元素时才开始初始化
        self.capsules = [[NSMutableArray alloc] init];
    }
    else if([elementName isEqualToString:@"Capsule"]) {
        
        //Initialize the book.
        //当碰到Book元素时，初始化用于存储Book信息的实例对象aBook
        
        self.aCapusle = [[PCCapsule alloc] init];
        
        //Extract the attribute here.
        //从attributeDict字典中读取Book元素的属性
        
        self.aCapusle.capsuleID = [[attributeDict objectForKey:@"id"] integerValue];
        
        NSLog(@"ID:%li", (long)self.aCapusle.capsuleID);
    }
    self.storingFlag = [self.elementToParse containsObject:elementName];  //判断是否存在要存储的对象
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    // 当用于存储当前元素的值是空时，则先用值进行初始化赋值
    // 否则就直接追加信息
    if (self.storingFlag) {
        if (!self.currentElementValue) {
            self.currentElementValue = [[NSMutableString alloc] initWithString:string];
        }
        else {
            [self.currentElementValue appendString:string];
        }
    }
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([elementName isEqualToString:@"Capsule"]) {
        [self.capsules addObject:self.aCapusle];
        self.aCapusle = nil;
    }
    
    if (self.storingFlag) {
        //去掉字符串的空格
        NSString *trimmedString = [self.currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        //将字符串置空
        [self.currentElementValue setString:@""];
        
        if ([elementName isEqualToString:@"title"]) {
            self.aCapusle.title = trimmedString;
            NSLog(@"title :%@",self.aCapusle.title);
        }
        if ([elementName isEqualToString:@"account"]) {
            self.aCapusle.account = trimmedString;
            NSLog(@"account :%@",self.aCapusle.account);
        }
        if ([elementName isEqualToString:@"pass"]) {
            self.aCapusle.pass = trimmedString;
            NSLog(@"pass :%@",self.aCapusle.pass);
        }
        if ([elementName isEqualToString:@"site"]) {
            self.aCapusle.site = trimmedString;
            NSLog(@"site :%@",self.aCapusle.site);
        }
        if ([elementName isEqualToString:@"icon"]) {
            self.aCapusle.iconName = trimmedString;
            NSLog(@"iconName :%@",self.aCapusle.iconName);
        }
        if ([elementName isEqualToString:@"category"]) {
            self.aCapusle.category = trimmedString;
            NSLog(@"category :%@",self.aCapusle.category);
        }
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"%@",self.capsules);
}

@end
