//
//  ProgressBar.m
//  ServeBoard
//
//  Created by Jin Bei on 3/13/13.
//  Copyright (c) 2013 Jin Bei. All rights reserved.
//

#import "ProgressBar.h"

@implementation ProgressBar

#pragma mark -
#pragma mark Initialize

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.minValue = 0;
        self.maxValue = 1;
        self.currentValue = 0;
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
        self.progressColor = [UIColor colorWithRed:112.0/255.0 green:112.0/255.0 blue:112.0/255.0 alpha:1.0];
        self.progressRemainingColor = [UIColor clearColor];
//        self.textColor = [[UIColor magentaColor] retain];

    }
    return self;
}

#pragma mark -

- (void)drawRect:(CGRect)rect {

     CGContextRef context = UIGraphicsGetCurrentContext();
    
    float progressBorderRadius = 8.0;
	float progressBorderWidth = 2.0;
	float progressBarRadius = 5.0;
	float progressBarInset = 3.0;


    
    UIGraphicsPushContext(context);

    CGRect rrect = CGRectInset(self.bounds, progressBorderWidth, progressBorderWidth);
    CGFloat radius = progressBorderRadius;
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextSetLineWidth(context, progressBorderWidth);
    CGContextDrawPath(context, kCGPathStroke);

    radius = progressBarRadius;
    CGFloat theProgress = (self.currentValue - self.minValue)/(self.maxValue - self.minValue);
    rrect = CGRectInset(rrect, progressBarInset, progressBarInset);
    rrect.size.width = rrect.size.width * theProgress;
    minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, [self.progressColor CGColor]);
    CGContextDrawPath(context, kCGPathFill);

    UIGraphicsPopContext();
    
    
//    CGContextSetLineWidth(context, 3);
//    CGContextSetStrokeColorWithColor(context,[self.lineColor CGColor]);
//    
//    //upper half
//    CGContextSetFillColorWithColor(context, [[self.progressRemainingColor colorWithAlphaComponent:.7] CGColor]);
//    CGContextAddRect(context, CGRectMake(2, 2, rect.size.width-4, ((rect.size.height/2)-2)));
//    CGContextFillPath(context);
//    
//    //lower half
//    CGContextSetFillColorWithColor(context, [self.progressRemainingColor CGColor]);
//    CGContextAddRect(context, CGRectMake(2, rect.size.height/2-2, rect.size.width-4, ((rect.size.height/2)-2)));
//    CGContextFillPath(context);
//    
//    //border
//    CGContextAddRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height-2));
//    CGContextStrokePath(context);
//    
//    //to plot progress
//    float amount = (self.currentValue/(self.maxValue - self.minValue)) * (rect.size.width-5);
//    CGContextSetFillColorWithColor(context, [self.progressColor CGColor]);
//    CGContextAddRect(context, CGRectMake(2,2, amount, rect.size.height-5));
//    CGContextFillPath(context);
//    
//    //to draw percentage text
//    CGContextSetFillColorWithColor(context, [self.textColor CGColor]);
//    CGContextSelectFont(context, "Helvetica", rect.size.height/2, kCGEncodingMacRoman);
//    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0, -1.0));
//    CGContextSetTextDrawingMode(context, kCGTextFill);
//    char str[20];
//    sprintf(str, "%d %s" ,(int)self.currentValue,"%");
//    CGContextShowTextAtPoint(context,((rect.size.width/2)-10),rect.size.height/2,str,strlen(str));
}

-(void)setNewRect:(CGRect)newFrame {
    self.frame = newFrame;
    [self setNeedsDisplay];
}

#pragma mark -

-(void)setMinValue:(float)newMin    {
    _minValue = newMin;
    [self setNeedsDisplay];
}

-(void)setMaxValue:(float)newMax    {
    _maxValue = newMax;
    [self setNeedsDisplay];
}

-(void)setCurrentValue:(float)newValue    {
    
    if(newValue < _minValue)
        _currentValue = _minValue;
    else if(newValue > _maxValue)
        _currentValue = _maxValue;
    else
        _currentValue = newValue;
    [self setNeedsDisplay];
}

#pragma mark -

-(void)setLineColor:(UIColor *)newColor    {
    [newColor retain];
    [_lineColor release];
    _lineColor = newColor;
    [self setNeedsDisplay];
}

-(void)setTextColor:(UIColor *)newColor    {
    [newColor retain];
    [_textColor release];
    _textColor = newColor;
    [self setNeedsDisplay];
}

-(void)setProgressColor:(UIColor *)newColor    {
    [newColor retain];
    [_progressColor release];
    _progressColor = newColor;
    [self setNeedsDisplay];
}

-(void)setProgressRemainingColor:(UIColor *)newColor    {
    [newColor retain];
    [_progressRemainingColor release];
    _progressRemainingColor = newColor;
    [self setNeedsDisplay];
}

#pragma mark -

- (void)dealloc {
    [_lineColor release];
    [_textColor release];
    [_progressColor release];
    [_progressRemainingColor release];
    [super dealloc];
}

@end
