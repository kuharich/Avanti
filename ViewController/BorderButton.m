

#import "BorderButton.h"

@interface BorderButton ()


@end

@implementation BorderButton
- (void)setHighlighted:(BOOL)highlighted{
    if (highlighted) {
        [[self layer] setBorderWidth:2.0f];

        if (self.tag ==4) {
            [[self layer] setBorderColor:[UIColor colorWithRed:111.0/255.0f  green:193.0/255.0f blue:69.0/255.0f alpha:1].CGColor];

        }if (self.tag ==5) {
            [[self layer] setBorderColor:[UIColor colorWithRed:32.0/255.0f  green:182.0/255.0f blue:224.0/255.0f alpha:1].CGColor];
            
        }if (self.tag ==6) {
            [[self layer] setBorderColor:[UIColor colorWithRed:249.0/255.0f  green:153.0/255.0f blue:35.0/255.0f alpha:1].CGColor];
            
        }
    } else {
        [[self layer] setBorderWidth:0.0f];
        [[self layer] setBorderColor:[UIColor clearColor].CGColor];
    }
}

@end
