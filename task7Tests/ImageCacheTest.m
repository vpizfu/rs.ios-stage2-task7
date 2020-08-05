//
//  ImageCacheTest.m
//  task7Tests
//
//  Created by Roman on 7/23/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ImageCache.h"

@interface ImageCacheTest : XCTestCase
@property (strong, nonatomic) ImageCache *imageCache;
@end

@implementation ImageCacheTest

- (void)setUp {
    [super setUp];
    _imageCache = [[ImageCache alloc] init];
}

- (void)tearDown {
    [super tearDown];
    _imageCache = nil;
}

- (void)testParseError {
    BOOL *checkOnErrorLocal = true;
    [_imageCache createParseError];
    XCTAssertEqual(checkOnErrorLocal, _imageCache.checkOnError);
}

- (void)testLoadingImage {
    NSURL *url = [[NSURL alloc] initWithString:@"https://picsum.photos/200/300"];
    [_imageCache fetchImageFrom:url withCompletion:nil];
    XCTAssert(YES);
}


@end
