//
//  ImageCache.m
//  task7
//
//  Created by Roman on 7/20/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import "ImageCache.h"

@interface ImageCache ()
@property (strong, nonatomic) dispatch_queue_t callbackQueue;
@property (strong, nonatomic) dispatch_queue_t processingQueue;
@end

@implementation ImageCache

static ImageCache* _identifier = nil;

-(id) init {
    if (self = [super init]) {
        self.callbackQueue = dispatch_get_main_queue();
        self.processingQueue = dispatch_get_global_queue(QOS_CLASS_UTILITY, 0);
    }
    return self;
}

+(ImageCache *)shared {
  if (_identifier == nil) {
    _identifier = [[ImageCache alloc] init];
  }
  return _identifier;
}

//MARK: - File management
//- (NSString*)getKeyFrom:(NSURL *)url {
//    return [url.absoluteString stringByReplacingOccurrencesOfString:@"/" withString:@""];
//}

//- (NSURL*)getCachePathFrom:(NSString *)key {
//    __auto_type paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    __auto_type cacheDirectory = [paths objectAtIndex:0];
//    __auto_type cacheDirectoryUrl = [[NSURL alloc] initWithString:cacheDirectory];
//    return [cacheDirectoryUrl URLByAppendingPathComponent:key];
//}

//- (UIImage*)loadImageFromDiskFor:(NSString*)key {
//    __auto_type path = [self getCachePathFrom:key];
//    return [[UIImage alloc] initWithContentsOfFile:path.absoluteString];
//}

//- (void)saveToDisk:(UIImage*)image forKey:(NSString*)key {
//    [UIImagePNGRepresentation(image) writeToFile:key atomically:NO];
//}

//MARK: - Network
-(Cancelable *)fetchImageFrom:(NSURL *)url withCompletion:(void (^)(UIImage * _Nullable image, NSError * _Nullable error))completion {
    return [self loadImageFrom:url withCompletion:completion];
}

-(Cancelable *)loadImageFrom:(NSURL *)url withCompletion:(void (^)(UIImage * _Nullable, NSError * _Nullable))completion {
    __weak typeof (self) weakSelf = self;
    
    
    Cancelable *cancelable = [[Cancelable alloc] init];
    
    __auto_type completionTemp = ^void(UIImage* _Nullable image, NSError* _Nullable error) {
        if ([cancelable isCancelled]) {
            return;
        }
        dispatch_async(weakSelf.callbackQueue, ^{
            completion(image, error);
        });
    };
    
    
    __auto_type task = [NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [weakSelf parseImageFrom:data response:response withCompletion: completionTemp];
    }];
    
    [task resume];
    return cancelable;
}

-(void)parseImageFrom:(NSData*)data response:(NSURLResponse*)response withCompletion:(void (^)(UIImage * _Nullable image, NSError * _Nullable error))completion {
    __weak typeof (self) weakSelf = self;
    
    dispatch_async(self.processingQueue, ^{
         __auto_type httpResponse = (NSHTTPURLResponse*)response;
         if (httpResponse.statusCode >= 400) {
             completion(nil, [weakSelf createParseError]);
         }
        __auto_type image = [[UIImage alloc] initWithData:data];
        if (image != NULL) {
            completion(image, nil);
//            [self saveToDisk:image forKey:[self getKeyFrom:response.URL]];
//            __auto_type url = [self getCachePathFrom:[self getKeyFrom:response.URL]];
//            __auto_type image_2 = [UIImage imageNamed:url.absoluteString];
//            NSLog(@"%f",image_2.size.width);
            
        } else {
            completion(nil, [weakSelf createParseError]);
        }
    });
}

-(NSError*)createParseError {
    _checkOnError = true;
    return [[NSError alloc] initWithDomain:@"ImageCache" code:1 userInfo:nil];
}

@end
