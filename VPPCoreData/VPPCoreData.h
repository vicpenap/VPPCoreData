//
//  VPPCoreData.h
//  VPPLibraries
//
//  Created by Víctor on 21/12/11.

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


#define kVPPCoreDataDBFilename @"model"

/** VPPCoreData library simplifies the task of managing data with Core Data 
 framework. This library offers an automatic setup of Core Data and a set of
 methods to set and retrieve data, both in foreground and background.
 
 
 
 ### Storing data 
 
 When using this library with default setup, a new `model.sqlite` file will be
 placed in `Documents` directory on the first launch, and since then all changes
 will be persisted on that file. If you want to change that filename, use the
 dbFilename property, specifying the new name. Remember to exclude the
 `.sqlite` extension.
 
 Persisting store type can be changed through persistentStoreCoordinator property,
 using your own persistent store coordinator. This property should be changed
 always **before** using any of the provided query methods.
 
 By default, the model will be obtained by merging all models found in main 
 bundle. This behavior can be changed through managedObjectModel property, if you
 specify your own managed object model. This property should be changed always
 **before** using any of the provided query methods. 
 
 
 ### Distributing an application with a default set of data
 
 You can include an sqlite file with a default set of data. In this case, if 
 there is no sqlite file in documents directory when launching the app, the 
 included file will be copied there. Then, the copied file will be used and 
 modified when needed. 
 
 If you want to include a default file, set the initialDBFilename to its 
 filename, excluding the `.sqlite` extension.
 
 
 
 ### Accessing data from different threads, operations...
 
 Several sets of methods are provided, grouped by the thread being used.
 
 - *Main thread operations*: these methods should be always called from main 
 thread. They have attached a `NSManagedObjectContext` found in mainContext
 property. All returned entities are attached to that managed object context.
 
 - *Background operations*: these methods should be always called from main 
 thread. In these methods you should provide a completion block. The difference
 with the previous set is that the request operations are performed in background,
 using a NSOperationQueue. Once the operation is finished, the completion block
 is automatically executed in main thread. 
    - If the invoked method is a fetch operation, all returned entities are automatically 
 re-fetched in foreground using their objectIDs, and these refetched entities
 are passed through the completion block. Take into account that re-fetching the
 objects in main thread will block the UI if the amount of data is too big.
 
 - *Different managedObjectContext operations*: these methods can be called in 
 any thread. They will be performed in the that thread and the returned entities
 are attached to the given managed object context.
 
 
 
 ### Modifying data in different threads 
 
 If you are modifying data in a thread different than the main one, when saving
 changes **only the managed object context associated with the main thread
 will be notified** of those changes. Is your responsibility to notify the 
 changes to any other managed object context you could be using.
 
 
 */

@interface VPPCoreData : NSObject {
@private
    NSManagedObjectContext *mainContext_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
    NSManagedObjectModel *managedObjectModel_;
}

/** @name Accessing to the singleton instance */

/** Returns the library's singleton instance. */
+ (VPPCoreData *) sharedInstance;


/** @name Configuring the sqlite filenames */

/** Indicates the sqlite filename used to store information.
 
 If you want to chage this property, you should do it always **before** using 
 any of the provided query methods. Remember to exclude the `.sqlite` extension. 
 */
@property (nonatomic, retain) NSString *dbFilename; // overrides default name

// if set, when trying to access db file, if it doesn't exist, it's then copied
// from its value.

/** Indicates the sqlite filename to copy when no sqlite file exists in the
 documents directory.
 
 If you want to chage this property, you should do it always **before** using 
 any of the provided query methods. Remember to exclude the `.sqlite` extension.
 */
@property (nonatomic, retain) NSString *initialDBFilename;



/** @name Main thread Methods */

/** Points to the managed object context attached to the main thread. */
@property (nonatomic, readonly) NSManagedObjectContext *mainContext;


/** Creates and returns a new object for the given entity. */
- (id) getNewObjectForEntity:(NSString *)entityName;

/** Returns the first object for the given entity that matches the given 
 predicate. */
- (id) findObjectFromEntity:(NSString *)entity 
              withPredicate:(NSPredicate *)predicate;

/** Counts all objects for the given entity that match the given predicate. */
- (int) countObjectsForEntity:(NSString *)entity 
                   filteredBy:(NSPredicate*)predicateOrNil;

/** Returns a page of objects for the given entity that match the given predicate. 
 
 @param entity The objects' entity.
 @param attributeOrNil the attribute used to sort the results. Can be `nil`.
 @param ascending Indicates whether the objects should be sorted ascending or 
 descending (when ascending is NO).
 @param predicateOrNil the predicate to filter the results.
 @param fetchLimit the max amount of objects to retrieve.
 @param offset the page's offset.
 */
- (NSArray *) objectsForEntity:(NSString *)entity 
            orderedByAttribute:(NSString *)attributeOrNil 
                     ascending:(BOOL)ascending
                    filteredBy:(NSPredicate*)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset;

/** Returns all objects for the given entity that match the given predicate, 
 ordered by the given attribute. */
- (NSArray *) allObjectsForEntity:(NSString *)entity 
               orderedByAttribute:(NSString *)attributeOrNil 
                        ascending:(BOOL)ascending
                       filteredBy:(NSPredicate *)predicateOrNil;

/** Returns a page of objects for the given entity that match the given predicate. 
 
 @param entity The objects' entity.
 @param sortDescriptors An array of `NSSortDescriptor`.
 @param predicateOrNil the predicate to filter the results.
 @param fetchLimit the max amount of objects to retrieve.
 @param offset the page's offset.
 */
- (NSArray *) objectsForEntity:(NSString *)entity 
               sortDescriptors:(NSArray *)sortDescriptors
                    filteredBy:(NSPredicate*)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset;

/** Returns all objects for the given entity that match the given predicate. 
 
 @param entity The objects' entity.
 @param sortDescriptors An array of `NSSortDescriptor`.
 @param predicateOrNil the predicate to filter the results.
 */
- (NSArray *) allObjectsForEntity:(NSString *)entity 
                  sortDescriptors:(NSArray *)sortDescriptors
                       filteredBy:(NSPredicate *)predicateOrNil;

/** Removes all objects for the given entity. */
- (void) deleteAllObjectsFromEntity:(NSString *)entity;

/** Removes the given object. */
- (void) deleteObject:(id)object;

/** Saves all pending changes for the main managed object context.
 
 This operation would save all pending changes made to the objects that have
 been fetched through the main managed object context. */
- (void) saveAllChanges;

/** Refetches the given objects with the main managed object context.
 
 The specified `ids` array can hold objects from both `NSManagedObjectID` or 
 `NSManagedObject`class. */
- (NSArray *) objectsWithExistingIDs:(NSArray *)ids;

/** Refetches the given object with the main managed object context.
 
 The specified `objectID` parameter can hold an object from both
 `NSManagedObjectID` or `NSManagedObject`class. */
- (id) objectWithExistingID:(id)objectID;

@end




@interface VPPCoreData (Background)

/** @name Background operations */

/** Creates in background a new object in background for the given entity and 
 passes it through the completion `block` parameter. 
 
 The completion block is launched in main thread. The returned entity is
 re-fetched with main managed object context, so it is safe to use it in main
 thread. */
- (void) getNewObjectForEntity:(NSString *)entityName
                    completion:(void (^) (id object))block;

/** Locates in background the first object for the given entity that matches 
 the given predicate and passes it through the completion `block` parameter. 
 
 The completion block is launched in main thread. The returned entities are
 re-fetched with main managed object context, so it is safe to use them in main
 thread. */
- (void) findObjectFromEntity:(NSString *)entity
                withPredicate:(NSPredicate *)predicate
                   completion:(void (^) (id object))block;

/** Counts in background all objects for the given entity that match the given
 predicate, and passes the result through the completion block. 
 
 The completion block is launched in main thread. */
- (void) countObjectsForEntity:(NSString *)entity 
                    filteredBy:(NSPredicate*)predicateOrNil 
                    completion:(void (^) (int count))block;

/** Gets in background a page of objects for the given entity that match the
 given predicate and passes them through the completion block. 
 
 The completion block is launched in main thread. The returned entities are
 re-fetched with main managed object context, so it is safe to use them in main
 thread.
 
 @param entity The objects' entity.
 @param attributeOrNil the attribute used to sort the results. Can be `nil`.
 @param ascending Indicates whether the objects should be sorted ascending or 
 descending (when ascending is NO).
 @param predicateOrNil the predicate to filter the results.
 @param fetchLimit the max amount of objects to retrieve.
 @param offset the page's offset.
 @param block The completion block used to pass the retrieved objects.
 */
- (void) objectsForEntity:(NSString *)entity 
       orderedByAttribute:(NSString *)attributeOrNil 
                ascending:(BOOL)ascending
               filteredBy:(NSPredicate*)predicateOrNil 
               fetchLimit:(int)fetchLimit 
                   offset:(int)offset 
               completion:(void (^) (NSArray *objects))block;

/** Fetches in background all objects for the given entity that match the given 
 predicate, ordered by the given attribute and passes them through the completion 
 block.
 
 The completion block is launched in main thread. The returned entities are
 re-fetched with main managed object context, so it is safe to use them in main
 thread.
 */
- (void) allObjectsForEntity:(NSString *)entity 
          orderedByAttribute:(NSString *)attributeOrNil 
                   ascending:(BOOL)ascending
                  filteredBy:(NSPredicate *)predicateOrNil 
                  completion:(void (^) (NSArray *objects))block;


/** Fetches in background a page of objects for the given entity that match the 
 given predicate and passes them through the completion block. 
 
 The completion block is launched in main thread. The returned entities are
 re-fetched with main managed object context, so it is safe to use them in main
 thread.
 
 @param entity The objects' entity.
 @param sortDescriptors An array of `NSSortDescriptor`.
 @param predicateOrNil the predicate to filter the results.
 @param fetchLimit the max amount of objects to retrieve.
 @param offset the page's offset.
 */
- (void) objectsForEntity:(NSString *)entity 
          sortDescriptors:(NSArray *)sortDescriptors
               filteredBy:(NSPredicate*)predicateOrNil 
               fetchLimit:(int)fetchLimit 
                   offset:(int)offset 
               completion:(void (^) (NSArray *objects))block;


/** Gets in background all objects for the given entity that match the given 
 predicate and passes them through the completion block. 
 
 The completion block is launched in main thread. The returned entities are
 re-fetched with main managed object context, so it is safe to use them in main
 thread.
 
 @param entity The objects' entity.
 @param sortDescriptors An array of `NSSortDescriptor`.
 @param predicateOrNil the predicate to filter the results.
 */
- (void) allObjectsForEntity:(NSString *)entity 
             sortDescriptors:(NSArray *)sortDescriptors
                  filteredBy:(NSPredicate *)predicateOrNil 
                  completion:(void (^) (NSArray *objects))block;


@end



@interface VPPCoreData (DifferentManagedObjectContext)

/* This methods return the objects for the specified context. Do not forget to 
 fetch the actual objects with the main context, if you need to use them in 
 main thread. Use object(s)WithExistingID(s) methods. */


/** Creates and initializes a new managed object context, setting its persistent
 store coordinator. 
 
 The returned instance is autoreleased. */
- (NSManagedObjectContext *) createManagedObjectContext;

/** Counts all objects for the given entity that match the given predicate using 
 the given managed object context. */
- (int) countObjectsForEntity:(NSString *)entity 
                   filteredBy:(NSPredicate *)predicateOrNil
         managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Returns all objects for the given entity that match the given predicate, 
 ordered by the given attribute using the given managed object context. */
- (NSArray *) allObjectsForEntity:(NSString *)entity 
               orderedByAttribute:(NSString *)attributeOrNil 
                        ascending:(BOOL)ascending
                       filteredBy:(NSPredicate *)predicateOrNil 
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Returns a page of objects for the given entity that match the given predicate
 using the given managed object context. 
 
 @param entity The objects' entity.
 @param attributeOrNil the attribute used to sort the results. Can be `nil`.
 @param ascending Indicates whether the objects should be sorted ascending or 
 descending (when ascending is NO).
 @param predicateOrNil the predicate to filter the results.
 @param fetchLimit the max amount of objects to retrieve.
 @param offset the page's offset.
 @param managedObjectContext the managed object context to use.
 */
- (NSArray *) objectsForEntity:(NSString *)entity 
            orderedByAttribute:(NSString *)attributeOrNil 
                     ascending:(BOOL)ascending
                    filteredBy:(NSPredicate *)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset
          managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Returns all objects for the given entity that match the given predicate, 
 ordered by the given attribute using the given managed object context. */
- (NSArray *) allObjectsForEntity:(NSString *)entity
                  sortDescriptors:(NSArray *)sortDescriptors
                       filteredBy:(NSPredicate *)predicateOrNil 
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext;


/** Returns a page of objects for the given entity that match the given predicate
  using the given managed object context. 
 
 @param entity The objects' entity.
 @param sortDescriptors An array of `NSSortDescriptor`.
 @param predicateOrNil the predicate to filter the results.
 @param fetchLimit the max amount of objects to retrieve.
 @param offset the page's offset.
 */
- (NSArray *) objectsForEntity:(NSString *)entity 
               sortDescriptors:(NSArray *)sortDescriptors
                    filteredBy:(NSPredicate *)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset
          managedObjectContext:(NSManagedObjectContext *)managedObjectContext;


/** Returns the first object for the given entity that matches the given 
 predicate using the given managed object context. */
- (id) findObjectFromEntity:(NSString *)entity 
              withPredicate:(NSPredicate *)predicate
       managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Creates and returns a new object for the given entity using the given 
 managed object context. */
- (id) getNewObjectForEntity:(NSString *)entityName
        managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Removes the given object using the given managed object context. */
- (void) deleteObject:(id)object 
 managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Removes all objects for the given entity using the given managed object context. */
- (void) deleteAllObjectsFromEntity:(NSString *)entity 
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Saves all pending changes for the given managed object context.
 
 This operation would save all pending changes made to the objects that have
 been fetched through the given managed object context. */
- (BOOL) saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext 
                            error:(NSError **)error;


/** Refetches the given objects with the given managed object context.
 
 The specified `ids` array can hold objects from both `NSManagedObjectID` or 
 `NSManagedObject`class. */
- (NSArray *) objectsWithExistingIDs:(NSArray *)ids managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Refetches the given object with the given managed object context.
 
 The specified `objectID` parameter can hold an object from both
 `NSManagedObjectID` or `NSManagedObject`class. */
- (id) objectWithExistingID:(id)objectID managedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end



@interface VPPCoreData (Customizing)

/** Holds a reference to the managed object model for the application.

 By default, the model will be obtained by merging all models found in main 
 bundle. If you want to modify it with your own managed object model,
 you should do it always **before** using any of the provided query methods. 
 */
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;

/** Holds a reference to the used persistent store coordinator.
 
 If you want to change it with your own persistent store coordinator, for example 
 to specify a different persistent store type, you should changed it always
 **before** using any of the provided query methods. 
 */
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end


