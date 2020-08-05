//
//  Cancelable.h
//  task7
//
//  Created by Roman on 7/22/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Cancelable : NSObject
@property (nonatomic, assign, readonly) BOOL isCancelled;
-(void)cancel;
@end

NS_ASSUME_NONNULL_END
