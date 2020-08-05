//
//  XmlParserTests.m
//  task7Tests
//
//  Created by Roman on 7/23/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "XmlParser.h"

@interface XmlParserTests : XCTestCase
@property (nonatomic, strong) XmlParser *parser;
@end

@implementation XmlParserTests

- (void)setUp {
    [super setUp];
    _parser = [XmlParser new];
}

- (void)tearDown {
    [super tearDown];
    _parser = nil;
}

- (void)testExample {
    [_parser parseObjects];
    [_parser getArray];
    XCTAssert(YES);
}


@end
