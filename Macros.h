UIAlertView *a;

#define alert(x, y, z) a = [[UIAlertView alloc] initWithTitle:x message:y delegate:self cancelButtonTitle:z otherButtonTitles:nil]; \
[a show]; \

#define timer(sec) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, sec * NSEC_PER_SEC), dispatch_get_main_queue(), ^ 

#define to_ns_str(cStr) [NSString stringWithCString:cStr encoding:NSUTF8StringEncoding]

#define PLIST_PATH @"/var/mobile/Library/Preferences/com.shmoo.bulletforcemodmenu.plist"

#define rgb(rgbValue) [UIColor \
 colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

inline bool GetPrefBool(NSString *key) {
                return [[[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key] boolValue];
}

#define hide(type,name,value) __attribute__((visibility("hidden"))) type name = value;

OBJC_EXTERN CFStringRef MGCopyAnswer(CFStringRef key) WEAK_IMPORT_ATTRIBUTE;
