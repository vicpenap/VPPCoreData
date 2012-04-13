//
//  VPPCoreDataActiveRecordProtocol.h
//  VPPLibraries
//
//  Created by Víctor on 28/03/12.
//
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



#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/** The `VPPCoreDataActiveRecordManagedObjectContext` defines a set of methods 
 to perform core data actions from a given managed object context. This protocol 
 helps to perform Active Record actions from a different managed object context
 with a simple syntax.
 
 You should only call these methods from a managed object context obtained through 
 a NSManagedObject. For example:
 
    NSManagedObjectContext *aDifferentMOC = ... ;
    [[Quote moc:aDifferentMOC] all];
    [[Quote moc:aDifferentMOC] findBy:somePredicate];
 
 **Never** invoke any of these methods directly from a given managed object context,
 for example:
 
    NSManagedObjectContext *aDifferentMOC = ... ;
    [aDifferentMOC all];
 
 
*/

@protocol VPPCoreDataActiveRecordManagedObjectContext

/** Returns a new instance of the caller class. 
 
 If the object doesn't contain any required attribute, it will be automatically
 persisted. */
- (id) create;

/** Refetches the object from the specified managed object context. */
- (id) refetch;

/** Returns the first object from the caller class.
 
 @param predicate the predicate to filter with.
 @param orderBy an SQL-like order by clause. */
- (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;

/** Returns all objects from the caller class. */
- (NSArray *) all;

/** Returns all objects from the caller class.
 
 @param orderBy an SQL-like order by clause. */
- (NSArray *) allOrderBy:(NSString *)orderBy;

/** Returns objects from the caller class. 
 
 @param predicate the predicate to filter with.
 */
- (NSArray *) findBy:(NSPredicate *)predicate;

/** Returns objects from the caller class. 
 
 @param predicate the predicate to filter with.
 @param orderBy an SQL-like order by clause. */
- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;

/** Returns objects from the caller class. 
 
 @param predicate the predicate to filter with.
 @param orderBy an SQL-like order by clause. 
 @param offset the index of the first element to retrieve.
 @param limit the maximum amount of objects to retrieve.
 */
- (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit;


/** Returns the total amount of the objects from the caller class. */
- (int) count;

/** Returns the total amount of the objects from the caller class. 
 
 @param predicate the predicate to filter with. */
- (int) countBy:(NSPredicate *)predicate; 

/** Removes the calling object. */
- (void) remove;

/** Removes all objects from the caller class. */
- (void) removeAll;


@end



/** The `VPPCoreDataActiveRecord` defines a set of methods 
 to perform core data actions from a given managed object. This protocol brings 
 the Active Record pattern to Objective-c.
 
 You may notice that there's no save method. This is due to the nature of Core Data.
 When you want to save changes, call the `saveChanges:` method from the Managed Object
 Context you are using.

 */

@protocol VPPCoreDataActiveRecord

/** Returns a new instance of the caller class. 
 
 If the object doesn't contain any required attribute, it will be automatically
 persisted. */
+ (id) create;

/** Refetches the object from the specified managed object context. */
- (id) refetch;

/** Returns the first object from the caller class.
 
 @param predicate the predicate to filter with.
 @param orderBy an SQL-like order by clause. */
+ (id) firstBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;

/** Returns all objects from the caller class. */
+ (NSArray *) all;

/** Returns all objects from the caller class.
 
 @param orderBy an SQL-like order by clause. */
+ (NSArray *) allOrderBy:(NSString *)orderBy;


/** Returns all objects from the caller class. 
 
 @param predicate the predicate to filter with.
 */
+ (NSArray *) findBy:(NSPredicate *)predicate;

/** Returns all objects from the caller class. 
 
 @param predicate the predicate to filter with.
 @param orderBy an SQL-like order by clause. */
+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy;

/** Returns objects from the caller class. 
 
 @param predicate the predicate to filter with.
 @param orderBy an SQL-like order by clause. 
 @param offset the index of the first element to retrieve.
 @param limit the maximum amount of objects to retrieve.
 */
+ (NSArray *) findBy:(NSPredicate *)predicate orderBy:(NSString *)orderBy offset:(int)offset limit:(int)limit;


/** Returns the total amount of the objects from the caller class. */
+ (int) count;

/** Returns the total amount of the objects from the caller class. 
 
 @param predicate the predicate to filter with. */
+ (int) countBy:(NSPredicate *)predicate; 


/** Removes the calling object. */
- (void) remove;

/** Removes all objects from the caller class. */
+ (void) removeAll;


@end
