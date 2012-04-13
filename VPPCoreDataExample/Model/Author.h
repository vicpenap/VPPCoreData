//
//  Author.h
//  VPPCoreDataExample
//
//  Created by Víctor on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Quote;

@interface Author : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *quotes;
@end

@interface Author (CoreDataGeneratedAccessors)

- (void)addQuotesObject:(Quote *)value;
- (void)removeQuotesObject:(Quote *)value;
- (void)addQuotes:(NSSet *)values;
- (void)removeQuotes:(NSSet *)values;
@end
