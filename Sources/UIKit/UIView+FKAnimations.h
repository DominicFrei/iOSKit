// Part of iOSKit http://foundationk.it

#import <UIKit/UIKit.h>

@interface UIView (FKAnimations)

// Animate removing a view from its parent
- (void)removeWithTransition:(UIViewAnimationTransition)transition duration:(float)duration;

// Animate adding a subview
- (void)addSubview:(UIView *)view withTransition:(UIViewAnimationTransition)transition duration:(float)duration;

// Animate the changing of a views frame
- (void)setFrame:(CGRect)frame duration:(float)duration;

// Animate changing the alpha of a view
- (void)setAlpha:(float)alpha duration:(float)duration;

@end
