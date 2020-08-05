//
//  XmlObject.h
//  task7
//
//  Created by Roman on 7/20/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XmlObject : NSObject
@property (nonatomic) NSString* title;
@property (nonatomic) NSString* speaker;
@property (nonatomic) NSString* speakerTwo;
@property (nonatomic) NSString* imagerUrl;
@property (nonatomic) NSString* duration;
@property (nonatomic) NSString* descr;
@property (nonatomic) NSString* link;
@property (nonatomic) NSString* videoUrl;
@end

NS_ASSUME_NONNULL_END
