//
//  NSManagedObject+VPPCoreData.m
//  VPPLibraries
//
//  Created by Víctor on 28/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSManagedObjectContext+VPPCDActiveRecord.h"
#import "NSManagedObject+VPPCDActiveRecord.h"
#import "VPPCoreData.h"
#import <objc/runtime.h>



@interface NSManagedObjectContext (Object)

extern const char classNameKey;
extern const char objectKey;

- (void) setClassName:(NSString *)className;
- (void) setObject:(id)object;


@end


@implementation NSManagedObjectContext (Object)
const char classNameKey;
const char objectKey;

- (void) setClassName:(NSString *)className 
{
    objc_setAssociatedObject(self, &classNameKey, className, OBJC_ASSOCIATION_RETAIN);
}

- (void) setObject:(id)object
{
    objc_setAssociatedObject(self, &objectKey, object, OBJC_ASSOCIATION_RETAIN);    
}

@end


@implementation NSManagedObject (VPPCDActiveRecord)

+ (NSString *) className 
{
    return NSStringFromClass(self);
}

+ (NSManagedObjectContext *) moc:(NSManagedObjectContext *)moc
{
    NSString *class = [self className];
    [moc setClassName:class];
    return moc;    
}

+ (NSManagedObjectContext *) moc 
{
    NSManagedObjectContext *moc = [[VPPCoreData sharedInstance] createManagedObjectContext];
    return [self moc:moc];
}


+ (NSManagedObjectContext *) mainMOC
{
    return [self moc:[[VPPCoreData sharedInstance] mainContext]];
}

- (NSManagedObjectContext *) moc 
{
    return [[self class] moc];
}


- (NSManagedObjectContext *) moc:(NSManagedObjectContext *)moc
{
    return [[self class] moc:moc];
}

- (NSManagedObjectContext *) mainMOC 
{
    return [[self class] moc:[[VPPCoreData sharedInstance] mainContext]];
}





+ (id) create 
{
    return [[self mainMOC] create];
}

- (id) refetch 
{
    return [[self mainMOC] refetch];
}


+ (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy
{
    return [[self mainMOC] firstBy:predicate orderBy:orderBy];
}

+ (NSArray *) all 
{
    return [[self mainMOC] all];
}

+ (NSArray *) findBy:(NSPredicate *)predicate
{
    return [[self mainMOC] findBy:predicate];
}

+ (NSArray *) allOrderBy:(NSString *)orderBy
{
    return [[self mainMOC] allOrderBy:orderBy];
}

+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy
{
    return [[self mainMOC] findBy:predicate orderBy:orderBy];
}

+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit
{
    return [[self mainMOC] findBy:predicate orderBy:orderBy offset:offset limit:limit];
}

+ (int) count
{
    return [[self mainMOC] count];
}

+ (int) countBy:(NSPredicate *)predicate
{
    return [[self mainMOC] countBy:predicate];
}

- (void) remove 
{
    [[self mainMOC] remove];
}

+ (void) removeAll
{
    [[self mainMOC] removeAll];
}

@end
