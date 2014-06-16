//
//  UIdataPickerWithDone.m
//  EventApp_Alpha
//
//  Created by Rui Zheng on 2014-06-15.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "UIdataPickerWithDone.h"
#define MyDateTimePickerToolbarHeight 44
@interface UIdataPickerWithDone()

@property (nonatomic, assign) CGRect originalFrame;
@property (nonatomic, assign, readwrite) UIDatePicker *picker;
@property (nonatomic, assign) id doneTarget;
@property (nonatomic, assign) SEL doneSelector;

@end

@implementation UIdataPickerWithDone

-(id)init{
    return [self initWithFrame:CGRectMake(0, 0, 320, 216)];
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame: frame])) {
        self.backgroundColor = [UIColor clearColor];
        
        UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame: CGRectMake(0, MyDateTimePickerToolbarHeight, frame.size.width, frame.size.height - MyDateTimePickerToolbarHeight)];
        [self addSubview: picker];
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame: CGRectMake(0, 0, frame.size.width, MyDateTimePickerToolbarHeight)];
        toolbar.barStyle = UIBarStyleDefault;
        toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleBordered target: self action: @selector(donePressed)];
        UIBarButtonItem* flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolbar.items = [NSArray arrayWithObjects:flexibleSpace, doneButton, nil];
        
        [self addSubview: toolbar];
        
        self.picker = picker;
        picker.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        
        self.autoresizesSubviews = YES;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (void) setDatePickerMode: (UIDatePickerMode) mode {
    self.picker.datePickerMode = mode;
}

- (void) donePressed {
    if (self.doneTarget) {
        [self.doneTarget performSelector:self.doneSelector withObject:[self.picker date] afterDelay:0];
    }
}

-(void)cancelPressed{
    [self setHidden:YES animated:YES];
}

- (void) addTargetForDoneButton: (id) target action: (SEL) action {
    self.doneTarget = target;
    self.doneSelector = action;
}

- (void) setHidden: (BOOL) hidden animated: (BOOL) animated {
    CGRect newFrame = self.originalFrame;
    newFrame.origin.y += hidden ? self.frame.size.height : 0;
    if (animated) {
        [UIView beginAnimations: @"animateDateTimePicker" context: nil];
        [UIView setAnimationDuration: 0.5];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
        
        self.frame = newFrame;
        
        [UIView commitAnimations];
    } else {
        self.frame = newFrame;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
