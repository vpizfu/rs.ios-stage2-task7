//
//  CancelableTests.m
//  task7Tests
//
//  Created by Roman on 7/23/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Cancelable.h"

@interface CancelableTests : XCTestCase
@property (strong, nonatomic) Cancelable *cancel;
@end

@implementation CancelableTests

- (void)setUp {
    [super setUp];
    _cancel = [[Cancelable alloc] init];
}

- (void)tearDown {
    [super tearDown];
    _cancel = nil;
}

- (void)testCancel {
    BOOL isCancelled = true;
    [_cancel cancel];
    XCTAssertEqual(isCancelled, _cancel.isCancelled);
}

@end
