//
//  RangeSlider.m
//  RangeSlider
//
//  Created by Mal Curtis on 5/08/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RangeSlider.h"

@interface RangeSlider (PrivateMethods)
- (void)_RS_commonInit;
- (float)xForValue:(float)value;
- (float)valueForX:(float)x;
- (void)updateTrackHighlight;
@end

@implementation RangeSlider

@synthesize minimumValue, maximumValue, minimumRange, selectedMinimumValue, selectedMaximumValue;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }

    [self _RS_commonInit];

    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self _RS_commonInit];
    
    return self;
}

- (void)_RS_commonInit;
{
    CGRect bounds = [self bounds];
    
    _minThumbOn = false;
    _maxThumbOn = false;
    _padding = 0;
    
    _trackBackground = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar-background.png"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:0]] autorelease];
    _trackBackground.frameY = _trackBackground.frameHeight / 2.0f;
    _trackBackground.frameX = _padding;
    _trackBackground.frameWidth = bounds.size.width - (_padding * 2);
    _trackBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    [self addSubview:_trackBackground];
    
    _track = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"bar-highlight.png"] stretchableImageWithLeftCapWidth:20.0f topCapHeight:0]] autorelease];
    _track.frameY = _track.frameHeight / 2.0f;
    _track.frameX = _padding;
    _track.frameWidth = bounds.size.width - (_padding * 2);
    _track.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self addSubview:_track];
    
    _minThumb = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]] autorelease];
    _minThumb.frame = CGRectMake(0, 0, bounds.size.height, bounds.size.height);
    _minThumb.contentMode = UIViewContentModeCenter;
    [self addSubview:_minThumb];
    
    _maxThumb = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"handle.png"] highlightedImage:[UIImage imageNamed:@"handle-hover.png"]] autorelease];
    _maxThumb.frame = CGRectMake(0, 0, bounds.size.height, bounds.size.height);
    _maxThumb.contentMode = UIViewContentModeCenter;
    [self addSubview:_maxThumb];    
    
    self.minimumValue = 0.0f;
    self.maximumValue = 100.0f;
    self.minimumRange = 10.0f;
    self.selectedMinimumValue = 25.0f;
    self.selectedMaximumValue = 50.0f;
}


-(void)layoutSubviews
{
    // Set the initial state
    _minThumb.center = CGPointMake([self xForValue:selectedMinimumValue], 13.0f);
    _maxThumb.center = CGPointMake([self xForValue:selectedMaximumValue], 13.0f);
    
    NSLog(@"Tapable size %f", _minThumb.bounds.size.width); 
    [self updateTrackHighlight];
    
    
}

-(float)xForValue:(float)value{
    return (self.frame.size.width-(_padding*2))*((value - minimumValue) / (maximumValue - minimumValue))+_padding;
}

-(float) valueForX:(float)x{
    return minimumValue + (x-_padding) / (self.frame.size.width-(_padding*2)) * (maximumValue - minimumValue);
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    if(!_minThumbOn && !_maxThumbOn){
        return YES;
    }
    
    CGPoint touchPoint = [touch locationInView:self];
    if(_minThumbOn){
        _minThumb.center = CGPointMake(MAX([self xForValue:minimumValue],MIN(touchPoint.x - distanceFromCenter, [self xForValue:selectedMaximumValue - minimumRange])), _minThumb.center.y);
        selectedMinimumValue = [self valueForX:_minThumb.center.x];
        
    }
    if(_maxThumbOn){
        _maxThumb.center = CGPointMake(MIN([self xForValue:maximumValue], MAX(touchPoint.x - distanceFromCenter, [self xForValue:selectedMinimumValue + minimumRange])), _maxThumb.center.y);
        selectedMaximumValue = [self valueForX:_maxThumb.center.x];
    }
    [self updateTrackHighlight];
    [self setNeedsLayout];
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    return YES;
}

-(BOOL) beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchPoint = [touch locationInView:self];
    
    if(CGRectContainsPoint(_minThumb.frame, touchPoint)){
        _minThumbOn = true;
        distanceFromCenter = touchPoint.x - _minThumb.center.x;
    }
    else if(CGRectContainsPoint(_maxThumb.frame, touchPoint)){
        _maxThumbOn = true;
        distanceFromCenter = touchPoint.x - _maxThumb.center.x;
        
    }
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    _minThumbOn = false;
    _maxThumbOn = false;
}

-(void)updateTrackHighlight{
	_track.frame = CGRectMake(
                              _minThumb.center.x,
                              _track.center.y - (_track.frame.size.height/2),
                              _maxThumb.center.x - _minThumb.center.x,
                              _track.frame.size.height
                              );
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
