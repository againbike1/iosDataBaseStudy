//
//  Task.m
//  Tasks
//
//  Created by Patrick Alessi on 11/12/12.
//  Copyright (c) 2012 Patrick Alessi. All rights reserved.
//

#import "Task.h"
#import "Location.h"


@implementation Task

@dynamic dueDate;
@dynamic isOverdue;
@dynamic priority;
@dynamic text;
@dynamic location;

@dynamic highPriTasks;
@dynamic primitiveDueDate;

#pragma mark 重载Overdue这个属性的方法。
- (NSNumber*) isOverdue
{
    BOOL isTaskOverdue = NO;
    
    NSDate* today = [NSDate date];
    
    if (self.dueDate != nil) {
        if ([self.dueDate compare:today] == NSOrderedAscending)
            isTaskOverdue=YES;
    }
    
    return [NSNumber numberWithBool:isTaskOverdue];
}


#pragma mark 对一些对象初始化一些默认值。
- (void)awakeFromInsert
{
    // Core Data  calls this function the first time the receiver
    // is inserted into a context.
    [super awakeFromInsert];
    
    // Set the due date to 3 days from now (in seconds)
    NSDate* defualtDate = [[NSDate alloc]
                           initWithTimeIntervalSinceNow:60*60*24*3];
    
    // Use custom primitive accessor to set dueDate field
    self.primitiveDueDate = defualtDate ;

}
#pragma mark 验证DueDate这个属性
-(BOOL)validateDueDate:(id *)ioValue error:(NSError **)outError{
    
    // Due dates in the past are not valid.
    // enforce that a due date has to be >= today's date
    if ([*ioValue compare:[NSDate date]] == NSOrderedAscending) {
        
        if (outError != NULL) {
            NSString *errorStr = @"Due date must be today or later";
            NSDictionary *userInfoDictionary =
            [NSDictionary dictionaryWithObject:errorStr
                                        forKey:@"ErrorString"];
            NSError *error =
            [[NSError alloc] initWithDomain:TASKS_ERROR_DOMAIN
                                        code:DUEDATE_VALIDATION_ERROR_CODE
                                    userInfo:userInfoDictionary];
            *outError = error;
        }
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)validateAllData:(NSError **)outError
{
    NSDate* compareDate =
    [[NSDate alloc] initWithTimeIntervalSinceNow:60*60*24*3];
    // Due dates for hi-pri tasks must be today, tomorrow, or the next day.
    if ([self.dueDate compare:compareDate] == NSOrderedDescending &&
        [self.priority intValue]==3) {
        
        if (outError != NULL) {
            NSString *errorStr =
                @"Hi-pri tasks must have a due date within two days of today";
            
            NSDictionary *userInfoDictionary =
            [NSDictionary dictionaryWithObject:errorStr
                                        forKey:@"ErrorString"];
            NSError *error =
            [[NSError alloc] initWithDomain:TASKS_ERROR_DOMAIN
                                        code:PRIORITY_DUEDATE_VALIDATION_ERROR_CODE
                                    userInfo:userInfoDictionary];
            *outError = error;
        }
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark 当插入对象的时候，回调用这个方法来验证
- (BOOL)validateForInsert:(NSError **)outError
{
    // Call the superclass validateForInsert first
    if ([super validateForInsert:outError]==NO)
    {
        return NO;
    }
    
    // Call out validation function
    if ([self validateAllData:outError] == NO)
    {
        return NO;
    }
    else {
        return YES;
    }
}

#pragma mark 当更新对象时，会验证更新
- (BOOL)validateForUpdate:(NSError **)outError
{
    // Call the superclass validateForUpdate first
    if ([super validateForUpdate:outError]==NO)
    {
        return NO;
    }
    
    // Call out validation function
    if ([self validateAllData:outError] == NO)
    {
        return NO;
    }
    else {
        return YES;
    }
}



@end
