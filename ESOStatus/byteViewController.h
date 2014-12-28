//
//  byteViewController.h
//  ESOStatus
//
//  Created by Marc Heimann on 01.05.14.
//  Copyright (c) 2014 Byte Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebRequestor.h"
#import "byteAppDelegate.h"
#import <iAd/iAd.h>

@interface byteViewController : UIViewController <ADBannerViewDelegate>
{
    IBOutlet UILabel *europeStateTitleLabel;
    IBOutlet UILabel *northAmericaStateTitleLabel;
    
    IBOutlet UILabel *europeStateLabel;
    IBOutlet UILabel *northAmericaStateLabel;
    
    IBOutlet UILabel *footerTextLabel;
    IBOutlet UILabel *footerTextLabelMenu;
    
    IBOutlet UIButton *weblinkButton;
    
    IBOutlet UISwipeGestureRecognizer *swipeLeft;
    
    IBOutlet UISwipeGestureRecognizer *swipeRight;
    
    IBOutlet UIView *mainView;
    
    IBOutlet UIView *menuView;
    
    IBOutlet UIView *newsView;
    IBOutlet UIView *infoView;
    IBOutlet UIView *statisticView;
    IBOutlet UIView *proVersionView;
    
    IBOutlet UIImageView *mainArticleImage;
    IBOutlet UIImageView *leftSubArticleImage;
    IBOutlet UIImageView *rightSubArticleImage;
    
    IBOutlet UITextView *mainArticleTextField;
    IBOutlet UITextView *leftSubArticleTextField;
    IBOutlet UITextView *rightSubArticleTextField;
    
    IBOutlet UILabel *mainArticleTitle;
    IBOutlet UILabel *leftSubArticleTitle;
    IBOutlet UILabel *rightSubArticleTitle;
    
    IBOutlet UILabel *newsViewTitle;
    
    /** Menu Buttons */
    IBOutlet UIButton *overviewButton;
    IBOutlet UIButton *statisticsButton;
    IBOutlet UIButton *newsButton;
    IBOutlet UIButton *infoButton;
    IBOutlet UIButton *proVersionButton;
    
    IBOutlet UIButton *readInfo1;
    IBOutlet UIButton *readInfo2;
    IBOutlet UIButton *readInfo3;
    
    IBOutlet UIImageView *euOnlineImage;
    IBOutlet UIImageView *euOnlineCoverImage;
    IBOutlet UIImageView *euOfflineImage;
    IBOutlet UIImageView *euOfflineCoverImage;
    
    IBOutlet UILabel *euOnlineTimeLabel;
    IBOutlet UILabel *euOfflineTimeLabel;
    
    IBOutlet UILabel *usOnlineTimeLabel;
    IBOutlet UILabel *usOfflineTimeLabel;
    
    IBOutlet UIImageView *usOnlineImage;
    IBOutlet UIImageView *usOnlineCoverImage;
    IBOutlet UIImageView *usOfflineImage;
    IBOutlet UIImageView *usOfflineCoverImage;
    
    IBOutlet UIWebView *myWebView;
    
    WebRequestor *requestor;
    
    byteAppDelegate *delegate;
    
    long lastRequestTime;
    
    NSDictionary *infoDictionary;
}

-(void) updateLabelStatus: (NSString*) newStatus forLabel: (NSString*) region;
-(void) initialize;
-(void) readServerState:(NSTimer *)timer;

-(IBAction) onWebLinkButtonClicked: (id) sender;

-(IBAction) onOverviewButtonClicked: (id) sender;
-(IBAction) onStatisticButtonClicked: (id) sender;
-(IBAction) onNewsButtonClicked: (id) sender;
-(IBAction) onInfoButtonClicked: (id) sender;
-(IBAction) onProVersionButtonClicked: (id) sender;

-(IBAction) onInfo1Clicked:(id)sender;
-(IBAction) onInfo2Clicked:(id)sender;
-(IBAction) onInfo3Clicked:(id)sender;

@property (nonatomic, retain) NSDictionary *infoDictionary;
@property (nonatomic, retain) byteAppDelegate *delegate;

@property long lastRequestTime;


@end
