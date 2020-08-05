//
//  XmlParser.h
//  task7
//
//  Created by Roman on 7/20/20.
//  Copyright © 2020 Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XmlObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface XmlParser : NSObject <NSXMLParserDelegate>
@property (nonatomic, strong) NSMutableArray *objects;
-(void) parseObjects;
-(NSMutableArray* )getArray;
@end

NS_ASSUME_NONNULL_END
