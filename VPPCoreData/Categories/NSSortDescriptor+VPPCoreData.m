//
//  NSSortDescriptor+VPPCoreData.m
//  movete
//
//  Created by Víctor on 20/03/12.

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




#import "NSSortDescriptor+VPPCoreData.h"

@interface NSString (VPPCoreData)

- (NSString *) trim;

@end

@implementation NSString (VPPCoreData)

- (NSString *) trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end




typedef enum {
    VPPCoreDataSortingInvalid = -1,    
    VPPCoreDataSortingAscending = 0,
    VPPCoreDataSortingDescending = 1
} VPPCoreDataSorting;



@implementation NSSortDescriptor (VPPCoreData)

+ (VPPCoreDataSorting) ascendingFromString:(NSString *)ascendingRaw 
{
    NSString *ascending = nil;
    if (ascendingRaw) {
        ascending = [ascendingRaw trim];
    }
        
    if (ascending && ![@"" isEqual:ascending]) {
        if ([@"desc" isEqualToString:ascending]) {
            return VPPCoreDataSortingDescending;
        }
        if ([@"asc" isEqualToString:ascending]) {
            return VPPCoreDataSortingAscending;
        }
        return VPPCoreDataSortingInvalid;
    }
    
    
    return VPPCoreDataSortingAscending;
}

+ (BOOL) boolFromSorting:(VPPCoreDataSorting)sorting 
{
    switch (sorting) {
        case VPPCoreDataSortingDescending:
            return NO;
        default:
            return YES;
    }
}

+ (NSSortDescriptor *) sortDescriptorByKey:(NSString *)keyRaw ascending:(NSString *)ascendingString 
{
    NSString *key = [keyRaw trim];

    VPPCoreDataSorting sorting = [self ascendingFromString:ascendingString];
    if (sorting == VPPCoreDataSortingInvalid) {
        return nil;
    }
    
    BOOL ascendingBool = [self boolFromSorting:sorting];
    
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:key ascending:ascendingBool];
    
    return descriptor;
}

+ (NSSortDescriptor *) parseComponent:(NSString *)component
{
    NSString *trimmedComponent = [component trim];
    
    NSArray *parts = [trimmedComponent componentsSeparatedByString:@" "];
    
    NSString *key;
    NSString *ascending = nil;
    switch ([parts count]) {
        case 2:
            ascending = [parts objectAtIndex:1];            
        case 1:
            key = [parts objectAtIndex:0];
            return [self sortDescriptorByKey:key ascending:ascending];

        default:
            return nil;
    }
}

+ (NSArray *) parseComponents:(NSArray *)components 
{
    NSMutableArray *descriptors = [NSMutableArray array];
    for (NSString *component in components) {
        NSSortDescriptor *descriptor = [self parseComponent:component];
        if (descriptor) {
            [descriptors addObject:descriptor];
        }
    }
    
    return [descriptors count] > 0 ? descriptors : nil;
}

+ (NSArray *) sortDescriptorsFromSQLString:(NSString *)string
{
    NSArray *components = [string componentsSeparatedByString:@","];
    
    NSArray *descriptors = [self parseComponents:components];
    
    return descriptors;
}

@end
