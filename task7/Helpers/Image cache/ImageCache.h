//
//  ImageCache.h
//  task7
//
//  Created by Roman on 7/20/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Cancelable.h"

NS_ASSUME_NONNULL_BEGIN

@interface ImageCache : NSObject
@property (class, strong, nonatomic, readonly) ImageCache* shared;
@property (nonatomic, assign) BOOL checkOnError;
-(Cancelable *) fetchImageFrom:(NSURL*)url withCompletion:(void (^)(UIImage* _Nullable image, NSError* _Nullable error)) completion;
-(NSError*) createParseError;
@end

NS_ASSUME_NONNULL_END
