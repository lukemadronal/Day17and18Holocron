//
//  SearchResultsViewController.m
//  iForce
//
//  Created by Luke Madronal on 10/16/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "TriviaViewController.h"
#import "CharacterViewController.h"

#import "AppDelegate.h"

@interface SearchResultsViewController ()

@property (nonatomic, strong) AppDelegate       *appDelegate;
@property (nonatomic,weak) IBOutlet UITableView *searchResultsTableView;

@end

@implementation SearchResultsViewController

- (void)gotImage {
    NSLog(@"got image");
    [_searchResultsTableView reloadData];
}

#pragma mark - Network Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentCharacterArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    UITableViewCell *characterCell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"characterCell"];
    NSDictionary *trackDict = _currentCharacterArray[indexPath.row];
    characterCell.textLabel.text = [trackDict objectForKey:@"name"];
    characterCell.detailTextLabel.text = [trackDict objectForKey:@"homeworld"];
    NSLog(@"this is the last thing that i printed");
    NSString *urlString = [_currentCharacterArray[indexPath.row] objectForKey:@"image_url"];
    NSURL *urlPath = [NSURL URLWithString:urlString];
    NSString *fileName = [urlPath lastPathComponent];
    
    if ([_appDelegate fileIsLocal:fileName]) {
        NSLog(@"LOCAAALLLLLLLLLŁ");
        //characterCell.imageView = [UIImage imageNamed:[[_appDelegate getDocumentsDirectory] stringByAppendingPathComponent:fileName]];
        characterCell.imageView.image = [UIImage imageNamed:[[_appDelegate getDocumentsDirectory] stringByAppendingPathComponent:fileName]];
    } else {
        //NSLog(@"not local %@",fileName);
        NSLog(@"not local");
        [_appDelegate getImageFromServer:fileName fromUrl:urlString atIndexPath:nil checkTableView:false withTableView:nil];
    }
    // _imageView.image = [];
    return characterCell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"searchResultsToCharacterSegue"]) {
        CharacterViewController *charController = [segue destinationViewController];
        NSIndexPath *indexPath = [_searchResultsTableView indexPathForSelectedRow];
        charController.currentCharacter = _currentCharacterArray[indexPath.row];
    }
    
}



#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotImage) name:@"gotImageNotification" object:nil];
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
