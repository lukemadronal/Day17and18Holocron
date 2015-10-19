//
//  TriviaViewController.m
//  iForce
//
//  Created by Luke Madronal on 10/16/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import "TriviaViewController.h"
#import "AppDelegate.h"

@interface TriviaViewController ()

@property(nonatomic,weak) IBOutlet UITextView  *questionTextView;
@property(nonatomic,weak) IBOutlet UILabel     *scoreLabel;
@property(nonatomic,weak) IBOutlet UITextField *answerTextField;
@property (nonatomic, strong) AppDelegate      *appDelegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *tropperRightImageView;
@property (nonatomic, strong) IBOutlet UIImageView *tropperLeftImageView;
@end

@implementation TriviaViewController

- (void)gotImage  {
    NSLog(@"got image");
    //    _imageView.image =
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tropperLeftImageView.image = [UIImage imageNamed:@"stormtrooper.jpg"];
    _tropperRightImageView.image = [UIImage imageNamed:@"stormtrooper.jpg"];
    
    NSString *urlString = [_currentCharacter objectForKey:@"image_url"];
    NSURL *urlPath = [NSURL URLWithString:urlString];
    NSString *fileName = [urlPath lastPathComponent];
    
    if ([_appDelegate fileIsLocal:fileName]) {
        _imageView.image = [UIImage imageNamed:[[_appDelegate getDocumentsDirectory] stringByAppendingPathComponent:fileName]];
    } else {
        [_appDelegate getImageFromServer:fileName fromUrl:urlString atIndexPath:nil checkTableView:false withTableView:nil];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotImage) name:@"getImageNotfiation" object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
