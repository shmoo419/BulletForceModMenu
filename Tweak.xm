#import <UIKit/UIKit.h>
#import "vm_writeData.h"
#import "Macros.h"

void makeZeroXLabel(CGFloat, CGFloat, CGFloat, CGFloat);

int menuCreationCount = 0;

//Floats go to 0.0 when used as parameters for Objective-C methods on my phone, but not in the simulator. WTF
float labelSpacing = 5.0;
float switchSpacing = 0.5;
float miscellaneousTypeSpacing = 8.0;

float labelXValue = 8.0;
float labelWidth = 270.0;
float labelHeight = 21.0;

float switchXValue = 319.0;
float switchWidth = 51.0;
float switchHeight = 31.0;

float bulletTypeAndGrenadeTypeXValue = 102.0;
float bulletTypeAndGrenadeTypeWidth = 173.0;
float bulletTypeAndGrenadeTypeHeight = 30.0;

NSArray *labelArray;
NSArray *bulletArray;
NSArray *grenadeArray;
NSArray *killstreakArray;
NSArray *weaponPickupArray;

NSUserDefaults *defaults;

UIBlurEffect *blurEffect;

UIButton *closeMenu;
UIButton *set;

UIButton *bulletType;
UIButton *grenadeType;
UIButton *killstreakType;
UIButton *weaponPickupType;
UIButton *bulletChooserButton;

UIView *main;

UIView *closeButtonBackgroundView;
UIView *separator;
UIView *mainMenuView;

UILabel *writeToOffset;
UILabel *zeroX;
UILabel *typeStatus;

UIScrollView *normalModsScrollView;
UIScrollView *otherModsScrollView;
UIScrollView *bulletTypeScrollView;
UIScrollView *grenadeTypeScrollView;
UIScrollView *killstreakTypeScrollView;
UIScrollView *weaponPickupTypeScrollView;

UISegmentedControl *pageSelector;

UITextField *offsetTextField;
UITextField *hexTextField;

uint64_t offsetArray[24] = {/*removed*/};
uint64_t moddedHexArray[21] = {/*removed*/};
uint64_t originalHexArray[24] = {/*removed*/};
uint64_t chooserHexes[32] = {/*removed*/};
uint64_t weaponPickupHexArray[21] = {/*removed*/};

%hook UnityAppController

- (void)applicationDidBecomeActive:(id)arg0 {
main = [UIApplication sharedApplication].keyWindow.rootViewController.view;

bulletChooserButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
bulletChooserButton.frame = CGRectMake((main.frame.size.width/2)-15,(main.frame.size.height/2)+75,30,30);
bulletChooserButton.backgroundColor = [UIColor clearColor];
bulletChooserButton.layer.cornerRadius = 16;
bulletChooserButton.layer.borderWidth = 2.0f;
bulletChooserButton.layer.borderColor = rgb(0xaa0114).CGColor;
[bulletChooserButton addTarget:self action:@selector(showMenu) 
forControlEvents:UIControlEventTouchDragInside];
[main addSubview:bulletChooserButton];

%orig;
}

%new
- (void)showMenu {
    defaults = [NSUserDefaults standardUserDefaults];
    
    if(menuCreationCount == 0){
        [self setupMenuGUI];
        [self setupSwitchesAndLabels];
        [self setupOtherModsSection];
        [self setupBulletTypeSection];
        [self setupGrenadeTypeSection];
        [self setupKillstreakTypeSection];
        [self setupWeaponPickupTypeSection];
        [self setupCloseButtonStuff];
    }
    
    menuCreationCount++;
}

%new
- (void)setupOtherModsSection {
    otherModsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 83, 376, 184)];
    otherModsScrollView.backgroundColor = [UIColor clearColor];
    otherModsScrollView.contentSize = CGSizeMake(376, 0);
    otherModsScrollView.hidden = true;
    [mainMenuView addSubview:otherModsScrollView];
    
    bulletType = [UIButton buttonWithType:UIButtonTypeCustom];
    bulletType.frame = CGRectMake(127, 8, 123, 30);
    bulletType.backgroundColor = [UIColor clearColor];
    bulletType.tag = 500;
    bulletType.titleLabel.textAlignment = NSTextAlignmentCenter;
    [bulletType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bulletType setTitle:@"Bullet Type" forState:UIControlStateNormal];
    [bulletType addTarget:self action:@selector(showSpecificViewForChooserSection:) forControlEvents:UIControlEventTouchDown];
    [otherModsScrollView addSubview:bulletType];
    
    grenadeType = [UIButton buttonWithType:UIButtonTypeCustom];
    grenadeType.frame = CGRectMake(101, 46, 175, 30);
    grenadeType.backgroundColor = [UIColor clearColor];
    grenadeType.tag = 501;
    grenadeType.titleLabel.textAlignment = NSTextAlignmentCenter;
    [grenadeType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [grenadeType setTitle:@"Grenade Type" forState:UIControlStateNormal];
    [grenadeType addTarget:self action:@selector(showSpecificViewForChooserSection:) forControlEvents:UIControlEventTouchDown];
    [otherModsScrollView addSubview:grenadeType];
    
    killstreakType = [UIButton buttonWithType:UIButtonTypeCustom];
    killstreakType.frame = CGRectMake(95, 84, 187, 30);
    killstreakType.backgroundColor = [UIColor clearColor];
    killstreakType.tag = 502;
    killstreakType.titleLabel.textAlignment = NSTextAlignmentCenter;
    [killstreakType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [killstreakType setTitle:@"Killstreak Type" forState:UIControlStateNormal];
    [killstreakType addTarget:self action:@selector(showSpecificViewForChooserSection:) forControlEvents:UIControlEventTouchDown];
    [otherModsScrollView addSubview:killstreakType];
    
    weaponPickupType = [UIButton buttonWithType:UIButtonTypeCustom];
    weaponPickupType.frame = CGRectMake(69, 122, 239, 30);
    weaponPickupType.backgroundColor = [UIColor clearColor];
    weaponPickupType.tag = 503;
    weaponPickupType.titleLabel.textAlignment = NSTextAlignmentCenter;
    [weaponPickupType setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [weaponPickupType setTitle:@"Weapon Pickup Type" forState:UIControlStateNormal];
    [weaponPickupType addTarget:self action:@selector(showSpecificViewForChooserSection:) forControlEvents:UIControlEventTouchDown];
    [otherModsScrollView addSubview:weaponPickupType];
}

%new
- (void)setupBulletTypeSection {
    bulletTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 73, 376, 184)];
    bulletTypeScrollView.backgroundColor = [UIColor clearColor];
    bulletTypeScrollView.contentSize = CGSizeMake(376, 640);
    bulletTypeScrollView.hidden = true;
    [mainMenuView addSubview:bulletTypeScrollView];
    
    [self setupBulletTypeButtons];
}

%new
- (void)setupGrenadeTypeSection {
    grenadeTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 73, 376, 184)];
    grenadeTypeScrollView.backgroundColor = [UIColor clearColor];
    grenadeTypeScrollView.contentSize = CGSizeMake(376, 0);
    grenadeTypeScrollView.hidden = true;
    [mainMenuView addSubview:grenadeTypeScrollView];
    
    [self setupGrenadeTypeButtons];
}

%new
- (void)setupKillstreakTypeSection {
    killstreakTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 73, 376, 184)];
    killstreakTypeScrollView.backgroundColor = [UIColor clearColor];
    killstreakTypeScrollView.contentSize = CGSizeMake(376, 220);
    killstreakTypeScrollView.hidden = true;
    [mainMenuView addSubview:killstreakTypeScrollView];
    
    [self setupKillstreakTypeButtons];
}

%new
- (void)setupWeaponPickupTypeSection {
    weaponPickupTypeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 73, 376, 184)];
    weaponPickupTypeScrollView.backgroundColor = [UIColor clearColor];
    weaponPickupTypeScrollView.contentSize = CGSizeMake(376, 640);
    weaponPickupTypeScrollView.hidden = true;
    [mainMenuView addSubview:weaponPickupTypeScrollView];
    
    [self setupWeaponPickupTypeButtons];
}

%new
- (void)setupSwitchesAndLabels {
    labelArray = @[@"No Recoil", @"Better Aim", @"Infinite Ammo", @"Modded Gravity", @"Anti Flashbang", @"Everyone Orange", @"Crosshairs Always Enabled", @"25555.0 Pickup Range", @"Sniper Light Shows Through Walls", @"Knife Button Always Shows", @"Knife Faster", @"Debug Rechamber Animation", @"Instant Reload", @"God Mode Lobby", @"Always Headshot", @"All Camos", @"Killstreaks Ready", @"Deaths Don't Count", @"Instant Grenade Explosion", @"Modded Fire Rate", @"Auto Fire", @"Shoot Through Walls", @"One Hit Kill", @"No Killstreak Wait"];
    
    UISwitch *s;
    
    for(int i=0; i<[labelArray count]; i++){
        [normalModsScrollView addSubview:[self makeHackLabel:labelArray[i]]];
        
        s = [self makeHackSwitch:i];
        
        [normalModsScrollView addSubview:s];
        [self setSwitchStateBasedOnPrefs:i withSwitch:s];
        
        if([defaults boolForKey:[NSString stringWithFormat:@"%d", (int)s.tag]]){
            [self switchToggled:s];
        }
    }
}

%new
- (void)setupBulletTypeButtons {
    bulletArray = @[@"Original", @"M4A1", @"Famas", @"AK 12", @"SCAR-H", @"MP5", @"870 MCS", @"M40A5", @"MPX", @"SAIGA 12K", @"MG4", @"AS VAL", @"RPG", @"M200", @"Compact .45", @"MP412 REX", @"M320 HE", @"M320 DART", @"Hand", @"Butterfly Knife", @"G18"];
    
    for(int i=0; i<[bulletArray count]; i++){
        [bulletTypeScrollView addSubview:[self makeTypeChooserButton:bulletArray[i] withTag:i]];
    }
}

%new
- (void)setupGrenadeTypeButtons {
    miscellaneousTypeSpacing = 8.0;
    
    grenadeArray = @[@"Original", @"Frag Grenade", @"Smoke Grenade", @"Flashbang"];
    
    int bulletArrayLength = (int)[bulletArray count];
    
    for(int i=0; i<[grenadeArray count]; i++){
        [grenadeTypeScrollView addSubview:[self makeTypeChooserButton:grenadeArray[i] withTag:i+bulletArrayLength]];
    }
}

%new
- (void)setupKillstreakTypeButtons {
    miscellaneousTypeSpacing = 8.0;
    
    killstreakArray = @[@"Original", @"UAV", @"Super Solider", @"Counter UAV", @"Advanced UAV", @"Haste", @"Nuke"];
    
    int tagBase = (int)[bulletArray count]+(int)[grenadeArray count];
    
    for(int i=0; i<[killstreakArray count]; i++){
        [killstreakTypeScrollView addSubview:[self makeTypeChooserButton:killstreakArray[i] withTag:i+tagBase]];
    }
}

%new
- (void)setupWeaponPickupTypeButtons {
    miscellaneousTypeSpacing = 8.0;
    
    int tagBase = (int)[bulletArray count]+(int)[grenadeArray count]+(int)[killstreakArray count];
    
    for(int i=0; i<[bulletArray count]; i++){
        [weaponPickupTypeScrollView addSubview:[self makeTypeChooserButton:bulletArray[i] withTag:i+tagBase]];
    }
}

%new
- (void)setupMenuGUI {
    //I get away with hardcoding frame values because I'm the only one using this menu
    mainMenuView = [[UIView alloc] initWithFrame:CGRectMake(145, 44, 376, 286)];
    mainMenuView.backgroundColor = [UIColor whiteColor];
    mainMenuView.alpha = 0.7;
    mainMenuView.layer.cornerRadius = 5;
    mainMenuView.layer.borderColor = rgb(0xaa0114).CGColor;
    mainMenuView.layer.borderWidth = 1;
    [main addSubview:mainMenuView];
    
    writeToOffset = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 376, 19)];
    writeToOffset.text = @"Write To A Custom Offset";
    writeToOffset.textAlignment = NSTextAlignmentCenter;
    [writeToOffset setFont:[UIFont systemFontOfSize:12]];
    [mainMenuView addSubview:writeToOffset];
    
    makeZeroXLabel(8, 28, 22, 21);
    [mainMenuView addSubview:zeroX];
    
    makeZeroXLabel(205, 28, 22, 21);
    [mainMenuView addSubview:zeroX];
    
    offsetTextField = [[UITextField alloc] initWithFrame:CGRectMake(29, 24, 140, 30)];
    offsetTextField.placeholder = @"OFFSET";
    offsetTextField.returnKeyType = UIReturnKeyDone;
    offsetTextField.tag = 0;
    [mainMenuView addSubview:offsetTextField];
    
    hexTextField = [[UITextField alloc] initWithFrame:CGRectMake(228, 24, 140, 30)];
    hexTextField.placeholder = @"HEX";
    hexTextField.returnKeyType = UIReturnKeyDone;
    hexTextField.tag = 1;
    [mainMenuView addSubview:hexTextField];
    
    set = [UIButton buttonWithType:UIButtonTypeCustom];
    set.frame = CGRectMake(157, 51, 63, 26);
    set.backgroundColor = [UIColor clearColor];
    [set setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [set setTitle:@"Set" forState:UIControlStateNormal];
    [set addTarget:self action:@selector(writeToCustomOffset) forControlEvents:UIControlEventTouchDown];
    [mainMenuView addSubview:set];
    
    pageSelector = [[UISegmentedControl alloc] initWithItems:@[@"Normal Mods", @"Other Mods"]];
    pageSelector.frame = CGRectMake(87, 257, 289, 29);
    pageSelector.tintColor = rgb(0xaa0114);
    [pageSelector setSelectedSegmentIndex:0];
    [pageSelector addTarget:self
                     action:@selector(changeView:)
           forControlEvents:UIControlEventValueChanged];
    [mainMenuView addSubview:pageSelector];
    
    normalModsScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 73, 376, 184)];
    normalModsScrollView.backgroundColor = [UIColor clearColor];
    normalModsScrollView.contentSize = CGSizeMake(376, 730);
    [mainMenuView addSubview:normalModsScrollView];
}

%new
- (void)setupCloseButtonStuff {
    separator = [[UIView alloc] initWithFrame:CGRectMake(0, 73, 376, 1)];
    separator.backgroundColor = [UIColor blackColor];
    [mainMenuView addSubview:separator];
    
    closeButtonBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 257, 87, 28)];
    closeButtonBackgroundView.backgroundColor = rgb(0xaa0114);
    closeButtonBackgroundView.layer.cornerRadius = 2;
    [mainMenuView addSubview:closeButtonBackgroundView];
    
    closeMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    closeMenu.frame = CGRectMake(0, 257, 87, 30);
    closeMenu.backgroundColor = [UIColor clearColor];
    closeMenu.titleLabel.textAlignment = NSTextAlignmentCenter;
    [closeMenu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [closeMenu setTitle:@"Close" forState:UIControlStateNormal];
    [closeMenu addTarget:self action:@selector(closeModMenu) forControlEvents:UIControlEventTouchDown];
    [mainMenuView addSubview:closeMenu];
}

%new
- (void)setSwitchStateBasedOnPrefs:(int)tag withSwitch:(UISwitch *)s {
    //Instead of creating tons of unique keys for switches, why not just use the switch tag?
    s.on = [defaults boolForKey:[NSString stringWithFormat:@"%d", tag]];
}

%new
- (void)switchToggled:(UISwitch *)sender {
    int switchTag = (int)sender.tag;
    bool isOn = sender.on;

    //If you haven't already guessed, the button tag corresponds to the feature in the labelArray, and the index of that is the same as the index in the offsetArray and the moddedHexArray.
    
    //Custom calls to writeData because always headshot, instant reload, and one hit kill needed more than one offset.
    //I tried to keep it all in the arrays but it became a big mess of if statements.
    if(switchTag == 12){
        if(isOn){
            /*removed*/
        }
        else{
            /*removed*/
        }
    }
    else if(switchTag == 13){
        if(isOn){
            write(offsetArray[switchTag-1], moddedHexArray[switchTag-1]);
        }
        else{
            write(offsetArray[switchTag-1], originalHexArray[switchTag-1]);
        }
    }
    else if(switchTag == 14){
        if(isOn){
            /*removed*/
        }
        else{
            /*removed*/
        }
    }
    else if(switchTag == 22){
        if(isOn){
            /*removed*/
        }
        else{
            /*removed*/
        }
    }
    else{
        if(switchTag > 14){
            if(isOn){
                write(offsetArray[switchTag-2], moddedHexArray[switchTag-2]);
            }
            else{
                write(offsetArray[switchTag-2], originalHexArray[switchTag-2]);
            }
        }
        else{
            if(isOn){
                write(offsetArray[switchTag], moddedHexArray[switchTag]);
            }
            else{
                write(offsetArray[switchTag], originalHexArray[switchTag]);
            }
        }
    }
    
    //Again, much better to use the switch tag as a key for small projects like this, in my opinion.
    [defaults setBool:isOn forKey:[NSString stringWithFormat:@"%d", (int)sender.tag]];
}

%new
- (void)changeView:(UISegmentedControl *)sender {
    [self showViewBasedOnSelectedIndex:(int)pageSelector.selectedSegmentIndex];
}

%new
- (void)writeToCustomOffset {
    [offsetTextField resignFirstResponder];
    [hexTextField resignFirstResponder];
    
    write([offsetTextField.text longLongValue], [hexTextField.text longLongValue]);
    
    offsetTextField.text = @"";
    hexTextField.text = @"";
}

%new
- (void)showSpecificViewForChooserSection:(UIButton *)button {
    otherModsScrollView.hidden = true;
    
    int buttonTag = (int)button.tag;
    
    if(buttonTag == 500){
        bulletTypeScrollView.hidden = false;
        
        [self modifyCloseButtonSelector:false];
    }
    else if(buttonTag == 501){
        grenadeTypeScrollView.hidden = false;
        
        [self modifyCloseButtonSelector:false];
    }
    else if(buttonTag == 502){
        killstreakTypeScrollView.hidden = false;
        
        [self modifyCloseButtonSelector:false];
    }
    else{
        weaponPickupTypeScrollView.hidden = false;
        
        [self modifyCloseButtonSelector:false];
    }
}

%new
- (void)applyTypeChooserHack:(UIButton *)button {
    [typeStatus removeFromSuperview];
    
    int buttonTag = (int)button.tag;
    
    NSAttributedString *typeStatusBold;
    NSString *text;
    
    if(buttonTag>20 && buttonTag<25){
        write(/*removed*/, chooserHexes[buttonTag]);
        
        text = [NSString stringWithFormat:@"Grenade type changed to %@", button.titleLabel.text];
    }
    else if(buttonTag>24 && buttonTag<32){
        write(/*removed*/, chooserHexes[buttonTag]);
        
        text = [NSString stringWithFormat:@"Killstreak type changed to %@", button.titleLabel.text];
    }
    else if(buttonTag>31){
        write(/*removed*/, weaponPickupHexArray[buttonTag-32]);
        
        text = [NSString stringWithFormat:@"Pickup gun changed to %@", button.titleLabel.text];
    }
    else{
        write(/*removed*/, chooserHexes[buttonTag]);
        
        text = [NSString stringWithFormat:@"Bullet type changed to %@", button.titleLabel.text];
    }
    
    typeStatus = [[UILabel alloc] initWithFrame:CGRectMake(134, 6, 399, 21)];
    typeStatus.textColor = rgb(0x228b22);
    typeStatus.backgroundColor = [UIColor blackColor];
    typeStatus.layer.cornerRadius = 5;
    typeStatus.alpha = 0.9;
    typeStatus.textAlignment = NSTextAlignmentCenter;
    typeStatusBold = [[NSAttributedString alloc] initWithString:text
                                                     attributes:@{ NSFontAttributeName: [UIFont boldSystemFontOfSize:18.0] }];
    typeStatus.attributedText = typeStatusBold;
    
    [main addSubview:typeStatus];
    
    [self performSelector:@selector(removeLabel) withObject:@NO afterDelay:3];
}

%new
- (void)showViewBasedOnSelectedIndex:(int)index {
    if(index == 0){
        normalModsScrollView.hidden = false;
        bulletTypeScrollView.hidden = true;
        grenadeTypeScrollView.hidden = true;
        otherModsScrollView.hidden = true;
        killstreakTypeScrollView.hidden = true;
        weaponPickupTypeScrollView.hidden = true;
        
        [self modifyCloseButtonSelector:true];
    }
    else{
        normalModsScrollView.hidden = true;
        otherModsScrollView.hidden = false;
    }
}

%new
- (void)goBackToOtherModsView {
    otherModsScrollView.hidden = false;
    bulletTypeScrollView.hidden = true;
    grenadeTypeScrollView.hidden = true;
    killstreakTypeScrollView.hidden = true;
    weaponPickupTypeScrollView.hidden = true;
    
    [self modifyCloseButtonSelector:true];
}

%new
- (UIButton *)makeTypeChooserButton:(NSString *)title withTag:(int)tag {
    UIButton *toReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    toReturn.frame = CGRectMake(bulletTypeAndGrenadeTypeXValue, miscellaneousTypeSpacing, bulletTypeAndGrenadeTypeWidth, bulletTypeAndGrenadeTypeHeight);
    toReturn.backgroundColor = [UIColor clearColor];
    toReturn.tag = tag;
    [toReturn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [toReturn setTitle:title forState:UIControlStateNormal];
    [toReturn addTarget:self action:@selector(applyTypeChooserHack:) forControlEvents:UIControlEventTouchDown];
    
    miscellaneousTypeSpacing+=30.0f;
    
    return toReturn;
}

%new
- (UISwitch *)makeHackSwitch:(int)tag {
    UISwitch *toReturn = [[UISwitch alloc] initWithFrame:CGRectMake(switchXValue, switchSpacing, switchWidth, switchHeight)];
    toReturn.transform = CGAffineTransformMakeScale(0.5, 0.5);
    toReturn.onTintColor = rgb(0x228b28);
    toReturn.tag = tag;
    [toReturn addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    
    switchSpacing+=30.0f;
    
    return toReturn;
}

%new
- (UILabel *)makeHackLabel:(NSString *)text {
    UILabel *toReturn = [[UILabel alloc] initWithFrame:CGRectMake(labelXValue, labelSpacing, labelWidth, labelHeight)];
    toReturn.text = text;
    
    labelSpacing+=30.0f;
    
    return toReturn;
}


//Helper method to avoid rewriting the same code four times
%new
- (void)modifyCloseButtonSelector:(bool)isGoingBack {
    if(isGoingBack){
        closeMenu.titleLabel.text = @"Close";
        [closeMenu removeTarget:self action:@selector(goBackToOtherModsView) forControlEvents:UIControlEventTouchDown];
        [closeMenu addTarget:self action:@selector(closeModMenu) forControlEvents:UIControlEventTouchDown];
    }
    else{
        closeMenu.titleLabel.text = @"Back";
        [closeMenu removeTarget:self action:@selector(closeModMenu) forControlEvents:UIControlEventTouchDown];
        [closeMenu addTarget:self action:@selector(goBackToOtherModsView) forControlEvents:UIControlEventTouchDown];
    }
}

%new
- (void)removeLabel {
    [typeStatus removeFromSuperview];
}

%new
- (void)closeModMenu {
    menuCreationCount = 0;
    labelSpacing = 5.0;
    switchSpacing = 0.5;
    miscellaneousTypeSpacing = 8.0;

    [mainMenuView removeFromSuperview];
}
%end

void makeZeroXLabel(CGFloat x, CGFloat y, CGFloat w, CGFloat h){
    zeroX = [[UILabel alloc] initWithFrame:CGRectMake(x, y, w, h)];
    zeroX.text = @"0x";
}
