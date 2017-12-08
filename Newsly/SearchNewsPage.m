//
//  SearchNewsPage.m
//  Newsly
//
//  Created by Ruyin Shao on 12/3/17.
//  Copyright © 2017 Ruyin Shao. All rights reserved.
//

#import "SearchNewsPage.h"

@interface SearchNewsPage ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
//UI Elements

@property (weak, nonatomic) IBOutlet UITextField *keywordTF;
@property (weak, nonatomic) IBOutlet UITextField *sortedByTF;
@property (weak, nonatomic) IBOutlet UITextField *sourcesTF;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneBarButton;

@property UIPickerView *sourceListPicker;
@property UIPickerView *sortedByListPicker;

//data sources
@property (strong, nonatomic) NSMutableArray* sourcesList;
@property (strong, nonatomic) NSMutableArray* sortedByList;

@end

@implementation SearchNewsPage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize source array
    self.sourcesList = [[NSMutableArray alloc] initWithObjects:@"",@"business-insider",@"bloomberg",@"bbc-news",@"abc-news",@"cnn",@"cbs-news",@"buzzfeed", @"fox-news",@"reddit-r-all",@"the-new-york-times",@"time",@"the-wall-street-journal",@"usa-today",@"the-economist",nil];
    //initialize sortedBy array
    self.sortedByList = [[NSMutableArray alloc] initWithObjects:@"",@"relevancy" ,@"popularity",@"publishedAt",nil];
    
    //set up 2 picker views
    self.sourceListPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, 40, 200, 220)];
    self.sourceListPicker.delegate = self;
    self.sourceListPicker.dataSource = self;
    self.sourceListPicker.showsSelectionIndicator = YES;
    self.sourcesTF.inputView = self.sourceListPicker;
    
    self.sortedByListPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(5, 40, 200, 220)];
    self.sortedByListPicker.delegate = self;
    self.sortedByListPicker.dataSource = self;
    self.sortedByListPicker.showsSelectionIndicator = YES;
    self.sortedByTF.inputView = self.sortedByListPicker;
    
    // add a toolbar with Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    
    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    self.sourcesTF.inputAccessoryView = toolBar;
    self.sortedByTF.inputAccessoryView = toolBar;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)dismissKeyboard:(id)sender {
    [sender resignFirstResponder];
}

- (void)doneTouched:(id)sender{
   [self.sortedByTF endEditing:YES];
    [self.sourcesTF endEditing:YES];
}

- (IBAction)sendSearchRequest:(id)sender {
    if (self.goSearchNews){
        self.goSearchNews(self.keywordTF.text, self.sortedByTF.text, self.sourcesTF.text);
    }
    
    self.keywordTF.text = nil;
    self.sortedByTF.text = nil;
    self.sourcesTF.text = nil;
}

- (IBAction)cancelRequest:(id)sender {
    if (self.goSearchNews){
        self.goSearchNews(nil, nil, nil);
    }
    self.keywordTF.text = nil;
    self.sortedByTF.text = nil;
    self.sourcesTF.text = nil;

}

#pragma mark - UIPickerViewDataSource
// #3
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// #4
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.sortedByListPicker) {
        return [self.sortedByList count];
    }
    else if (pickerView == self.sourceListPicker){
        return [self.sourcesList count];
    }
    
    return 0;
}

#pragma mark - UIPickerViewDelegate

// #5
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.sortedByListPicker) {
        return self.sortedByList[row];
    }
    else if (pickerView == self.sourceListPicker){
        return self.sourcesList[row];
    }
    
    return nil;
}

// #6
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.sortedByListPicker) {
        self.sortedByTF.text =  self.sortedByList[row];
    }
    else if (pickerView == self.sourceListPicker){
        self.sourcesTF.text =  self.sourcesList[row];
    }
    
}


#pragma mark - textfield delegate method

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // detect to enable done button when there's something in keyword textfield
    NSString *changedString = [textField.text stringByReplacingCharactersInRange:range
                                                                      withString:string];
    [self enableSaveButtonForKeyword:changedString];
    
    return YES;
}


#pragma mark - helper methods

// Enabled the save button when data is in keyword
- (void) enableSaveButtonForKeyword: (NSString *) keyword{
    
    self.doneBarButton.enabled = (keyword.length > 0);
    
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
