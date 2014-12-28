//
//  byteViewController.m
//  ESOStatus
//
//  Created by Marc Heimann on 01.05.14.
//  Copyright (c) 2014 Byte Software. All rights reserved.
//

#import "byteViewController.h"
#include "JSON.h"

@interface byteViewController ()

@property (nonatomic, strong) IBOutlet UIView *contentView;

@end

@implementation byteViewController {
    ADBannerView *_bannerView;
    NSTimer *_timer;
    UIView *_currentlyVisibleView;
    
    NSString *_view1Link;
    NSString *_view2Link;
    NSString *_view3Link;
}

@synthesize delegate, infoDictionary;

@synthesize lastRequestTime;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    } else {
        _bannerView = [[ADBannerView alloc] init];
    }
    _bannerView.delegate = self;
    
    requestor = [[WebRequestor alloc] init];
    //[self.view addSubview:_bannerView];
    [self initialize];
}



-(void)viewWillAppear:(BOOL)animated
{
  [self fadeOut: newsView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopTimer];
}

-(void) initialize {
    
    infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    europeStateTitleLabel.font = [UIFont fontWithName:@"Planewalker" size:14];
    europeStateTitleLabel.text = NSLocalizedString(@"server.title.eu.text", nil);
    
    northAmericaStateTitleLabel.font = [UIFont fontWithName:@"Planewalker" size:14];
    northAmericaStateTitleLabel.text = NSLocalizedString(@"server.title.na.text", nil);
    
    europeStateLabel.font = [UIFont fontWithName:@"Planewalker" size:16];
    northAmericaStateLabel.font = [UIFont fontWithName:@"Planewalker" size:16];
    
    footerTextLabelMenu.text = footerTextLabel.text = NSLocalizedString(@"footer.label.text", nil);    
    
    overviewButton.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    [overviewButton setTitle: NSLocalizedString( @"menu.overview.button.text", nil) forState: UIControlStateNormal];
    [overviewButton setTitle: NSLocalizedString( @"menu.overview.button.text", nil) forState: UIControlStateHighlighted];
    
    statisticsButton.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    [statisticsButton setTitle: NSLocalizedString( @"menu.statistic.button.text", nil) forState: UIControlStateNormal];
    [statisticsButton setTitle: NSLocalizedString( @"menu.statistic.button.text", nil) forState: UIControlStateHighlighted];
    
    newsButton.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    [newsButton setTitle: NSLocalizedString( @"menu.news.button.text", nil) forState: UIControlStateNormal];
    [newsButton setTitle: NSLocalizedString( @"menu.news.button.text", nil) forState: UIControlStateHighlighted];
    
    infoButton.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    [infoButton setTitle: NSLocalizedString( @"menu.information.button.text", nil) forState: UIControlStateNormal];
    [infoButton setTitle: NSLocalizedString( @"menu.information.button.text", nil) forState: UIControlStateHighlighted];
    
    proVersionButton.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    [proVersionButton setTitle: NSLocalizedString( @"menu.proversion.button.text", nil) forState: UIControlStateNormal];
    [proVersionButton setTitle: NSLocalizedString( @"menu.proversion.button.text", nil) forState: UIControlStateHighlighted];
    
    [self registerSwipeRecognizers];
    
    [self updateLabelStatus:@"SERVER_DOWN" forLabel:@"EU"];
    [self updateLabelStatus:@"SERVER_DOWN" forLabel:@"US"];
    
    [self readServerState:nil];
        
}

-(void) registerSwipeRecognizers {
    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    
    // Setting the swipe direction.
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipe {
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Left Swipe");
        [self closeMenu];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Right Swipe");
        [self openMenu];
    }
    
}

-(void) readServerState:(NSTimer *)timer {

    NSString *url = [infoDictionary valueForKey:@"ServerStatusURL"];
    
    NSLog(@"Sending request to %@", url);
 
    for (NSDictionary* value in [requestor httpsRequest:url withCommand:nil]) {
        NSLog(@"--> %@", value);
        
        NSString *location = [value objectForKey:@"LOCATION"];
        NSString * state = [value objectForKey:@"STATE"];
        
        [self updateLabelStatus:state forLabel:location];
    }
    
}

-(void) openURL: (NSURL*) url {
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}


-(IBAction) onWebLinkButtonClicked: (id) sender {
    //NSURL *url = [NSURL URLWithString:@"http://byte-software.de"];
    //[self openURL:url];
}

-(IBAction) onOverviewButtonClicked: (id) sender {
    UIButton *button = (UIButton*)sender;
    button.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    button.titleLabel.text = NSLocalizedString(@"menu.overview.button.text", nil);
    
    [self fadeIn:mainView fadeOut:_currentlyVisibleView];
}

-(IBAction) onStatisticButtonClicked: (id) sender {
    
    if (![_currentlyVisibleView isEqual:statisticView])
    {
        UIButton *button = (UIButton*)sender;
        button.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
        button.titleLabel.text = NSLocalizedString(@"menu.statistic.button.text", nil);
        
        
        NSString *url = [infoDictionary valueForKey:@"ServerStatisticURL"];
        
        for (NSDictionary* value in [requestor httpsRequest:url withCommand:nil]) {
            NSLog(@"--> %@", value);
            
            NSString *location = [value objectForKey:@"LOCATION"];
            NSDictionary *stats = [value objectForKey:@"STATISTCS"];
            
            float downtime = [[stats objectForKey:@"DOWNTIME_MS"] floatValue];
            float uptime = [[stats objectForKey:@"UPTIME_MS"] floatValue];
            
            
            if ([location isEqualToString:@"EU"]) {
                
                float allover = (downtime + uptime);
                float online = ((100 / allover) * uptime);
                float offline = ((100 / allover) * downtime);
                
                float oneHundredPercentWidth = euOnlineImage.frame.size.width;
                float onlinePercentWidth = (oneHundredPercentWidth / 100) * online;
                float offlinePercentWidth = (oneHundredPercentWidth / 100) * offline;
                
                
                euOnlineImage.frame = CGRectMake((euOnlineImage.frame.origin.x+oneHundredPercentWidth), euOnlineImage.frame.origin.y,
                                                 0, euOnlineImage.image.size.height-2);
                
                [UIView animateWithDuration:2 animations:^(void) {
                    euOnlineImage.frame = CGRectMake((euOnlineImage.frame.origin.x-(onlinePercentWidth)), euOnlineImage.frame.origin.y,
                                                     (long)onlinePercentWidth, euOnlineImage.image.size.height-2);
                }];
                
                euOfflineImage.frame = CGRectMake((euOfflineImage.frame.origin.x), euOfflineImage.frame.origin.y,
                                                  0, euOfflineImage.image.size.height-2);
                
                [UIView animateWithDuration:2 animations:^(void) {
                    euOfflineImage.frame = CGRectMake(euOfflineImage.frame.origin.x, euOfflineImage.frame.origin.y,
                                                      offlinePercentWidth, euOfflineImage.image.size.height-2);
                }];
                
                euOnlineTimeLabel.text = [self getTimestringFromLong:uptime];
                euOfflineTimeLabel.text = [self getTimestringFromLong:downtime];
                
            } else if ([location isEqualToString:@"US"]) {
                
                float allover = (downtime + uptime);
                float online = ((100 / allover) * uptime);
                float offline = ((100 / allover) * downtime);
                
                float oneHundredPercentWidth = usOnlineImage.frame.size.width;
                float onlinePercentWidth = (oneHundredPercentWidth / 100) * online;
                float offlinePercentWidth = (oneHundredPercentWidth / 100) * offline;
                
                
                
                usOnlineImage.frame = CGRectMake((usOnlineImage.frame.origin.x+oneHundredPercentWidth), usOnlineImage.frame.origin.y,
                                                 0, usOnlineImage.image.size.height-2);
                
                [UIView animateWithDuration:2 animations:^(void) {
                    usOnlineImage.frame = CGRectMake((usOnlineImage.frame.origin.x-(onlinePercentWidth)), usOnlineImage.frame.origin.y,
                                                     (long)onlinePercentWidth, usOnlineImage.image.size.height-2);
                }];
                
                usOfflineImage.frame = CGRectMake((usOfflineImage.frame.origin.x), usOfflineImage.frame.origin.y,
                                                  0, usOfflineImage.image.size.height-2);
                
                [UIView animateWithDuration:2 animations:^(void) {
                    usOfflineImage.frame = CGRectMake(usOfflineImage.frame.origin.x, usOfflineImage.frame.origin.y,
                                                      offlinePercentWidth, usOfflineImage.image.size.height-2);
                }];
                
                usOnlineTimeLabel.text = [self getTimestringFromLong:uptime];
                usOfflineTimeLabel.text = [self getTimestringFromLong:downtime];
                
            }
        }
        
        [self fadeIn:statisticView fadeOut:_currentlyVisibleView];
        
    } else {
       [self closeMenu];
    }
    
    
    
}

-(IBAction) onInfoButtonClicked: (id) sender {
    UIButton *button = (UIButton*)sender;
    button.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    button.titleLabel.text = NSLocalizedString(@"menu.information.button.text", nil);
    
    NSLog(@"InfoButton clicked");
    
    [self fadeIn:infoView fadeOut:_currentlyVisibleView];    
}

-(IBAction) onNewsButtonClicked: (id) sender {
    
    if (![_currentlyVisibleView isEqual:newsView])
    {
    
    UIButton *button = (UIButton*)sender;
    button.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    button.titleLabel.text = NSLocalizedString(@"menu.news.button.text", nil);
    
    [self fadeIn:newsView fadeOut:_currentlyVisibleView];
        
    NSString *url = [infoDictionary valueForKey:@"NewsURL"];
    
    NSLog(@"Sending request to %@", url);
        
    
    int count = 0;
    for (NSDictionary* value in [requestor httpsRequest:url withCommand:nil]) {
        NSLog(@"--> %@", value);

        switch(count) {
                
            case 0: {
                _view1Link = [NSString stringWithFormat:@"%@",[value objectForKey:@"link"]];
                NSString *url = [NSString stringWithFormat:@"http:%@",[value objectForKey:@"img"]];
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
                mainArticleImage.image = [UIImage imageWithData: imageData];
                
                mainArticleTitle.font = [UIFont fontWithName:@"Planewalker" size:14];
                mainArticleTitle.text = [value objectForKey:@"title"];
                NSString *description = [value objectForKey:@"description"];
                description = [description substringFromIndex:23];
                mainArticleTextField.text = description;
                mainArticleTextField.textColor = [UIColor whiteColor];
                mainArticleTextField.font = [UIFont fontWithName:@"Arial" size:10];
            } break;
                
            case 1: {
                _view2Link = [NSString stringWithFormat:@"%@",[value objectForKey:@"link"]];
                NSString *url = [NSString stringWithFormat:@"http:%@",[value objectForKey:@"img"]];
                
                NSLog(@"%@",url);
                
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
                leftSubArticleImage.image = [UIImage imageWithData: imageData];
                
                leftSubArticleTitle.font = [UIFont fontWithName:@"Planewalker" size:10];
                leftSubArticleTitle.text = [value objectForKey:@"title"];
                
                NSString *description = [value objectForKey:@"description"];
                description = [description substringFromIndex:23];
                leftSubArticleTextField.text = description;
                leftSubArticleTextField.textColor = [UIColor whiteColor];
                leftSubArticleTextField.font = [UIFont fontWithName:@"Arial" size:10];
            } break;
            
            case 3: {
                _view3Link = [NSString stringWithFormat:@"%@",[value objectForKey:@"link"]];
                
                NSString *url = [NSString stringWithFormat:@"http:%@",[value objectForKey:@"img"]];
                NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: url]];
                rightSubArticleImage.image = [UIImage imageWithData: imageData];
                
                rightSubArticleTitle.font = [UIFont fontWithName:@"Planewalker" size:10];
                rightSubArticleTitle.text = [value objectForKey:@"title"];
                
                NSString *description = [value objectForKey:@"description"];
                description = [description substringFromIndex:23];
                
                rightSubArticleTextField.text = description;
                rightSubArticleTextField.textColor = [UIColor whiteColor];
                rightSubArticleTextField.font = [UIFont fontWithName:@"Arial" size:10];
            } break;
                
            case 4: {
                return;
            };
                
        }

        count++;
    }
        
    } else {
        [self closeMenu];
    }
    
    
}


-(IBAction) onInfo1Clicked:(id)sender {
    NSURL *url = [NSURL URLWithString:_view1Link];
    [self openURL:url];
}

-(IBAction) onInfo2Clicked:(id)sender {
    NSURL *url = [NSURL URLWithString:_view2Link];
    [self openURL:url];
}

-(IBAction) onInfo3Clicked:(id)sender {
    NSURL *url = [NSURL URLWithString:_view3Link];
    [self openURL:url];
}

-(IBAction) onProVersionButtonClicked: (id) sender {
    UIButton *button = (UIButton*)sender;
    button.titleLabel.font = [UIFont fontWithName:@"Planewalker" size:20];
    button.titleLabel.text = NSLocalizedString(@"menu.proversion.button.text", nil);
    
//    UIWebView *webView = [UIWebView ]
    NSURL *url = [NSURL URLWithString:[infoDictionary valueForKey:@"ProVersionSiteURL"]];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    [myWebView loadRequest:requestURL];
    [self fadeIn:proVersionView fadeOut:_currentlyVisibleView];
    
}


-(void) updateLabelStatus:(NSString *)newStatus forLabel:(NSString *)region
{
    if ([region isEqualToString:[NSString stringWithFormat:@"EU"]]) {
        
        if ([newStatus isEqualToString:@"SERVER_UP"]) {
            europeStateLabel.textColor = [UIColor greenColor];
            europeStateLabel.text = @"Online";
        } else {
            europeStateLabel.textColor = [UIColor redColor];
            europeStateLabel.text = @"Offline";
        }
        
    } else if ([region isEqualToString:[NSString stringWithFormat:@"US"]]) {
        
        if ([newStatus isEqualToString:@"SERVER_UP"]) {
            northAmericaStateLabel.textColor = [UIColor greenColor];
            northAmericaStateLabel.text = @"Online";
        } else {
            northAmericaStateLabel.textColor = [UIColor redColor];
            northAmericaStateLabel.text = @"Offline";
        }
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startTimer
{
    NSNumber *frequency = [infoDictionary valueForKey:@"StateUpdateFrequency"];
    
    double freq = [frequency doubleValue];
    
    NSLog(@"Frequency: %f", freq);
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:freq
                                              target:self
                                            selector:@selector(readServerState:)
                                            userInfo:nil
                                             repeats:YES];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}


- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSString *desc = [error description];
    NSLog(@"%@",desc);
}

-(void)openMenu {

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:15.0];
	
	CGRect newFrame = menuView.frame;
	
	
	newFrame.origin.x = 0;
	menuView.frame = newFrame;
	
	[UIView commitAnimations];
    
}

-(void)closeMenu {

	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:15.0];
	
	CGRect newFrame = menuView.frame;
		
	newFrame.origin.x = -220;
	menuView.frame = newFrame;
	
	[UIView commitAnimations];
    
}

-(void)fadeIn: (UIView*) viewToFadeIn fadeOut: (UIView*) viewToFadeOut {
    if ([_currentlyVisibleView isEqual:viewToFadeIn]) {
        NSLog(@"This is allready the currentView");
        return;
    }
   
    [UIView animateWithDuration:0.3 animations:^(void) {
        if (![mainView isEqual:viewToFadeOut]) {
           viewToFadeOut.alpha = 0;
        }
        
        if (![mainView isEqual:viewToFadeIn]) {
           viewToFadeIn.alpha = 1;
        }
        _currentlyVisibleView = viewToFadeIn;
        [self closeMenu];
    }];
    
}

-(void) fadeOut: (UIView*) viewToFadeOut {
    [UIView animateWithDuration:0.3 animations:^(void) {
        if (![mainView isEqual:viewToFadeOut]) {
            viewToFadeOut.alpha = 0;
        }
    }];
}

- (NSString*)replacePattern:(NSString*)pattern withReplacement:(NSString*)replacement forString:(NSString*)string usingCharacterSet:(NSCharacterSet*)characterSetOrNil
{
    // Check if a NSCharacterSet has been provided, otherwise use our "default" one
    if (!characterSetOrNil)
        characterSetOrNil = [NSCharacterSet characterSetWithCharactersInString:@" !?,()]"];
    
    // Create a mutable copy of the string supplied, setup all the default variables we’ll need to use
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string];
    NSString *beforePatternString = nil;
    NSRange outputrange = NSMakeRange(0, 0);
    
    // Check if the string contains the "pattern" you’re looking for, otherwise simply return it.
    NSRange containsPattern = [mutableString rangeOfString:pattern];
    while (containsPattern.location != NSNotFound)
        // Found the pattern, let’s run with the changes
    {
        // Firstly, we grab the full string range
        NSRange stringrange = NSMakeRange(0, [mutableString length]);
        NSScanner *scanner = [[NSScanner alloc] initWithString:mutableString];
        
        // Now we use NSScanner to scan UP TO the pattern provided
        [scanner scanUpToString:pattern intoString:&beforePatternString];
        
        // Check for nil here otherwise you will crash – you will get nil if the pattern is at the very beginning of the string
        // outputrange represents the range of the string right BEFORE your pattern
        // We need this to know where to start searching for our characterset (i.e. end of output range = beginning of our pattern)
        if (beforePatternString != nil)
            outputrange = [mutableString rangeOfString:beforePatternString];
        
        // Search for any of the character sets supplied to know where to stop.
        // i.e. for a URL you’d be looking at non-URL friendly characters, including spaces (this may need a bit more research for an exhaustive list)
        NSRange characterAfterPatternRange = [mutableString rangeOfCharacterFromSet:characterSetOrNil options:NSLiteralSearch range:NSMakeRange(outputrange.length, stringrange.length-outputrange.length)];
        
        // Check if the link is not at the very end of the string, in which case there will be no characters AFTER it so set the NSRage location to the end of the string (== it’s length)
        if (characterAfterPatternRange.location == NSNotFound)
            characterAfterPatternRange.location = [mutableString length];
        
        // Assign the pattern’s start position and length, and then replace it with the pattern
        NSInteger patternStartPosition = outputrange.length;
        NSInteger patternLength = characterAfterPatternRange.location - outputrange.length;
        [mutableString replaceCharactersInRange:NSMakeRange(patternStartPosition, patternLength) withString:replacement];
        
        // Reset containsPattern for new mutablestring and let the loop continue
        containsPattern = [mutableString rangeOfString:pattern];
    }
    return [mutableString copy];
}

-(NSString*) getTimestringFromLong: (long) value {
    
    long dayDefinition = 86400000;
    long hourDefinition = 3600000;
    long minuteDefinition = 60000;
    
    int days = (value / dayDefinition);
    
    double remainder = fmod(value, dayDefinition);
    int hours = (remainder / hourDefinition);
    
    remainder = fmod(remainder, minuteDefinition);
    int minutes = (remainder / minuteDefinition);
    
    return [NSString stringWithFormat:@"%i Days, %i Hours, %iminutes", days, hours, minutes];
}

@end
