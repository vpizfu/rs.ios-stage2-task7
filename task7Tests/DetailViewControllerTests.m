//
//  DetailViewControllerTests.m
//  task7Tests
//
//  Created by Roman on 7/23/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewControllerTests : XCTestCase
@property(nonatomic,strong) DetailViewController *detailViewController;
@end

@implementation DetailViewControllerTests

- (void)setUp {
    [super setUp];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Objects"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"link" ascending:YES]]];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = appDelegate.persistentContainer.viewContext;
    _detailViewController = [[DetailViewController alloc] initWith:[UIImage imageNamed:@"default-image"] titleText:@"Title text" speakersText:@"Roman Kharchenko" descriptionText:@"iOS Developer" videoUrl:@"http://techslides.com/demos/sample-videos/small.mp4" fetchRequest:fetchRequest index:1 context:context count:1];
}

- (void)tearDown {
    [super tearDown];
    _detailViewController = nil;
}

- (void)testViewDidLoad {
    [_detailViewController viewDidLoad];
    XCTAssert(YES);
}

- (void)testViewPlayVideo {
    [_detailViewController playVideo];
    XCTAssert(YES);
}

- (void)testViewShowActivityController {
    [_detailViewController showActivityController];
    XCTAssert(YES);
}

- (void)testWorkWithFavorites {
    [_detailViewController workWithFavorites];
    XCTAssert(YES);
}

@end
