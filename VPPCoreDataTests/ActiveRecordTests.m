//
//  ActiveRecordTests.m
//  VPPCoreDataExample
//
//  Created by Víctor on 12/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActiveRecordTests.h"
#import "VPPCoreDataActiveRecord.h"
#import "Quote.h"

@implementation ActiveRecordTests
@synthesize moc;

- (void)setUp
{
    [super setUp];
    
    NSManagedObjectModel *mom = [NSManagedObjectModel mergedModelFromBundles:[NSArray arrayWithObject:[NSBundle bundleForClass:[self class]]]];
    [[VPPCoreData sharedInstance] setManagedObjectModel:mom];
    [[VPPCoreData sharedInstance] setPersistentStoreType:NSInMemoryStoreType];
    
    self.moc = [VPPCoreData sharedInstance].mainContext;
}

- (void)tearDown
{

    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:@"Quote" managedObjectContext:moc];
    [[VPPCoreData sharedInstance] deleteAllObjectsFromEntity:@"Author" managedObjectContext:moc];
    
    [super tearDown];
}

- (void) testFirst
{
    Quote *qFirst = [Quote create];
    qFirst.quote = @"a";
    
    Quote *q = [Quote create];
    q.quote = @"b";
    
    q = [Quote create];
    q.quote = @"c";

    Quote *first = [Quote firstBy:nil orderBy:@"quote"];
    
    STAssertEqualObjects(first, qFirst, @"Objects do not match");
    
    
    qFirst = [Quote create];
    qFirst.quote = @"Text a";
    q = [Quote create];
    q.quote = @"Text b";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"Text"];
    
    first = [Quote firstBy:predicate orderBy:@"quote"];
    
    STAssertEqualObjects(first, qFirst, @"Objects do not match");
}
- (NSArray *) createPrefix:(NSString *)prefix amount:(int)amount
{
    NSMutableArray *quotes = [NSMutableArray array];
    for (int i = 1; i <= amount; i++) 
    {
        Quote *q = [Quote create];
        q.quote = [NSString stringWithFormat:@"%@ %d",prefix,i];
        [quotes addObject:q];
    }
    
    return quotes;
}

- (void) testAll 
{
    NSMutableArray *quotes = [NSMutableArray array];
    [quotes addObjectsFromArray:[self createPrefix:@"Quote" amount:10]];
    [quotes addObjectsFromArray:[self createPrefix:@"Text" amount:20]];
    
    NSArray *retrieved = [Quote all];
    
    STAssertTrue([quotes count] == [retrieved count], @"Counts do not match");
    
    retrieved = [Quote allOrderBy:@"quote"];
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"quote"];
    [quotes sortUsingDescriptors:sortDescriptors];
    
    STAssertEqualObjects(retrieved, quotes, @"Objects do not match");
}

- (void) testFind
{
    NSArray *sortDescriptors = [NSSortDescriptor sortDescriptorsFromSQLString:@"quote"];
    NSMutableArray *quotes = [NSMutableArray array];
    [quotes addObjectsFromArray:[self createPrefix:@"Quote" amount:10]];
    [quotes sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *texts = [NSMutableArray array];
    [texts addObjectsFromArray:[self createPrefix:@"Text" amount:20]];
    [texts sortUsingDescriptors:sortDescriptors];

    // quotes that contain quote
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"quote"];
    NSArray *retrievedQuotes = [Quote findBy:predicate orderBy:@"quote"];
    STAssertEqualObjects(quotes, retrievedQuotes, @"objects do not match");
    
    // quotes that contain text
    predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"text"];
    NSArray *retrievedTexts = [Quote findBy:predicate orderBy:@"quote"];
    STAssertEqualObjects(texts, retrievedTexts, @"objects do not match");

    // empty result set
    predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"no results"];
    NSArray *retrieved = [Quote findBy:predicate orderBy:@"quote"];
    STAssertEqualObjects([NSArray array], retrieved, @"objects do not match");

}

- (void) testCount
{
    [Quote create];
    [Quote create];
    [Quote create];
    
    STAssertTrue(3 == [Quote count], @"Counts do not match");
}

- (void) testCountBy
{
    [self createPrefix:@"Quote" amount:10];
    [self createPrefix:@"Text" amount:3];
    
    int count = 3; 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"quote contains[cd] %@",@"text"];
    int retrievedCount = [Quote countBy:predicate];
    
    STAssertTrue(count == retrievedCount, @"Counts do not match");
}

- (void) remove 
{
    Quote *q = [Quote create];
    q.quote = @"Test";
    
    [self createPrefix:@"Text" amount:3];
    
    int count = 4;
    int retrievedCount = [Quote count];
    STAssertTrue(count == retrievedCount, @"Counts do not match");
    
    [q remove];
    count = 3;
    retrievedCount = [Quote count];
    STAssertTrue(count == retrievedCount, @"Counts do not match");
}


@end
