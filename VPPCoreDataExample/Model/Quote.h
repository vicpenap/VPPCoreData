//
//  Quote.h
//  VPPCoreDataExample
//
//  Created by Víctor on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Author;

@interface Quote : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * quote;
@property (nonatomic, retain) Author *author;

@end
