//
//  CharacterViewController.m
//  iForce
//
//  Created by Luke Madronal on 10/15/15.
//  Copyright © 2015 Luke Madronal. All rights reserved.
//

#import "CharacterViewController.h"

@interface CharacterViewController ()

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *speciesLabel;
@property (nonatomic, strong) IBOutlet UILabel *genderLabel;
@property (nonatomic, strong) IBOutlet UILabel *homeworldLabel;
@property (nonatomic, strong) IBOutlet UILabel *preludeLabel;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end

@implementation CharacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nameLabel.text = [_currentCharacterArray[0] objectForKey:@"name"];
    _speciesLabel.text = [_currentCharacterArray[0] objectForKey:@"species"];
    _genderLabel.text = [_currentCharacterArray[0] objectForKey:@"gender"];
    _homeworldLabel.text = [_currentCharacterArray[0] objectForKey:@"homeworld"];
    _preludeLabel.text = [_currentCharacterArray[0] objectForKey:@"prelude"];
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
