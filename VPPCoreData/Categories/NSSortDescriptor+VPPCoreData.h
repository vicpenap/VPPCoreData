//
//  NSSortDescriptor+VPPCoreData.h
//  movete
//
//  Created by Víctor on 20/03/12.
//  Copyright (c) 2012 Filloa Dev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSSortDescriptor (VPPCoreData)

+ (NSArray *) sortDescriptorsFromSQLString:(NSString *)string;

@end
