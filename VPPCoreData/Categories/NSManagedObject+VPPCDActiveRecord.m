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
    NSManagedObjectContext *moc = [NSManagedObjectContext create];
    return [self moc:moc];
}


+ (NSManagedObjectContext *) mainMOC
{
    return [self moc:[[VPPCoreData sharedInstance] mainContext]];
}

- (NSManagedObjectContext *) moc 
{
    NSManagedObjectContext *moc = [NSManagedObjectContext create];
    return [self moc:moc];
}


- (NSManagedObjectContext *) moc:(NSManagedObjectContext *)moc
{
    [moc setObject:self];
    return [[self class] moc:moc];
}

- (NSManagedObjectContext *) mainMOC 
{
    return [self moc:[[VPPCoreData sharedInstance] mainContext]];
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
