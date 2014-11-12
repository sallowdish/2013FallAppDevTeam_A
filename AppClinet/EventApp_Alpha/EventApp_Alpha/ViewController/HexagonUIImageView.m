//
//  HexagonUIImageView.m
//  哪兒玩
//
//  Created by Rui Zheng on 2014-11-12.
//  Copyright (c) 2014 2013_Fall_Dev_Team_A. All rights reserved.
//

#import "HexagonUIImageView.h"

@implementation HexagonUIImageView

-(void)prepareApprence{
    [self addHexagonLayout];
    [self addShadow];
}

/** Create UIBezierPath for regular polygon with rounded corners
 *
 * @param square        The CGRect of the square in which the path should be created.
 * @param lineWidth     The width of the stroke around the polygon. The polygon will be inset such that the stroke stays within the above square.
 * @param sides         How many sides to the polygon (e.g. 6=hexagon; 8=octagon, etc.).
 * @param cornerRadius  The radius to be applied when rounding the corners.
 *
 * @return              UIBezierPath of the resulting rounded polygon path.
 */

- (UIBezierPath *)roundedPolygonPathWithRect:(CGRect)square
                                   lineWidth:(CGFloat)lineWidth
                                       sides:(NSInteger)sides
                                cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta       = 2.0 * M_PI / sides;                           // how much to turn at every corner
    CGFloat offset      = cornerRadius * tanf(theta / 2.0);             // offset from which to start rounding corners
    CGFloat squareWidth = MIN(square.size.width, square.size.height);   // width of the square
    
    // calculate the length of the sides of the polygon
    
    CGFloat length      = squareWidth - lineWidth;
    if (sides % 4 != 0) {                                               // if not dealing with polygon which will be square with all sides ...
        length = length * cosf(theta / 2.0) + offset/2.0;               // ... offset it inside a circle inside the square
    }
    CGFloat sideLength = length * tanf(theta / 2.0);
    
    // start drawing at `point` in lower right corner
    
    CGPoint point = CGPointMake(squareWidth / 2.0 + sideLength / 2.0 - offset, squareWidth - (squareWidth - length) / 2.0);
    CGFloat angle = M_PI;
    [path moveToPoint:point];
    
    // draw the sides and rounded corners of the polygon
    
    for (NSInteger side = 0; side < sides; side++) {
        point = CGPointMake(point.x + (sideLength - offset * 2.0) * cosf(angle), point.y + (sideLength - offset * 2.0) * sinf(angle));
        [path addLineToPoint:point];
        
        CGPoint center = CGPointMake(point.x + cornerRadius * cosf(angle + M_PI_2), point.y + cornerRadius * sinf(angle + M_PI_2));
        [path addArcWithCenter:center radius:cornerRadius startAngle:angle - M_PI_2 endAngle:angle + theta - M_PI_2 clockwise:YES];
        
        point = path.currentPoint; // we don't have to calculate where the arc ended ... UIBezierPath did that for us
        angle += theta;
    }
    
    [path closePath];
    
    return path;
}

-(void)addHexagonLayout{
    CGFloat lineWidth    = 3.0;
    UIBezierPath *path   = [self roundedPolygonPathWithRect:self.bounds
                                                  lineWidth:lineWidth
                                                      sides:6
                                               cornerRadius:self.bounds.size.height*0.05];
    
    CAShapeLayer *mask   = [CAShapeLayer layer];
    mask.path            = path.CGPath;
    mask.lineWidth       = lineWidth;
    mask.strokeColor     = [UIColor clearColor].CGColor;
    mask.fillColor       = [UIColor whiteColor].CGColor;
 
    self.layer.mask = mask;
    

    
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.path          = path.CGPath;
    border.lineWidth     = lineWidth;
    border.strokeColor   = [UIColor whiteColor].CGColor;
    border.fillColor     = [UIColor clearColor].CGColor;
    

    
    
    
//    CALayer *shadow=[CALayer layer];
////    shadow.shadowColor=[UIColor blackColor].CGColor;
//    shadow.shadowOffset = CGSizeMake(0.f, 5.f);
//    shadow.shadowRadius = 5;
//    shadow.shadowOpacity = 1.f;
//    [shadow addSublayer:border];
    
    [self.layer addSublayer:border];
    
}

-(void)addShadow{
//    self.layer.masksToBounds = NO;
////    self.layer.cornerRadius = 8; // if you like rounded corners
//    self.layer.shadowOffset = CGSizeMake(-15, 20);
//    self.layer.shadowRadius = 5;
//    self.layer.shadowOpacity = 0.5;
//    self.backgroundColor=[UIColor grayColor];
}

@end
