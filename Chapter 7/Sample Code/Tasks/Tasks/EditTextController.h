//
//  EditTextController.h
//  Tasks
//
//  Created by Patrick Alessi on 11/13/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTextController : UITableViewController


@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSManagedObject* managedObject;
@property (nonatomic, retain) NSString* keyString;
@property (weak, nonatomic) IBOutlet UITextField *taskText;

@end
