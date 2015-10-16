//
//  CharacterViewController.m
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import "CharacterViewController.h"
#import "AppDelegate.h"

@interface CharacterViewController ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *speciesLabel;
@property (nonatomic, strong) IBOutlet UILabel *genderLabel;
@property (nonatomic, strong) IBOutlet UILabel *homeworldLabel;
@property (nonatomic, strong) IBOutlet UILabel *preludeLabel;
@property (nonatomic, strong) AppDelegate      *appDelegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation CharacterViewController
#pragma mark - Load Image Methods

- (void)gotImage  {
    NSLog(@"got image");
//    _imageView.image =
}


#pragma mark - Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    _nameLabel.text = [_currentCharacter objectForKey:@"name"];
    _speciesLabel.text = [_currentCharacter objectForKey:@"species"];
    _genderLabel.text = [_currentCharacter objectForKey:@"gender"];
    _homeworldLabel.text = [_currentCharacter objectForKey:@"homeworld"];
    _preludeLabel.text = [_currentCharacter objectForKey:@"prelude"];
    NSString *urlString = [_currentCharacter objectForKey:@"image_url"];
    NSURL *urlPath = [NSURL URLWithString:urlString];
    NSString *fileName = [urlPath lastPathComponent];
    
    if ([_appDelegate fileIsLocal:fileName]) {
        NSLog(@"LOCAAALLLLLLLLLŁ");
        //characterCell.imageView = [UIImage imageNamed:[[_appDelegate getDocumentsDirectory] stringByAppendingPathComponent:fileName]];
        _imageView.image = [UIImage imageNamed:[[_appDelegate getDocumentsDirectory] stringByAppendingPathComponent:fileName]];
    } else {
        //NSLog(@"not local %@",fileName);
        NSLog(@"not local");
        [_appDelegate getImageFromServer:fileName fromUrl:urlString atIndexPath:nil checkTableView:false withTableView:nil];
    }
   // _imageView.image = [];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotImage) name:@"getImageNotfiation" object:nil];
    NSLog(@"Recv %@",[_currentCharacter objectForKey:@"name"]);
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
