//
//  ViewController.m
//  RPM
//
//  Created by Monica Mollica on 2016-03-17.
//  Copyright © 2016 Sergio Mollica. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) UIImageView *speedometer;
@property (nonatomic) UIImageView *needle;
@property (nonatomic) UIPanGestureRecognizer *cursor;
@property (nonatomic) UILabel *displayVelocity;
@property (nonatomic) float currentVelocity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:(252.0/255.0) green:(240.0/255.0) blue:(228.0/255.0) alpha:1.0];
    
    self.speedometer = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.speedometer.userInteractionEnabled = YES;
    self.speedometer.translatesAutoresizingMaskIntoConstraints = NO;
    self.speedometer.image = [UIImage imageNamed:@"speed"];
    
    [self.view addSubview:self.speedometer];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.speedometer
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.speedometer
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:100.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.speedometer
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:250.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.speedometer
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeNotAnAttribute
                                                         multiplier:1.0
                                                           constant:250.0]];
    
    self.needle = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.needle.userInteractionEnabled = YES;
    self.needle.translatesAutoresizingMaskIntoConstraints = NO;
    self.needle.image = [UIImage imageNamed:@"needle"];
    
    [self.view addSubview:self.needle];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.needle
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.speedometer
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.needle
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.speedometer
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.needle
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.speedometer
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.8
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.needle
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.speedometer
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:0.8
                                                           constant:0.0]];
    
    self.needle.transform = CGAffineTransformMakeRotation(0.8*M_PI);
    
    self.cursor = [[UIPanGestureRecognizer alloc]
                   initWithTarget:self
                   action:@selector(moveCursor:)];
    
   [self.view addGestureRecognizer:self.cursor];
    
    self.displayVelocity = [[UILabel alloc] initWithFrame:CGRectZero];
    self.displayVelocity.userInteractionEnabled = YES;
    self.displayVelocity.translatesAutoresizingMaskIntoConstraints = NO;
    self.displayVelocity.text = [[NSString alloc] initWithFormat:@"%f", self.currentVelocity];
    
    [self.view addSubview:self.displayVelocity];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.displayVelocity
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.displayVelocity
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.speedometer
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:50.0]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moveCursor:(UIPanGestureRecognizer*)recognizer  {
    float x = fabs([self.cursor velocityInView:self.view].x);
    float y = fabs([self.cursor velocityInView:self.view].y);
    self.currentVelocity = sqrt(powf(x, 2)+pow(y, 2));
    if(recognizer.state == UIGestureRecognizerStateEnded) {
        if(self.currentVelocity > 2499) {
            [self moveNeedleC:recognizer];
        }
        self.currentVelocity = 0;
        [self moveNeedle:recognizer];
    }
    self.displayVelocity.text = [[NSString alloc] initWithFormat:@"%f", fabsf(self.currentVelocity)];
    CGFloat angle = (self.currentVelocity / 5000 * 1.5 * M_PI) + (0.8 *M_PI);
    self.needle.transform = CGAffineTransformMakeRotation(angle);
}

- (void)moveNeedle:(UIPanGestureRecognizer*)recognizer {
    [UIView animateWithDuration:1.0 animations:^{
        CGFloat angle = 0.8 * M_PI;
        self.needle.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (void)moveNeedleC:(UIPanGestureRecognizer*)recognizer {
    [UIView animateWithDuration:0.1 animations:^{
        CGFloat angle = 1.7 * M_PI;
        self.needle.transform = CGAffineTransformMakeRotation(angle);
    }];
}

@end
