//
//  NSManagedObjectContext+VPPCoreData.m
//  Wiktionary
//
//  Created by Víctor on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+VPPCDActiveRecord.h"
#import <objc/runtime.h>
#import "VPPCoreData.h"


@interface NSManagedObjectContext (ClassName)
extern const char classNameKey;
extern const char objectKey;


- (NSString *) getClassName;
- (id) getObject;

@end


@implementation NSManagedObjectContext (ClassName)

- (NSString *) getClassName 
{
    NSString *associatedObject = (NSString *)objc_getAssociatedObject(self, &classNameKey);
    return associatedObject;
}

- (id) getObject
{
    return objc_getAssociatedObject(self, &objectKey);    
}


@end

@implementation NSManagedObjectContext (VPPCDActiveRecord)

- (id) create 
{
    return [[VPPCoreData sharedInstance] getNewObjectForEntity:[self getClassName] managedObjectContext:self];
}

- (id) refetch
{
    return [[VPPCoreData sharedInstance] objectWithExistingID:[self getObject] managedObjectContext:self];
}

- (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy
{
    NSArray *objects = [[VPPCoreData sharedInstance] objectsForEntity:[self getClassName] orderBy:orderBy filteredBy:predicate fetchLimit:1 offset:0 managedObjectContext:self];
    
    if ([objects count] > 0) 
    {
        return [objects objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray *) all 
{
    return [self findBy:nil orderBy:nil];
}

- (NSArray *) findBy:(NSPredicate *)predicate
{
    return [self findBy:predicate orderBy:nil];
}


- (NSArray *) allOrderBy:(NSString *)orderBy
{
    return [[VPPCoreData sharedInstance] allObjectsForEntity:[self getClassName] orderBy:orderBy filteredBy:nil managedObjectContext:self];
}

- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy
{
    return [self findBy:predicate orderBy:orderBy offset:0 limit:0];
}

- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit
{
    return [[VPPCoreData sharedInstance] objectsForEntity:[self getClassName] orderBy:orderBy filteredBy:predicate fetchLimit:limit offset:offset managedObjectContext:self];
}

- (int) count
{
    return [self countBy:nil];
}

- (int) countBy:(NSPredicate *)predicate
{
    return [[VPPCoreData sharedInstance] countObjectsForEntity:[self getClassName] filteredBy:predicate managedObjectContext:self];    
}

- (void) remove 
{
    [[VPPCoreData sharedInstance] deleteObject:[self getObject] managedObjectContext:self];
}

- (void) removeAll
{
    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:[self getClassName] managedObjectContext:self];
}


@end
