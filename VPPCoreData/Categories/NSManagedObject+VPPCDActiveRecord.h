//
//  NSManagedObject+VPPCoreData.h
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


#import <CoreData/CoreData.h>
#import "VPPCoreDataActiveRecordProtocol.h"


/** This category adds ability to perform Active Record actions from different
 managed object context with a simple syntax.
 
 For example:
 
 NSManagedObjectContext *aDifferentMOC = ... ;
 [[Quote moc:aDifferentMOC] all];
 [[Quote moc:aDifferentMOC] findBy:somePredicate]; 
 */

@interface NSManagedObject (VPPCDActiveRecord) <VPPCoreDataActiveRecord>

/** Returns a new autoreleased managed object context, already configured with the
 persistent store coordinator and the class invoking it. This managed object context
 conforms to the protocol VPPCoreDataActiveRecordManagedObjectContext. */
+ (NSManagedObjectContext *) moc;

/** Returns the same managed object context passed as parameter, after configured it with the
 persistent store coordinator and the class invoking it. This managed object context
 conforms to the protocol VPPCoreDataActiveRecordManagedObjectContext. */
+ (NSManagedObjectContext *) moc:(NSManagedObjectContext *)moc;

/** Returns a new autoreleased managed object context, already configured with the
 persistent store coordinator and the object invoking it. This managed object context 
 conforms to the protocol VPPCoreDataActiveRecordManagedObjectContext. */
- (NSManagedObjectContext *) moc;

/** Returns the same managed object context passed as parameter, after configured it with the
 persistent store coordinator and the object invoking it. This managed object context 
 conforms to the protocol VPPCoreDataActiveRecordManagedObjectContext. */
- (NSManagedObjectContext *) moc:(NSManagedObjectContext *)moc;


@end
