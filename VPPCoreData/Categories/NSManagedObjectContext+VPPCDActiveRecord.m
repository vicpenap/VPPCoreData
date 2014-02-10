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


@interface NSManagedObjectContext (VPPClassName)
extern const char classNameKey_vpp_;
extern const char objectKey_vpp_;


- (NSString *) getClassName_vpp_;
- (id) getObject_vpp_;

@end


@implementation NSManagedObjectContext (VPPClassName)

- (NSString *) getClassName_vpp_
{
    NSString *associatedObject = (NSString *)objc_getAssociatedObject(self, &classNameKey_vpp_);
    return associatedObject;
}

- (id) getObject_vpp_
{
    return objc_getAssociatedObject(self, &objectKey_vpp_);
}


@end

@implementation NSManagedObjectContext (VPPCDActiveRecord)

- (id) create_vpp_ 
{
    return [[VPPCoreData sharedInstance] getNewObjectForEntity:[self getClassName_vpp_] managedObjectContext:self];
}

- (id) refetch_vpp_
{
    return [self fetch:[self getObject_vpp_]];
}

- (id) firstBy:(NSPredicate *)predicate orderBy_vpp_:(NSString *)orderBy
{
    NSArray *objects = [[VPPCoreData sharedInstance] objectsForEntity:[self getClassName_vpp_] orderBy:orderBy filteredBy:predicate fetchLimit:1 offset:0 managedObjectContext:self];
    
    if ([objects count] > 0) 
    {
        return [objects objectAtIndex:0];
    }
    
    return nil;
}

- (NSArray *) all_vpp_ 
{
    return [self findBy:nil orderBy_vpp_:nil];
}

- (NSArray *) findBy_vpp_:(NSPredicate *)predicate
{
    return [self findBy:predicate orderBy_vpp_:nil];
}


- (NSArray *) allOrderBy_vpp_:(NSString *)orderBy
{
    return [[VPPCoreData sharedInstance] allObjectsForEntity:[self getClassName_vpp_] orderBy:orderBy filteredBy:nil managedObjectContext:self];
}

- (NSArray *) findBy:(NSPredicate *)predicate orderBy_vpp_:(NSString *)orderBy
{
    return [self findBy:predicate orderBy:orderBy offset:0 limit_vpp_:0];
}

- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit_vpp_:(int)limit
{
    return [[VPPCoreData sharedInstance] objectsForEntity:[self getClassName_vpp_] orderBy:orderBy filteredBy:predicate fetchLimit:limit offset:offset managedObjectContext:self];
}

- (NSUInteger) count_vpp_
{
    return [self countBy_vpp_:nil];
}

- (NSUInteger) countBy_vpp_:(NSPredicate *)predicate
{
    return [[VPPCoreData sharedInstance] countObjectsForEntity:[self getClassName_vpp_] filteredBy:predicate managedObjectContext:self];
}

- (void) remove_vpp_ 
{
    [[VPPCoreData sharedInstance] deleteObject:[self getObject_vpp_] managedObjectContext:self];
}

- (void) removeAll_vpp_
{
    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:[self getClassName_vpp_] managedObjectContext:self];
}


@end
