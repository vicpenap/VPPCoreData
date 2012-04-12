//
//  VPPCoreDataActiveRecordProtocol.h
//  VPPLibraries
//
//  Created by Víctor on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol VPPCoreDataActiveRecordManagedObjectContext


- (id) create;

- (id) refetch;

- (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;

- (NSArray *) all;
- (NSArray *) findBy:(NSPredicate *)predicate;

- (NSArray *) allOrderBy:(NSString *)orderBy;
- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;
- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit;

- (int) count;
- (int) countBy:(NSPredicate *)predicate; 

- (void) remove;
- (void) removeAll;


@end




@protocol VPPCoreDataActiveRecord


+ (id) create;

- (id) refetch;

+ (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;

+ (NSArray *) all;
+ (NSArray *) findBy:(NSPredicate *)predicate;

+ (NSArray *) allOrderBy:(NSString *)orderBy;
+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;
+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit;

+ (int) count;
+ (int) countBy:(NSPredicate *)predicate; 

- (void) remove;
+ (void) removeAll;


@end
