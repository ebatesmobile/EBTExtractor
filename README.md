# PPExtractor
An Objective-C type coercion helper for JSON-derived dictionaries.

Deserializing JSON gives no assurance about what values exist and what type they’ve been deserializing as. Sometimes the type of object a server returns isn't convenient for your purposes.

PPExtractor promises that information from a server remains predictable and can used without further inspection. This promise is fulfilled by type coercion and basic value cleanup.

## Usage
- Create a `PPExtractor` with a `NSDictionary`.
- Use the type-specific methods to retrieve a value of that type.

### Example

```objc
NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];

PPExtractor *extractor = [PPExtractor extractorWithDictionary:response];

NSInteger identifier = [extractor integerWithKey:@"id"];
NSString *name = [extractor stringWithKey:@"name"];
NSDecimalNumber *rating = [extractor decimalNumberWithKey:@"rating"];
NSArray *friendIDs = [extractor arrayOfNumbersForKey:@"friends"];
```

## Conversion Tables

These tables provide examples of what values that are literally in a dictionary could be converted to.

**Note:** The sample return values may be shortened for clarity. For example, `NSDecimalNumber` instances may not be created with `decimalNumberWithString:` but when they are, the locale is always specified as `[NSLocale systemLocale]`.

### `[NSNumber numberWithInteger:5]`
Methods                | Return Value
----------------------:|:-------------
boolForKey:            | `YES`
integerForKey:         | `5`
unsignedIntegerForKey: | `5`
dateForKey:            | `[NSDate dateWithTimeIntervalSince1970:5]`
numberForKey:          | `[NSNumber numberWithInteger:5]`
stringForKey:          | `@"5"`
decimalNumberForKey:   | `[NSDecimalNumber decimalNumberWithString:@"5"]`
arrayForKey:           | `nil`
dictionaryForKey:      | `nil`
extractorForKey:       | `nil`

### `@"Applejacks"`
Methods                | Return Value
----------------------:|:-------------
boolForKey:            | `NO`
integerForKey:         | `0`
unsignedIntegerForKey: | `0`
dateForKey:            | `nil`
numberForKey:          | `nil`
stringForKey:          | `@"Applejacks"`
decimalNumberForKey:   | `nil`
arrayForKey:           | `nil`
dictionaryForKey:      | `nil`
extractorForKey:       | `nil`


### `@"the 21.5 slices"`
Methods                | Return Value
----------------------:|:-------------
boolForKey:            | `YES`
integerForKey:         | `21`
unsignedIntegerForKey: | `21`
dateForKey:            | `[NSDate dateWithTimeIntervalSince1970:21]`
numberForKey:          | `[NSNumber numberWithInteger:21]`
stringForKey:          | `@"the 21.5 slices"`
decimalNumberForKey:   | `[NSDecimalNumber decimalNumberWithString:@"21.5"]`
arrayForKey:           | `nil`
dictionaryForKey:      | `nil`
extractorForKey:       | `nil`

### `[NSNull null]`
Methods                | Return Value
----------------------:|:-------------
boolForKey:            | `NO`
integerForKey:         | `0`
unsignedIntegerForKey: | `0`
dateForKey:            | `nil`
numberForKey:          | `nil`
stringForKey:          | `nil`
decimalNumberForKey:   | `nil`
arrayForKey:           | `nil`
dictionaryForKey:      | `nil`
extractorForKey:       | `nil`

### `@[ @"5", [NSNumber numberWithInteger:-4], @"2.5", @"apple" ]`
Methods                | Return Value
----------------------:|:-------------
boolForKey:            | `NO`
integerForKey:         | `0`
unsignedIntegerForKey: | `0`
dateForKey:            | `nil`
numberForKey:          | `nil`
stringForKey:          | `nil`
decimalNumberForKey:   | `nil`
arrayForKey:           | `@[ @"5", [NSNumber numberWithInteger:-4], @"2.5", @"apple" ]`
arrayOfNumbersForKey:  | `@[ @(5), @(-4), @(2) ]`
arrayOfStringsForKey:  | `@[ @"5", @"-4", @"2.5", @"apple" ]`
arrayOfDecimalNumbersForKey: | `@[ [NSDecimalNumber decimalNumberWithString:@"5"], [NSDecimalNumber decimalNumberWithString:@"-4"], [NSDecimalNumber decimalNumberWithString:@"2.5"] ]`
dictionaryForKey:      | `nil`
extractorForKey:       | `nil`

## Behavior Notes

### `initWithDictionary:`
Attempting to create a `PPExtractor` instance with `nil` or something other than an `NSDictionary` (or subclass) will return `nil`.

This behavior allows you to immediately give in a JSON deserializing response, without fear that `nil`, `NSArray`, or some fragment was returned.

### `dateForKey:`
The `dateForKey:` methods are valid only for Unix timestamps. There is no built in mechanism to handle ISO 8601 or RFC 3339 formatted dates.

### `numberForKey:`
The `numberForKey:` methods intentionally truncate numeric values to be integers. Use `decimalNumberForKey:` methods for decimal-like values.

### `decimalNumberForKey:`
Although JSON does not provide any way to represent `notANumber`, the `decimalNumberForKey:` methods will return `nil` when encountering `notANumber`.

Using `decimalNumberForKey:forceObject:` and passing in `YES` for `forceObject` will return `notANumber` if it is encountered.

### `arrayForKey:`
The `arrayForKey:` and `arrayForKey:forceObject:` methods perform no type checking or coercion. No assumptions should be made with the contents of these arrays.

### Methods with `forceObject:` Parameter
Passing YES to `forceObject:` parameters will assure that an object of the intended class will be created. This may be an empty or arbitrary value, such as @"", @0, @{}, and @[].