//
//  NSManagedObjectContext+VPPCoreData.m
//  VPPLibraries
//
//  Created by Víctor on 28/03/12.

//    Copyright (c) 2012 Víctor Pena Placer (@vicpenap)
//    http://www.victorpena.es/
//
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy of 
//    this software and associated documentation files (the "Software"), to deal in 
//    the Software without restriction, including without limitation the rights to 
//    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//    the Software, and to permit persons to whom the Software is furnished to do so,
//    subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all 
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
//    SOFTWARE.


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
    return [self fetch:[self getObject]];
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
