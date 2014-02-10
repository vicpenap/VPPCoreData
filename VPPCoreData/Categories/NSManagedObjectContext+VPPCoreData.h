//
//  NSManagedObjectContext+VPPCoreData.h
//  VPPCoreDataExample
//
//  Created by Víctor on 11/04/12.


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

/** This `NSManagedObjectContext` category contains a set of methods to 
 simplify some VPPCoreData tasks. */
@interface NSManagedObjectContext (VPPCoreData)

/** Saves all pending changes through `VPPCoreData`, notifying the main context
 with those changes. */
- (void) saveChanges_vpp_:(NSError **)error;

/** Obtains the given object or array of objects (or objectIDs). 
 
 This method is useful when the given objects or array of objects was
 obtained from a different managed object context. */
- (id) fetch_vpp_:(id)object;

/** Returns a new autoreleased managed object context already configured with the 
 persistent store coordinator. */
+ (NSManagedObjectContext *) create_vpp_;

/** Returns the main managed object context. */
+ (NSManagedObjectContext *) main_vpp_;

@end
