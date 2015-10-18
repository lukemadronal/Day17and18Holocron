//
//  ViewController.m
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import "ViewController.h"
#import "CharacterViewController.h"
#import "SearchResultsViewController.h"

@interface ViewController ()

@property(nonatomic,strong) IBOutlet UIImageView          *hyperSpaceImage;
@property(nonatomic,strong) IBOutlet UISearchBar          *characterSearchBar;
@property(nonatomic,weak)   IBOutlet NSLayoutConstraint   *viewTopConstraint;
@property (nonatomic,strong)         NSMutableArray       *trackMutableArray;
@property (nonatomic,strong)         NSURL                *currentURL;
@property (nonatomic,strong)         NSString             *currentURLString;
@property (nonatomic,strong)         NSString             *hostName;
@property(nonatomic,strong) IBOutlet UIImageView          *triviaImage;
@property(nonatomic,strong) IBOutlet UIImageView          *charactersImage;
@property(nonatomic,strong) IBOutlet UIImageView          *yodaImage;
@property(nonatomic,strong) IBOutlet UIImageView          *hanSoloImage;
@property(nonatomic,strong) IBOutlet UIImageView          *padmeImage;
@property(nonatomic,strong) IBOutlet UIImageView          *lukeSkywalkerImage;
@property(nonatomic,strong) IBOutlet UIImageView          *darthMaulImage;
@property(nonatomic,strong) IBOutlet UIImageView          *chewieImage;

@end

@implementation ViewController

Reachability *hostReach;
Reachability *internetReach;
Reachability *wifiReach;
bool internetAvailable;
bool serverAvailable;

#pragma mark - Network Methods

-(void)updateReachablityStatus: (Reachability *)currReach {
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    NetworkStatus netStatus = [currReach currentReachabilityStatus];
    if (currReach == hostReach) {
        switch (netStatus) {
            case NotReachable:
                NSLog(@"server not reachable");
                serverAvailable = false;
                break;
            case ReachableViaWiFi:
                NSLog(@"server reachable via wifi");
                serverAvailable=true;
                break;
            case ReachableViaWWAN:
                NSLog(@"server reachable via wan");
                serverAvailable = true;
                break;
            default:
                break;
        }
    }
    if (currReach == internetReach) {
        switch (netStatus) {
            case NotReachable:
                NSLog(@"interent not reachable");
                internetAvailable = false;
                break;
            case ReachableViaWiFi:
                NSLog(@"internet reachable via wifi");
                internetAvailable=true;
                break;
            case ReachableViaWWAN:
                NSLog(@"internet reachable via wan");
                internetAvailable= true;
                break;
            default:
                break;
        }
    }
}

-(void)reachabilityChanged: (NSNotification *)note {
    Reachability *currReach = [note object];
    [self updateReachablityStatus:currReach];
}

-(NSString *) getDocumentsDirectory {
    NSArray *paths= NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true);
    //NSLog(@"DocPath:%@",paths[0]);
    return paths[0];
}

-(BOOL)fileIsLocal:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [[self getDocumentsDirectory] stringByAppendingPathComponent:fileName];
    return [fileManager fileExistsAtPath:filePath];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //-(void)getFilePressed:(UISearchBar *)searchBar {
    //-(IBAction)seachButtonPressed:(id)sender {
    //[searchBar resignFirstResponder];
    if (serverAvailable) {
        NSLog(@"server not available");
        //      NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/classfiles/iOS_URL_Class_Get_File.txt",_hostName]];
        //        NSURL *fileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/classfiles/flavors.json",_hostName]];
        //NSString *searchName = _characterSearchBar.text;
        _currentURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://f5f99962.ngrok.io/character/Spock"]];
        _currentURLString = [NSString stringWithFormat:@"https://f5f99962.ngrok.io/character/Spock"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:_currentURL];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval:30.0];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (([data length] >0) && (error == nil)) {
                NSLog(@"Got Data %@", data);
                //                                NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                //                                NSLog(@"Got String %@", dataString);
                NSJSONSerialization *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                NSLog(@"json: %@", json);
                _trackMutableArray = [(NSDictionary *) json objectForKey:@"results"];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //MAIN THREAD CODE GOES HERE
                    NSLog(@"size is: %li",_trackMutableArray.count);
                    if (_trackMutableArray.count > 1) {
                        [self performSegueWithIdentifier:@"searchToSearchResultsSegue" sender:self];
                    } else if (_trackMutableArray.count==1) {
                        [self performSegueWithIdentifier:@"searchToCharacterSegue" sender:self];
                    } else {
                        //throw error message
                    }
                });
            } else {
                NSLog(@"DONT Got Data");
            }
        }] resume];
    } else {
        NSLog(@"server not available");
    }
    //seque to controller
}

-(void)getImageFromServer:(NSString *)localFileName fromUrl:(NSString *)fullFileName {
    if(serverAvailable) {
        NSURL *fileURL = [NSURL URLWithString:fullFileName];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        [request setURL:fileURL];
        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        [request setTimeoutInterval:30.0];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ([data length] > 0 && error==nil) {
                NSString *savedFilePath = [[self getDocumentsDirectory] stringByAppendingPathComponent:localFileName];
                UIImage *imageTemp = [UIImage imageWithData:data];
                if (imageTemp != nil) {
                    [data writeToFile:savedFilePath atomically:true];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //main thread goes here
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"gotImageNotification" object:nil];
                    });
                }
            } else {
                NSLog(@"no data");
            }
        }]resume];
    } else {
        NSLog(@"server not available");
    }
}

#pragma mark - animation methods
-(IBAction)toggleMenuView:(id)sender {
    NSLog(@"toggle");
    if (_characterSearchBar.hidden) {
        [_characterSearchBar setHidden:NO];
        [UIView animateWithDuration:0.5 delay: 0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //            [_menuView setAlpha:1.0];
            [_viewTopConstraint setConstant:0.0];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //            [_menuView setAlpha:0.0];
            CGFloat offScreen = -1*_characterSearchBar.frame.size.height;
            [_viewTopConstraint setConstant:offScreen];
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [_characterSearchBar setHidden:true];
        }];
    }
    
}

#pragma mark - Life Cycle Methods

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    /*
     if (array.count > 1 ) {
        do the loop below and segue to table view of search results
     } else {
        if( array.count == 1) {
            segue to third view controller which is the character view controller
        }
        if (array.count ==0) {
            throw error message that there are not search results
        }
     }
    }
     
     
     */
    
    //many results->tableView
    if ([[segue identifier] isEqualToString:@"searchToSearchResultsSegue"]) {
        SearchResultsViewController *searchController = [segue destinationViewController];
        searchController.currentCharacterArray = _trackMutableArray;
    } else if ([[segue identifier] isEqualToString:@"searchToCharacterSegue"]) {
        CharacterViewController *charController = [segue destinationViewController];
        charController.currentCharacter = _trackMutableArray[0];
        NSLog(@"Sending %@",[charController.currentCharacter objectForKey:@"name"]);
    } else if ([[segue identifier] isEqualToString:@"segueToTrivia"]) {
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _hyperSpaceImage.image = [UIImage imageNamed:@"hyperspace.jpg"];
    _triviaImage.image = [UIImage imageNamed:@"trivia.jpg"];
    _charactersImage.image = [UIImage imageNamed:@"characters.jpg"];
    _yodaImage.image = [UIImage imageNamed:@"Yoda.png"];
    _darthMaulImage.image = [UIImage imageNamed:@"DarthMaul.png"];
    _lukeSkywalkerImage.image = [UIImage imageNamed:@"LukeSkywalker.jpg"];
    _padmeImage.image = [UIImage imageNamed:@"Padme.jpg"];
    _hanSoloImage.image = [UIImage imageNamed:@"Hansolo.jpg"];
    _chewieImage.image = [UIImage imageNamed:@"Chewie.jpg"];
    _hostName = @"www.moveablebytes.com";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    hostReach = [Reachability reachabilityWithHostName:_hostName];
    [hostReach startNotifier];
    [self updateReachablityStatus:hostReach];
    internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    [self updateReachablityStatus:internetReach];

    _trackMutableArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
