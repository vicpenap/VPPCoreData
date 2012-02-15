//
//  Service.h
//  VPPCoreDataExample
//
//  Created by Víctor on 14/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Quote.h"
@interface Service : NSObject

+ (Quote *) createQuoteWithText:(NSString *)text;
+ (void) findQuotesWithText:(NSString *)text completion:(void (^) (NSArray *data))block;
+ (void) allQuotesCompletion:(void (^) (NSArray *data))block; 
+ (void) removeAllObjects;
+ (int) countAllObjects;

@end
