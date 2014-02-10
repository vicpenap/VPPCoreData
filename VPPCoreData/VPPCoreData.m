//
//  VPPCoreData.m
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


#import "VPPCoreData.h"
#import "SynthesizeSingleton.h"



@implementation VPPCoreData (Customizing)

#pragma mark -
#pragma mark Application's Documents directory

/*
 Returns the path to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}


#pragma mark -
#pragma mark Core Data stack

- (void) setManagedObjectModel:(NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel_ != nil) {
        [managedObjectModel_ autorelease];
        managedObjectModel_ = nil;
    }
    managedObjectModel_ = [managedObjectModel retain];
}

/*
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    //    NSString *modelPath = [[NSBundle mainBundle] pathForResource:dbFilename ofType:@"momd"];
    //    NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
    //    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    managedObjectModel_ = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel_;
}


- (void) setPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator_ != nil) {
        [persistentStoreCoordinator_ autorelease];
        persistentStoreCoordinator_ = nil;
    }
    persistentStoreCoordinator_ = [persistentStoreCoordinator retain];
}

/*
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = nil;
    if ([NSSQLiteStoreType isEqualToString:self.persistentStoreType]) {
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",self.dbFilename]];
        storeURL = [NSURL fileURLWithPath:storePath];
        
        if (self.initialDBFilename) {
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:storePath]) {
                NSString *initialStorePath = [[NSBundle mainBundle] pathForResource:self.initialDBFilename ofType:@"sqlite"];
                if (initialStorePath) {
                    [fileManager copyItemAtPath:initialStorePath toPath:storePath error:NULL];
                }
            }
        }
    }
    NSError *error = nil;
    
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:self.persistentStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}

- (NSString *) persistentStoreType {
    if (!persistentStoreType_) {
        self.persistentStoreType = NSSQLiteStoreType;
    }
    
    return persistentStoreType_;
}

- (void) setPersistentStoreType:(NSString *)persistentStoreType {
    [persistentStoreType retain];
    if (persistentStoreType_ != nil) {
        [persistentStoreType_ release];
    }
    persistentStoreType_ = persistentStoreType;
}



- (void)mergeChanges:(NSNotification *)notification
{
    [self.mainContext mergeChangesFromContextDidSaveNotification:notification];
}


@end




@implementation VPPCoreData (DifferentManagedObjectContext)

- (NSArray *) objectsWithExistingIDs:(NSArray *)ids managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (!ids) {
        return nil;
    }
    
    NSMutableArray *objects = [NSMutableArray array];
    for (id obj in ids) {
        NSManagedObjectID *oID = nil;
        if ([obj isKindOfClass:[NSManagedObjectID class]]) {
            oID = (NSManagedObjectID *)obj;
        }
        else if ([obj isKindOfClass:[NSManagedObject class]]) {
            oID = [(NSManagedObject *)obj objectID];
        }
        else {
            return nil;
        }
        [objects addObject:[managedObjectContext existingObjectWithID:oID error:NULL]];
    } 
    return objects;
}

- (id) objectWithExistingID:(id)objectID managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    if (!objectID) {
        return nil;
    }
    NSArray *objects = [self objectsWithExistingIDs:[NSArray arrayWithObject:objectID] managedObjectContext:managedObjectContext];
    
    if ([objects count] != 0) {
        return [objects objectAtIndex:0];
    }
    return nil;
}

- (NSManagedObjectContext *) createManagedObjectContext {
    NSManagedObjectContext *m = nil;
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        m = [[NSManagedObjectContext alloc] init];
        [m setPersistentStoreCoordinator:coordinator];
        
        return [m autorelease];
    }
    
    return nil;
}


- (BOOL) saveManagedObjectContext:(NSManagedObjectContext *)managedObjectContext error:(NSError **)error {
    if (managedObjectContext != nil && [managedObjectContext hasChanges]) {
        // Register context with the notification center
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter]; 
        [nc addObserver:self
               selector:@selector(mergeChanges:)
                   name:NSManagedObjectContextDidSaveNotification
                 object:managedObjectContext];
        
        return [managedObjectContext save:error];  
    }
    return YES;
}

- (NSUInteger) countObjectsForEntity:(NSString *)entity
                   filteredBy:(NSPredicate *)predicateOrNil
         managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	/*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity 
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	
    if (predicateOrNil) {
        [fetchRequest setPredicate:predicateOrNil];
    }
    
	
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSError *error = nil;
	NSUInteger result = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
    
	if (error) {
		// Manage error executing fetch
	}
	
	return result;
}

- (NSArray *) allObjectsForEntity:(NSString *)entity
                          orderBy:(NSString *)orderBy
                       filteredBy:(NSPredicate *)predicateOrNil 
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext 
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString_vpp_:orderBy];
    
    return [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:0 offset:0 managedObjectContext:managedObjectContext];
}


- (NSArray *) allObjectsForEntity:(NSString *)entity 
               orderedByAttribute:(NSString *)attributeOrNil 
                        ascending:(BOOL)ascending
                       filteredBy:(NSPredicate *)predicateOrNil 
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    return [self objectsForEntity:entity orderedByAttribute:attributeOrNil ascending:ascending filteredBy:predicateOrNil fetchLimit:0 offset:0 managedObjectContext:managedObjectContext];
}

- (NSArray *) objectsForEntity:(NSString *)entity 
            orderedByAttribute:(NSString *)attributeOrNil 
                     ascending:(BOOL)ascending
                    filteredBy:(NSPredicate *)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset
          managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    NSArray *sortDescriptors = nil;
    if (attributeOrNil) {
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:attributeOrNil ascending:ascending];
        sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        [sortDescriptor release];
    }
    NSArray *r =  [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:managedObjectContext];
    [sortDescriptors release];
    return r;
}

- (NSArray *) allObjectsForEntity:(NSString *)entity
                  sortDescriptors:(NSArray *)sortDescriptors
                       filteredBy:(NSPredicate *)predicateOrNil 
             managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    return [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:0 offset:0 managedObjectContext:managedObjectContext];
}

- (NSArray *) objectsForEntity:(NSString *)entity 
                       orderBy:(NSString *)orderBy
                    filteredBy:(NSPredicate *)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset
          managedObjectContext:(NSManagedObjectContext *)managedObjectContext 
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString_vpp_:orderBy];

    return [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:managedObjectContext];
}

/**
 Returns an array with all the objects for the given entity name sorted by the given attribute
 */
- (NSArray *) objectsForEntity:(NSString *)entity 
               sortDescriptors:(NSArray *)sortDescriptors
                    filteredBy:(NSPredicate *)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset
          managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
	/*
	 Set up the fetched results controller.
	 */
	// Create the fetch request for the entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity 
														 inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	
    // Set the batch size to a suitable number.
    [fetchRequest setFetchLimit:fetchLimit];
    [fetchRequest setFetchOffset:offset];
	
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
	
    if (predicateOrNil) {
        [fetchRequest setPredicate:predicateOrNil];
    }
    
	// Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
	NSError *error = nil;
	NSArray *result = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
    
	if (error) {
		// Manage error executing fetch
	}
    
	return result;
}

- (id) findObjectFromEntity:(NSString *)entity 
              withPredicate:(NSPredicate *)predicate
       managedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
	NSArray * tmp;
	
	if ([tmp = [self objectsForEntity:entity
                   orderedByAttribute:nil 
                            ascending:YES
                           filteredBy:predicate
                           fetchLimit:1
                               offset:0
                 managedObjectContext:managedObjectContext] count] != 0)
    {
		return [tmp objectAtIndex:0];
	}
	return nil;
}


- (id) getNewObjectForEntity:(NSString *)entityName
        managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
    id obj = [NSEntityDescription insertNewObjectForEntityForName:entityName
                                           inManagedObjectContext:managedObjectContext];
	
	NSError *error = nil;  
	
    if (![self saveManagedObjectContext:managedObjectContext error:&error]) {

		//This is a serious error saying the record  
		//could not be saved. Advise the user to  
		//try again or restart the application. 
        
    }
    
    return obj;
}


- (void) deleteObject:(id)object 
 managedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    
	[managedObjectContext deleteObject:object];
    
	NSError *error;  
    
    if (![self saveManagedObjectContext:managedObjectContext error:&error]) {
		
		//This is a serious error saying the record  
		//could not be saved. Advise the user to  
		//try again or restart the application.   
		
	}
}

- (void) deleteAllObjectsFromEntity:(NSString *)entity 
               managedObjectContext:(NSManagedObjectContext *)managedObjectContext  {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entity inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDesc];
	
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
	
	
    for (NSManagedObject *managedObject in items) {
        [managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entity);
    }
    if (![self saveManagedObjectContext:managedObjectContext error:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entity,error);
    }
}


@end



@implementation VPPCoreData
@synthesize dbFilename;
@synthesize initialDBFilename;


SYNTHESIZE_SINGLETON_FOR_CLASS(VPPCoreData);

/*
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)mainContext {
    if (!mainContext_) {
        mainContext_ = [[self createManagedObjectContext] retain];
    }
    return mainContext_;
}

+ (VPPCoreData *) sharedInstance {
    BOOL mustInitialize = !sharedVPPCoreData;
    
    VPPCoreData *w = [VPPCoreData sharedVPPCoreData];
    
    if (mustInitialize) {
        w.dbFilename = kVPPCoreDataDBFilename;
    }
    return w;
}


- (void) dealloc {
    if (mainContext_ != nil) {
        [mainContext_ release];
        mainContext_ = nil;
    }
    if (persistentStoreCoordinator_ != nil) {
        [persistentStoreCoordinator_ release];
        persistentStoreCoordinator_ = nil;
    }
    if (managedObjectModel_ != nil) {
        [managedObjectModel_ release];
        managedObjectModel_ = nil;
    }
    
    self.dbFilename = nil;
    sharedVPPCoreData = nil;
    
    [super dealloc];
}


// the operations below are launched with main context.

- (NSArray *) objectsWithExistingIDs:(NSArray *)ids {
    return [self objectsWithExistingIDs:ids managedObjectContext:self.mainContext];
}
- (id) objectWithExistingID:(id)objectID {
    return [self objectWithExistingID:objectID managedObjectContext:self.mainContext];
}


- (id) getNewObjectForEntity:(NSString *)entityName {
    
    return [self getNewObjectForEntity:entityName managedObjectContext:self.mainContext];
}

- (id) findObjectFromEntity:(NSString *)entity withPredicate:(NSPredicate *)predicate {
    
    return [self findObjectFromEntity:entity withPredicate:predicate managedObjectContext:self.mainContext];
}

- (NSArray *) allObjectsForEntity:(NSString *)entity 
               orderedByAttribute:(NSString *)attributeOrNil 
                        ascending:(BOOL)ascending
                       filteredBy:(NSPredicate *)predicateOrNil {
    
    return [self allObjectsForEntity:entity orderedByAttribute:attributeOrNil ascending:ascending filteredBy:predicateOrNil managedObjectContext:self.mainContext];
}

- (NSUInteger) countObjectsForEntity:(NSString *)entity 
                   filteredBy:(NSPredicate*)predicateOrNil {
    
    return [self countObjectsForEntity:entity filteredBy:predicateOrNil managedObjectContext:self.mainContext];
}

- (NSArray *) objectsForEntity:(NSString *)entity 
            orderedByAttribute:(NSString *)attributeOrNil 
                     ascending:(BOOL)ascending
                    filteredBy:(NSPredicate*)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset {
    
    return [self objectsForEntity:entity orderedByAttribute:attributeOrNil ascending:ascending filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:self.mainContext];
}


- (NSArray *) objectsForEntity:(NSString *)entity 
               sortDescriptors:(NSArray *)sortDescriptors
                    filteredBy:(NSPredicate*)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset {
    
    return [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:self.mainContext];
}

- (NSArray *) objectsForEntity:(NSString *)entity 
                       orderBy:(NSString *)orderBy
                    filteredBy:(NSPredicate*)predicateOrNil 
                    fetchLimit:(int)fetchLimit 
                        offset:(int)offset
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString_vpp_:orderBy];
    
    return [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:self.mainContext];
}


- (NSArray *) allObjectsForEntity:(NSString *)entity 
                  sortDescriptors:(NSArray *)sortDescriptors
                       filteredBy:(NSPredicate *)predicateOrNil {
    
    return [self allObjectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil managedObjectContext:self.mainContext];
    
}

- (NSArray *) allObjectsForEntity:(NSString *)entity 
                          orderBy:(NSString *)orderBy
                       filteredBy:(NSPredicate *)predicateOrNil
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString_vpp_:orderBy];
    
    return [self allObjectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil managedObjectContext:self.mainContext];
    
}


- (void) deleteAllObjectsFromEntity:(NSString *)entity {
    
    [self deleteAllObjectsFromEntity:entity managedObjectContext:self.mainContext];
}
- (void) deleteObject:(id)object {
    
    [self deleteObject:object managedObjectContext:self.mainContext];
}

- (void) saveAllChanges {
    [self.mainContext save:NULL];
}


@end 





/* the operations below are launched in a new queue, and completion block is 
 launched in main thread, with the objects already refetched with main context */
@implementation VPPCoreData (Background)


- (void) getNewObjectForEntity:(NSString *)entityName
                    completion:(void (^) (id object))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        id obj = [self getNewObjectForEntity:entityName managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([self objectWithExistingID:obj]);
        }];
    }];
    [q release];
}

- (void) findObjectFromEntity:(NSString *)entity
                withPredicate:(NSPredicate *)predicate
                   completion:(void (^) (id object))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        id obj = [self findObjectFromEntity:entity withPredicate:predicate managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([self objectWithExistingID:obj]);
        }];
    }];
    [q release];
}

- (void) allObjectsForEntity:(NSString *)entity 
          orderedByAttribute:(NSString *)attributeOrNil 
                   ascending:(BOOL)ascending
                  filteredBy:(NSPredicate *)predicateOrNil 
                  completion:(void (^) (NSArray *objects))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSArray *objIDs = [self allObjectsForEntity:entity orderedByAttribute:attributeOrNil ascending:ascending filteredBy:predicateOrNil managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([self objectsWithExistingIDs:objIDs]);
        }];
    }];
    [q release];
}

- (void) countObjectsForEntity:(NSString *)entity 
                    filteredBy:(NSPredicate*)predicateOrNil 
                    completion:(void (^) (NSUInteger count))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSUInteger count = [self countObjectsForEntity:entity filteredBy:predicateOrNil managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block(count);
        }];
    }];
    [q release];
}

- (void) objectsForEntity:(NSString *)entity 
       orderedByAttribute:(NSString *)attributeOrNil 
                ascending:(BOOL)ascending
               filteredBy:(NSPredicate*)predicateOrNil 
               fetchLimit:(int)fetchLimit 
                   offset:(int)offset 
               completion:(void (^) (NSArray *objects))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSArray *objIDs = [self objectsForEntity:entity orderedByAttribute:attributeOrNil ascending:ascending filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([self objectsWithExistingIDs:objIDs]);
        }];
    }];
    [q release];
}


- (void) objectsForEntity:(NSString *)entity 
          sortDescriptors:(NSArray *)sortDescriptors
               filteredBy:(NSPredicate*)predicateOrNil 
               fetchLimit:(int)fetchLimit 
                   offset:(int)offset 
               completion:(void (^) (NSArray *objects))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSArray *objs = [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([self objectsWithExistingIDs:objs]);
        }];
    }];
    [q release];
}

- (void) objectsForEntity:(NSString *)entity 
                  orderBy:(NSString *)orderBy
               filteredBy:(NSPredicate*)predicateOrNil 
               fetchLimit:(int)fetchLimit 
                   offset:(int)offset 
               completion:(void (^) (NSArray *objects))block
{
 
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString_vpp_:orderBy];
    
    [self objectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil fetchLimit:fetchLimit offset:offset completion:block];
}



- (void) allObjectsForEntity:(NSString *)entity 
             sortDescriptors:(NSArray *)sortDescriptors
                  filteredBy:(NSPredicate *)predicateOrNil 
                  completion:(void (^) (NSArray *objects))block {
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q addOperationWithBlock:^{
        NSArray *objs = [self allObjectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil managedObjectContext:[self createManagedObjectContext]];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            block([self objectsWithExistingIDs:objs]);
        }];
    }];
    [q release];
}

- (void) allObjectsForEntity:(NSString *)entity 
                     orderBy:(NSString *)orderBy
                  filteredBy:(NSPredicate *)predicateOrNil 
                  completion:(void (^) (NSArray *objects))block 
{

    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString_vpp_:orderBy];

    [self allObjectsForEntity:entity sortDescriptors:sortDescriptors filteredBy:predicateOrNil completion:block];
}



@end