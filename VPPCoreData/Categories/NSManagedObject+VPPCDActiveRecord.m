//
//  NSManagedObject+VPPCoreData.m
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
#import "NSManagedObject+VPPCDActiveRecord.h"
#import "VPPCoreData.h"
#import <objc/runtime.h>



@interface NSManagedObjectContext (VPPObject)

extern const char classNameKey_vpp_;
extern const char objectKey_vpp_;

- (void) setClassName_vpp_:(NSString *)className;
- (void) setObject_vpp_:(id)object;


@end


@implementation NSManagedObjectContext (VPPObject)
const char classNameKey_vpp_;
const char objectKey_vpp_;

- (void) setClassName_vpp_:(NSString *)className
{
    objc_setAssociatedObject(self, &classNameKey_vpp_, className, OBJC_ASSOCIATION_RETAIN);
}

- (void) setObject_vpp_:(id)object
{
    objc_setAssociatedObject(self, &objectKey_vpp_, object, OBJC_ASSOCIATION_RETAIN);
}

@end


@implementation NSManagedObject (VPPCDActiveRecord)

+ (NSString *) className_vpp_ 
{
    return NSStringFromClass(self);
}

+ (NSManagedObjectContext *) moc_vpp_:(NSManagedObjectContext *)moc
{
    NSString *class = [self className_vpp_];
    [moc setClassName_vpp_:class];
    return moc;    
}

+ (NSManagedObjectContext *) moc_vpp_ 
{
    NSManagedObjectContext *moc = [NSManagedObjectContext create];
    return [self moc_vpp_:moc];
}


+ (NSManagedObjectContext *) mainMOC_vpp_
{
    return [self moc_vpp_:[[VPPCoreData sharedInstance] mainContext]];
}

- (NSManagedObjectContext *) moc_vpp_ 
{
    NSManagedObjectContext *moc = [NSManagedObjectContext create];
    return [self moc_vpp_:moc];
}


- (NSManagedObjectContext *) moc_vpp_:(NSManagedObjectContext *)moc
{
    [moc setObject_vpp_:self];
    return [[self class] moc_vpp_:moc];
}

- (NSManagedObjectContext *) mainMOC_vpp_ 
{
    return [self moc_vpp_:[[VPPCoreData sharedInstance] mainContext]];
}





+ (id) create_vpp_ 
{
    return [[self mainMOC_vpp_] create_vpp_];
}

- (id) refetch_vpp_ 
{
    return [[self mainMOC_vpp_] refetch_vpp_];
}


+ (id) firstBy:(NSPredicate *)predicate orderBy_vpp_:(NSString *)orderBy
{
    return [[self mainMOC_vpp_] firstBy:predicate orderBy_vpp_:orderBy];
}

+ (NSArray *) all_vpp_ 
{
    return [[self mainMOC_vpp_] all_vpp_];
}

+ (NSArray *) findBy_vpp_:(NSPredicate *)predicate
{
    return [[self mainMOC_vpp_] findBy_vpp_:predicate];
}

+ (NSArray *) allOrderBy_vpp_:(NSString *)orderBy
{
    return [[self mainMOC_vpp_] allOrderBy_vpp_:orderBy];
}

+ (NSArray *) findBy:(NSPredicate *)predicate orderBy_vpp_:(NSString *)orderBy
{
    return [[self mainMOC_vpp_] findBy:predicate orderBy_vpp_:orderBy];
}

+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit_vpp_:(int)limit
{
    return [[self mainMOC_vpp_] findBy:predicate orderBy:orderBy offset:offset limit_vpp_:limit];
}

+ (NSUInteger) count_vpp_
{
    return [[self mainMOC_vpp_] count_vpp_];
}

+ (NSUInteger) countBy_vpp_:(NSPredicate *)predicate
{
    return [[self mainMOC_vpp_] countBy_vpp_:predicate];
}

- (void) remove_vpp_ 
{
    [[self mainMOC_vpp_] remove_vpp_];
}

+ (void) removeAll_vpp_
{
    [[self mainMOC_vpp_] removeAll_vpp_];
}

@end
