/*

   Copyright (c) 2010, Mobisoft Infotech
   All rights reserved.

   Redistribution and use in source and binary forms, with or without modification, are
   permitted provided that the following conditions are met:

   Redistributions of source code must retain the above copyright notice, this list of
   conditions and the following disclaimer.

   Redistributions in binary form must reproduce the above copyright notice,
   this list of conditions and the following disclaimer in the documentation and/or
   other materials provided with the distribution.

   Neither the name of Mobisoft Infotech nor the names of its contributors may be used to
   endorse or promote products derived from this software without specific prior written permission.
   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS
   OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
   AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
   SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
   THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
   OF SUCH DAMAGE.

 */

#import "MIRadioButtonGroup.h"

//#define DEFAULT_FONT_NAME           @"Heiti TC"

@implementation MIRadioButtonGroup
@synthesize radioButtons;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andOptions:(NSArray *)options andColumns:(int)columns {
	NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
	self.radioButtons = arrTemp;
  
	if (self = [super initWithFrame:frame]) {
		// Initialization code
		int framex = 0;
		framex = frame.size.width / columns;
		int framey = 0;
		framey = frame.size.height / ([options count] / (columns));
		int rem = [options count] % columns;
		if (rem != 0) {
			framey = frame.size.height / (([options count] / columns) + 1);
		}
		int k = 0;
		for (int i = 0; i < ([options count] / columns); i++) {
			for (int j = 0; j < columns; j++) {
				int x = framex * 0.25;
				int y = framey * 0.25;
                UIButton *btTemp;
                if (options.count==2) {
                    y = framey * 0.15;
                    btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j, framey * i + y, framex * 0.95f + x, framey / 2 + y)];
                    [btTemp addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                    btTemp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    
                    [btTemp setImage:[UIImage imageNamed:@"radiobtn_inactive.png"] forState:UIControlStateNormal];
                    [btTemp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    btTemp.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:12.0f];
                    [btTemp setTitle:[options objectAtIndex:k] forState:UIControlStateNormal];
                    [self.radioButtons addObject:btTemp];
                    [self addSubview:btTemp];
                }
                else {
                    NSString *title = nil;
                    title = [options objectAtIndex:k];
                    if (j==1) {
                        if ([title length]>=3)
                        {
                            btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j+10, framey * i + y, framex * 0.95f + x, framey / 2 + y)];
                        }
                        else
                        btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j, framey * i + y, framex * 0.95f + x, framey / 2 + y)];
                      //  [btTemp setBackgroundColor:[UIColor redColor]];

                    }
                    else{
                        if ([title length]>=3)
                        {
                            btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j+10, framey * i + y, framex * 0.95f + x, framey / 2 + y)];
                        }
                       else btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j, framey * i + y, framex * 0.95f + x, framey / 2 + y)];
                //        [btTemp setBackgroundColor:[UIColor cyanColor]];

                    }
                  //  btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j, framey * i + y, framex * 0.95f + x, framey / 2 + y)];//Rajesh Change For

                    [btTemp addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                   btTemp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                    btTemp.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    // you probably want to center it
                   // btTemp.titleLabel.textAlignment = NSTextAlignmentCenter; //
                    [btTemp setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
                    [btTemp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    btTemp.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:12.0f];
                    [btTemp setTitle:[options objectAtIndex:k] forState:UIControlStateNormal];
                    [self.radioButtons addObject:btTemp];
                    [self addSubview:btTemp];
                }
				k++;
			}
		}

		for (int j = 0; j < rem; j++) {
			int x = framex * 0.25;
			int y = framey * 0.25;
            
            UIButton *btTemp = [[UIButton alloc]initWithFrame:CGRectMake(framex * j, framey * ([options count] / columns) + y, framex * 0.75f + x, framey / 2 + y)];
			[btTemp addTarget:self action:@selector(radioButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
			btTemp.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
			[btTemp setImage:[UIImage imageNamed:@"radio-off.png"] forState:UIControlStateNormal];
			[btTemp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            
			btTemp.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_NAME size:13];
			[btTemp setTitle:[options objectAtIndex:k] forState:UIControlStateNormal];
			[self.radioButtons addObject:btTemp];
			[self addSubview:btTemp];
			k++;
		}
	}
	return self;
}

- (IBAction)radioButtonClicked:(UIButton *)sender {

    NSString *radio_off = @"radio-off.png";
    NSString *radio_on = @"radio-on.png";
    
    if (self.radioButtons.count==2) {
        radio_off = @"radiobtn_inactive.png";
        radio_on= @"radiobtn_active.png";
    }
    
    int index = 0;
	for (int i = 0; i < [self.radioButtons count]; i++) {
        UIButton *btn = [self.radioButtons objectAtIndex:i];
		[btn setImage:[UIImage imageNamed:radio_off] forState:UIControlStateNormal];
        if ([btn isEqual:sender]) {
            index = i;
        }
	}
	[sender setImage:[UIImage imageNamed:radio_on] forState:UIControlStateNormal];
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickedRadioButton:atIndex:)]) {
        [self.delegate clickedRadioButton:sender atIndex:index];
    }
}

- (void)removeButtonAtIndex:(int)index {
	[[self.radioButtons objectAtIndex:index] removeFromSuperview];
}

- (void)setSelected:(int)index {
    NSString *radio_off = @"radio-off.png";
    NSString *radio_on = @"radio-on.png";
    
    if (self.radioButtons.count==2) {
        radio_off = @"radiobtn_inactive.png";
        radio_on= @"radiobtn_active.png";
    }
	for (int i = 0; i < [self.radioButtons count]; i++) {
		[[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:radio_off] forState:UIControlStateNormal];
	}
	[[self.radioButtons objectAtIndex:index] setImage:[UIImage imageNamed:radio_on] forState:UIControlStateNormal];
}

- (void)clearAll {
    NSString *radio_off = @"radio-off.png";
    if (self.radioButtons.count==2) {
        radio_off = @"radiobtn_inactive.png";
    }
	for (int i = 0; i < [self.radioButtons count]; i++) {
		[[self.radioButtons objectAtIndex:i] setImage:[UIImage imageNamed:radio_off] forState:UIControlStateNormal];
	}
}

@end
