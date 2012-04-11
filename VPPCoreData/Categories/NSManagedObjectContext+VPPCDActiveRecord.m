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

// TODO: update this call to use a future first sorted from vppcoredata
- (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy
{
    return [[VPPCoreData sharedInstance] findObjectFromEntity:[self getClassName] withPredicate:predicate managedObjectContext:self];
}

- (NSArray *) all 
{
    return [[VPPCoreData sharedInstance] allObjectsForEntity:[self getClassName] sortDescriptors:nil filteredBy:nil managedObjectContext:self];
}

- (NSArray *) findBy:(NSPredicate *)predicate
{
    return [[VPPCoreData sharedInstance] allObjectsForEntity:[self getClassName] orderBy:nil filteredBy:predicate managedObjectContext:self];
}


- (NSArray *) allOrderBy:(NSString *)orderBy
{
    return [[VPPCoreData sharedInstance] allObjectsForEntity:[self getClassName] orderBy:orderBy filteredBy:nil managedObjectContext:self];
}

- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy
{
    return [[VPPCoreData sharedInstance] allObjectsForEntity:[self getClassName] orderBy:orderBy filteredBy:predicate managedObjectContext:self];
}

- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit
{
    return [[VPPCoreData sharedInstance] objectsForEntity:[self getClassName] orderBy:orderBy filteredBy:predicate fetchLimit:limit offset:offset managedObjectContext:self];
}

- (void) remove 
{
    [[VPPCoreData sharedInstance] deleteObject:[self getObject] managedObjectContext:self];
}



@end
