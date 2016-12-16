

#import <UIKit/UIKit.h>

@interface WSLAlertViewAutoDismiss : UIAlertView<UIAlertViewDelegate>

@property (nonatomic,strong) void(^actionBlock)(NSInteger);
@property (nonatomic,strong) void(^cancelBlock)();

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
             action:(void(^)(NSInteger))action
       cancelAction:(void(^)(void))cancel
  cancelButtonTitle:(NSString *)cancelButtonTitle 
  otherButtonTitles:(NSString *)otherButtonTitles, ... ;

@end
