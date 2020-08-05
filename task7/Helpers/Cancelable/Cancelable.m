//
//  Cancelable.m
//  task7
//
//  Created by Roman on 7/22/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "Cancelable.h"


@interface Cancelable ()
@end

@implementation Cancelable

-(id)init {
    self = [super init];
    if (self) {
        _isCancelled = false;
    }
    return self;
}

-(void)cancel {
    _isCancelled = true;
}

@end
