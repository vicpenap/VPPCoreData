//
//  VPPCoreDataActiveRecordProtocol.h
//  Wiktionary
//
//  Created by Víctor on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@protocol VPPCoreDataActiveRecordManagedObject


- (id) create;

//TODO: implement
- (id) refetch;

- (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;
- (NSArray *) all;
- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;
- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit;

//TODO: implement
- (int) countAll;
- (int) countBy; 

//TODO: implement
- (void) save;

- (void) remove;


@end




@protocol VPPCoreDataActiveRecord


+ (id) create;

//TODO: implement
- (id) refetch;

+ (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;
+ (NSArray *) all;
+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;
+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit;

//TODO: implement
+ (int) countAll;
+ (int) countBy; 

//TODO: implement
- (void) save; 

- (void) remove;


@end
