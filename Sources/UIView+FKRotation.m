// Part of FoundationKit http://foundationk.it

#import "UIView+FKRotation.h"
#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Keys for associated objects
////////////////////////////////////////////////////////////////////////

static char portraitFrameKey;
static char landscapeFrameKey;

@implementation UIView (FKRotation)

+ (id)viewWithPortraitFrame:(CGRect)portraitFrame landscapeFrame:(CGRect)landscapeFrame {
    UIView *view = [[[[self class] alloc] initWithFrame:portraitFrame] autorelease];
    
    view.portraitFrame = portraitFrame;
    view.landscapeFrame = landscapeFrame;
    
    return view;
}

- (BOOL)hasPortraitAndLandscapeFrames {
    return !CGRectIsEmpty(self.portraitFrame) && !CGRectIsEmpty(self.landscapeFrame);
}

- (CGRect)portraitFrame {
    // read associated object for portrait frame
    NSValue *portraitFrameValue = (NSValue *)objc_getAssociatedObject(self, &portraitFrameKey);
    
    if (portraitFrameValue != nil) {
        return [portraitFrameValue CGRectValue];
    } else {
        return CGRectZero;
    }
}

- (CGRect)landscapeFrame {
    // read associated object for landscape frame
    NSValue *landscapeFrameValue = (NSValue *)objc_getAssociatedObject(self, &landscapeFrameKey);
    
    if (landscapeFrameValue != nil) {
        return [landscapeFrameValue CGRectValue];
    } else {
        return CGRectZero;
    }
}

- (void)setPortraitFrame:(CGRect)portraitFrame {
    NSValue *portraitFrameValue = [NSValue valueWithCGRect:portraitFrame];
    objc_setAssociatedObject(self, &portraitFrameKey, portraitFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLandscapeFrame:(CGRect)landscapeFrame {
    NSValue *landscapeFrameValue = [NSValue valueWithCGRect:landscapeFrame];
    objc_setAssociatedObject(self, &landscapeFrameKey, landscapeFrameValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (CGRect)frameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        return self.portraitFrame;
    } else {
        return self.landscapeFrame;
    }
}

- (void)animateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration animations:^{
        [self setFrameForInterfaceOrientation:toInterfaceOrientation];
    }];
}

- (void)setFrameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {
        CGRect portraitFrame = self.portraitFrame;
        
        if (!CGRectIsEmpty(portraitFrame)) {
            self.frame = portraitFrame;
        }
    } else {
        CGRect landscapeFrame = self.landscapeFrame;
        
        if (!CGRectIsEmpty(landscapeFrame)) {
            self.frame = landscapeFrame;
        }
    }
}

- (void)setSubviewFramesForInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    [self setSubviewFramesForInterfaceOrientation:toInterfaceOrientation recursive:NO];
}

- (void)setSubviewFramesForInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation recursive:(BOOL)recursive {
    for (UIView *view in self.subviews) {
        if (view.hasPortraitAndLandscapeFrames) {
            [view setFrameForInterfaceOrientation:toInterfaceOrientation];
            
            if (recursive) {
                [view setSubviewFramesForInterfaceOrientation:toInterfaceOrientation recursive:recursive];
            }
        }
    } 
}


@end
