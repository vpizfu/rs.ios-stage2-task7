//
//  XmlParser.m
//  task7
//
//  Created by Roman on 7/20/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "XmlParser.h"

@interface XmlParser ()
@property (nonatomic, strong) NSMutableDictionary *objectDictionary;
@property (nonatomic, strong) NSMutableString *parsingString;
@property (nonatomic, copy) void (^completion)(NSArray<XmlObject *> *, NSError *);
@end

@implementation XmlParser

-(void) parseObjects {
    NSURL *url=[[NSURL alloc] initWithString:@"https://www.ted.com/themes/rss/id"]; // Write your file path here
    NSXMLParser *XML=[[NSXMLParser alloc] initWithContentsOfURL:url];
    XML.delegate=self;
    [XML parse];
}

//MARK: - Parser
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if (self.completion) {
        self.completion(nil, parseError);
    }
    [self resetParserState];
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    self.objects =  [NSMutableArray new];
}

-(NSMutableArray* )getArray {
    return self.objects;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {

    if ([elementName isEqualToString:@"item"]) {
        self.objectDictionary = [NSMutableDictionary new];
    } else if ([elementName isEqualToString:@"title"]) {
        self.parsingString = [NSMutableString new];
    } else if ([elementName isEqualToString:@"media:credit"]) {
        self.parsingString = [NSMutableString new];
    } else if ([elementName isEqualToString:@"link"]) {
        self.parsingString = [NSMutableString new];
    } else if ([elementName isEqualToString:@"description"]) {
        self.parsingString = [NSMutableString new];
    } else if ([elementName isEqualToString:@"itunes:duration"]) {
        self.parsingString = [NSMutableString new];
    } else if ([elementName isEqualToString:@"itunes:image"] || [elementName isEqualToString:@"enclosure"]) {
        self.parsingString = [[NSMutableString alloc] initWithString:[attributeDict valueForKey:@"url"]];
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.parsingString appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"title"] || [elementName isEqualToString:@"link"] || [elementName isEqualToString:@"description"] || [elementName isEqualToString:@"itunes:image"] || [elementName isEqualToString:@"itunes:duration"] || [elementName isEqualToString:@"enclosure"]) {
        [self.objectDictionary setValue:self.parsingString forKey:elementName];
        self.parsingString = nil;
    } else if ([elementName isEqualToString:@"media:credit"]) {
        if ([self.objectDictionary objectForKey:@"speakerOne"] != nil) {
             [self.objectDictionary setValue:self.parsingString forKey:@"speakerTwo"];
              self.parsingString = nil;
        } else {
            [self.objectDictionary setValue:self.parsingString forKey:@"speakerOne"];
            self.parsingString = nil;
        }
    } else if ([elementName isEqualToString:@"item"]) {
        XmlObject* object = [XmlObject new];
        object.title = [[self.objectDictionary objectForKey:@"title"] substringWithRange: NSMakeRange(0, [[self.objectDictionary objectForKey:@"title"] rangeOfString: @"|"].location)];
         object.duration = [[self.objectDictionary objectForKey:@"itunes:duration"] substringWithRange: NSMakeRange(3, 5)];
        object.link = [self.objectDictionary objectForKey:@"link"];
        object.descr = [self.objectDictionary objectForKey:@"description"];
        object.imagerUrl = [self.objectDictionary objectForKey:@"itunes:image"];
        object.speaker = [self.objectDictionary objectForKey:@"speakerOne"];
        object.videoUrl = [self.objectDictionary objectForKey:@"enclosure"];
        if ([self.objectDictionary objectForKey:@"speakerTwo"] != nil) {
            object.speakerTwo = [self.objectDictionary objectForKey:@"speakerTwo"];
        }
        self.objectDictionary = nil;
        [self.objects addObject:object];
    }
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    if (self.completion) {
        self.completion(self.objects, nil);
    }
    [self resetParserState];
}

-(void)resetParserState {
    self.completion = nil;
    self.objectDictionary = nil;
    self.parsingString = nil;
}

@end
