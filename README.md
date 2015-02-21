# EBTExtractor
An Objective-C type coercion helper for JSON-derived dictionaries.

Deserializing JSON gives no assurance about what values exist and what type they’ve been deserializing as. Sometimes the type of object a server returns isn’t convenient for your purposes.

EBTExtractor promises that information from a server remains predictable and can used without further inspection. This promise is fulfilled by type coercion and basic value sanitization.

## Usage
Create an `EBTExtractor` with a `NSDictionary`. Use a type-specific method to retrieve a value of that type, for a given key.

Attempting to create a `EBTExtractor` instance with `nil` or something other than an `NSDictionary` (or subclass) will return `nil`.

### Example

```objc
NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];

EBTExtractor *extractor = [EBTExtractor extractorWithDictionary:response];

NSInteger identifier = [extractor integerForKey:@"id"];
NSString *name = [extractor stringForKey:@"name"];
NSDecimalNumber *rating = [extractor decimalNumberForKey:@"rating"];
NSArray *friendIDs = [extractor arrayOfNumbersForKey:@"friends"];
```

### Why Use EBTExtractor
Using an EBTExtractor removes the burden of manually checking received value types and converting them to a desired type, if necessary.

This burden normally leads to code that is tedious to write, obfuscate the original intent, and is prone to errors.

The code below is an approximation of what the EBTExtractor example above achieves, but with many more lines.

#### Code You Should Not Write
```objc
NSDictionary *response = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:NULL];

NSInteger identifier = 0;
NSString *name = nil;
NSDecimalNumber *rating = nil;
NSArray *friendIDs = nil;

if ([response isKindOfClass:[NSDictionary class]]) {
    id serverID = [response objectForKey:@"id"];
    id serverName = [response objectForKey:@"name"];
    id serverRating = [response objectForKey:@"rating"];
    id serverFriendIDs = [response objectForKey:@"friends"];
    
    if ([serverID respondsToSelector:@selector(integerValue)]) {
        // NSString and NSNumber cases
        identifier = [serverID integerValue];
    }
    
    if ([serverName isKindOfClass:[NSString class]]) {
        // Already an NSString
        name = serverName;
    }
    else if ([serverName respondsToSelector:@selector(stringValue)]) {
        // Convert NSNumber to NSString
        name = [serverName stringValue];
    }
    
    if ([serverRating isKindOfClass:[NSDecimalNumber class]]) {
        // Already an NSDecimalNumber
        rating = serverRating;
    }
    else if ([serverRating isKindOfClass:[NSNumber class]]) {
        // Convert NSNumber to NSDecimalNumber
        rating = [NSDecimalNumber decimalNumberWithDecimal:[serverRating decimalValue]];
    }
    else if ([serverRating isKindOfClass:[NSString class]]) {
        // Convert NSString to NSDecimalNumber
        rating = [NSDecimalNumber decimalNumberWithString:serverRating locale:[NSLocale systemLocale]];
        if ([rating isEqualToNumber:[NSDecimalNumber notANumber]]) {
            rating = nil;
        }
    }
    
    if ([serverFriendIDs isKindOfClass:[NSArray class]]) {
        // Already an NSArray, but no guarantee of contents
        friendIDs = serverFriendIDs;
    }
}
```

## Methods

* [Value Methods](#value-methods)
    * [`- (BOOL)boolForKey:`](#--boolboolforkey)
    * [`- (NSInteger)integerForKey:`](#--nsintegerintegerforkey)
    * [`- (NSUInteger)unsignedIntegerForKey:`](#--nsuintegerunsignedintegerforkey)
    * [`- (NSNumber *)numberForKey:`](#--nsnumber-numberforkey)
    * [`- (NSString *)stringForKey:`](#--nsstring-stringforkey)
    * [`- (NSDate *)unixDateForKey:`](#--nsdate-unixdateforkey)
    * [`- (NSDecimalNumber *)decimalNumberForKey:`](#--nsdecimalnumber-decimalnumberforkey)
    * [`- (NSArray *)arrayForKey:`](#--nsarray-arrayforkey)
    * [`- (NSDictionary *)dictionaryForKey:`](#--nsdictionary-dictionaryforkey)
    * [`- (EBTExtractor *)extractorForKey:`](#--ebtextractor-extractorforkey)
* [Typed Array Value Methods](#typed-array-value-methods)
    * [Unconvertible Markers](#unconvertible-markers)
* [Forcing Values to Be Returned](#forcing-values-to-be-returned)
    * [Forced Fallback Values](#forced-fallback-values)


### Value Methods

#### `- (BOOL)boolForKey:`
Returns a `BOOL` representation of the value associated with a given key.

Original Value                  | `BOOL` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `YES`
`@NO`                           | `NO`
`@0`                            | `NO`
`@1`                            | `YES`
`@2`                            | `YES`
`@(-1)`                         | `YES`
`@8`                            | `YES`
`@1415162234`                   | `YES`
`@5.94` as `NSDecimalNumber`    | `YES`
`@4.13` as `NSDecimalNumber`    | `YES`
`@"potato"`                     | `NO`
`@""`                           | `NO`
`@"8.45"`                       | `YES`
`@"the 21.5 slices"`            | `YES`
`@"two"`                        | `NO`
`[NSNull null]`                 | `NO`
Any `NSArray`                   | `NO`
Any `NSDictionary`              | `NO`
Any non-JSON-compatible class   | `NO`

--

#### `- (NSInteger)integerForKey:`
Returns an `NSInteger` representation of the value associated with a given key.

**Rounding Note:** Decimal-like original values are never rounded. For example, a string with the text "7.99999" will have the `NSInteger` representation of `7`.

Original Value                  | `NSInteger` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `1`
`@NO`                           | `0`
`@0`                            | `0`
`@1`                            | `1`
`@2`                            | `2`
`@(-1)`                         | `-1`
`@8`                            | `8`
`@1415162234`                   | `1415162234`
`@5.94` as `NSDecimalNumber`    | `5`
`@4.13` as `NSDecimalNumber`    | `4`
`@"potato"`                     | `0`
`@""`                           | `0`
`@"8.45"`                       | `8`
`@"the 21.5 slices"`            | `21`
`@"two"`                        | `0`
`[NSNull null]`                 | `0`
Any `NSArray`                   | `0`
Any `NSDictionary`              | `0`
Any non-JSON-compatible class   | `0`

--

#### `- (NSUInteger)unsignedIntegerForKey:`
Returns an `NSUInteger` representation of the value associated with a given key.

**Rounding Note:** Decimal-like original values are never rounded. For example, a string with the text "7.99999" will have the `NSUInteger` representation of `7`.

**Warning:** This may return unintended values when encountering original values that are negative.

Original Value                  | `NSUInteger ` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `1`
`@NO`                           | `0`
`@0`                            | `0`
`@1`                            | `1`
`@2`                            | `2`
`@(-1)`                         | dependent on device architecture
`@8`                            | `8`
`@1415162234`                   | `1415162234`
`@5.94` as `NSDecimalNumber`    | `5`
`@4.13` as `NSDecimalNumber`    | `4`
`@"potato"`                     | `0`
`@""`                           | `0`
`@"8.45"`                       | `8`
`@"the 21.5 slices"`            | `21`
`@"two"`                        | `0`
`[NSNull null]`                 | `0`
Any `NSArray`                   | `0`
Any `NSDictionary`              | `0`
Any non-JSON-compatible class   | `0`

--

#### `- (NSNumber *)numberForKey:`
Returns an `NSNumber` representation of the value associated with a given key, or `nil`.

**Note:** If the original value is inherently non-numeric, `nil` will be returned. For example, the string "apple" is considered to be non-numeric.

**Rounding Note:** Decimal-like original values are never rounded. For example, a string with the text "7.99999" will have the `NSNumber` representation of `@7`.

Original Value                  | `NSNumber` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `@1`
`@NO`                           | `@0`
`@0`                            | `@0`
`@1`                            | `@1`
`@2`                            | `@2`
`@(-1)`                         | `@(-1)`
`@8`                            | `@8`
`@1415162234`                   | `@1415162234`
`@5.94` as `NSDecimalNumber`    | `@5`
`@4.13` as `NSDecimalNumber`    | `@4`
`@"potato"`                     | **`nil`**
`@""`                           | **`nil`**
`@"8.45"`                       | `@8`
`@"the 21.5 slices"`            | `@21`
`@"two"`                        | **`nil`**
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | **`nil`**
Any `NSDictionary`              | **`nil`**
Any non-JSON-compatible class   | **`nil`**

--

#### `- (NSString *)stringForKey:`
Returns an `NSString` representation of the value associated with a given key, or `nil`.

**Note:** If the original value is inherently non-textual, `nil` will be returned. For example, an `NSDictionary` is considered to be non-textual.

Original Value                  | `NSString` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `@"1"`
`@NO`                           | `@"0"`
`@0`                            | `@"0"`
`@1`                            | `@"1"`
`@2`                            | `@"2"`
`@(-1)`                         | `@"-1"`
`@8`                            | `@"8"`
`@1415162234`                   | `@"1415162234"`
`@5.94` as `NSDecimalNumber`    | `@"5.94"`
`@4.13` as `NSDecimalNumber`    | `@"4.13"`
`@"potato"`                     | `@"potato"`
`@""`                           | `@""`
`@"8.45"`                       | `@"8.45"`
`@"the 21.5 slices"`            | `@"the 21.5 slices"`
`@"two"`                        | `@"two"`
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | **`nil`**
Any `NSDictionary`              | **`nil`**
Any non-JSON-compatible class   | **`nil`**

--

#### `- (NSDate *)unixDateForKey:`
Returns an `NSDate` representation of the value associated with a given key, or `nil`.

**Important:** This method will only return dates for original values that can be considered numeric and non-zero.

This method only handles Unix timestamps. This does not attempt to interpret ISO 8601 or RFC 3339 formatted date strings.

**Note:** If the original value is inherently non-numeric, `nil` will be returned. For example, the string "apple" is considered to be non-numeric.

Original Value                  | `NSDate` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `[NSDate dateWithTimeIntervalSince1970:1]`
`@NO`                           | **`nil`**
`@0`                            | **`nil`**
`@1`                            | `[NSDate dateWithTimeIntervalSince1970:1]`
`@2`                            | `[NSDate dateWithTimeIntervalSince1970:2]`
`@(-1)`                         | `[NSDate dateWithTimeIntervalSince1970:-1]`
`@8`                            | `[NSDate dateWithTimeIntervalSince1970:8]`
`@1415162234`                   | `[NSDate dateWithTimeIntervalSince1970:1415162234]`
`@5.94` as `NSDecimalNumber`    | `[NSDate dateWithTimeIntervalSince1970:5.94]`
`@4.13` as `NSDecimalNumber`    | `[NSDate dateWithTimeIntervalSince1970:4.13]`
`@"potato"`                     | **`nil`**
`@""`                           | **`nil`**
`@"8.45"`                       | `[NSDate dateWithTimeIntervalSince1970:8.45]`
`@"the 21.5 slices"`            | `[NSDate dateWithTimeIntervalSince1970:21.5]`
`@"two"`                        | **`nil`**
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | **`nil`**
Any `NSDictionary`              | **`nil`**
Any non-JSON-compatible class   | **`nil`**

--

#### `- (NSDecimalNumber *)decimalNumberForKey:`
Returns an `NSDecimalNumber` representation of the value associated with a given key, or `nil`.

The notation in the table below may suggest that things are represented as imprecise `float` or `double` `NSNumber` representations.
For lack of a precise, concise notation, you can safely assume that `NSDecimalNumber` objects are correctly constructed, like `[NSDecimalNumber decimalNumberWithString:@"8.45" locale:[NSLocale systemLocale]]`.

**Note:** If the original value is inherently non-numeric, `nil` will be returned. For example, the string "apple" is considered to be non-numeric. This method considers `NSDecimalNumber notANumber]` to be non-numeric.

Original Value                  | `NSDecimalNumber` Representation
-------------------------------:|:-------------------------------
`@YES`                          | `@1` as `NSDecimalNumber`
`@NO`                           | `@0` as `NSDecimalNumber`
`@0`                            | `@0` as `NSDecimalNumber`
`@1`                            | `@1` as `NSDecimalNumber`
`@2`                            | `@2` as `NSDecimalNumber`
`@(-1)`                         | `@(-1)` as `NSDecimalNumber`
`@8`                            | `@8` as `NSDecimalNumber`
`@1415162234`                   | `@1415162234` as `NSDecimalNumber`
`@5.94` as `NSDecimalNumber`    | `@5.94` as `NSDecimalNumber`
`@4.13` as `NSDecimalNumber`    | `@4.13` as `NSDecimalNumber`
`@"potato"`                     | **`nil`**
`@""`                           | **`nil`**
`@"8.45"`                       | `@8.45` as `NSDecimalNumber`
`@"the 21.5 slices"`            | `@21.5` as `NSDecimalNumber`
`@"two"`                        | **`nil`**
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | **`nil`**
Any `NSDictionary`              | **`nil`**
Any non-JSON-compatible class   | **`nil`**

--

#### `- (NSArray *)arrayForKey:`
Returns an `NSArray` representation of the value associated with a given key, or `nil`.

**Warning:** This only assures that an `NSArray` is returned. It makes no assurances about types of objects in the array. See the Typed Array methods.

**Note:** If the original value is not an array, `nil` will be returned.

Original Value                  | `NSArray` Representation
-------------------------------:|:-------------------------------
`@YES`                          | **`nil`**
`@NO`                           | **`nil`**
`@0`                            | **`nil`**
`@1`                            | **`nil`**
`@2`                            | **`nil`**
`@(-1)`                         | **`nil`**
`@8`                            | **`nil`**
`@1415162234`                   | **`nil`**
`@5.94` as `NSDecimalNumber`    | **`nil`**
`@4.13` as `NSDecimalNumber`    | **`nil`**
`@"potato"`                     | **`nil`**
`@""`                           | **`nil`**
`@"8.45"`                       | **`nil`**
`@"the 21.5 slices"`            | **`nil`**
`@"two"`                        | **`nil`**
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | Original Array
Any `NSDictionary`              | **`nil`**
Any non-JSON-compatible class   | **`nil`**

--

#### `- (NSDictionary *)dictionaryForKey:`
Returns an `NSDictionary` representation of the value associated with a given key, or `nil`.

**Warning:** This only assures that an `NSDictionary` is returned. It makes no assurances about types of objects for the keys and values. However, if this is deserialized JSON data, then the keys should be `NSString` objects.

**Note:** If the original value is not a dictionary, `nil` will be returned.

Original Value                  | `NSDictionary` Representation
-------------------------------:|:-------------------------------
`@YES`                          | **`nil`**
`@NO`                           | **`nil`**
`@0`                            | **`nil`**
`@1`                            | **`nil`**
`@2`                            | **`nil`**
`@(-1)`                         | **`nil`**
`@8`                            | **`nil`**
`@1415162234`                   | **`nil`**
`@5.94` as `NSDecimalNumber`    | **`nil`**
`@4.13` as `NSDecimalNumber`    | **`nil`**
`@"potato"`                     | **`nil`**
`@""`                           | **`nil`**
`@"8.45"`                       | **`nil`**
`@"the 21.5 slices"`            | **`nil`**
`@"two"`                        | **`nil`**
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | **`nil`**
Any `NSDictionary`              | Original Dictionary
Any non-JSON-compatible class   | **`nil`**

--

#### `- (EBTExtractor *)extractorForKey:`
Returns an `EBTExtractor` representation of the value associated with a given key, or `nil`.

**Subclassing Note:** If you subclass `EBTExtractor`, then instances returned from this method will be of that class, not `EBTExtractor`.

**Note:** If the original value is not a dictionary, `nil` will be returned.

Original Value                  | `EBTExtractor` Representation
-------------------------------:|:-------------------------------
`@YES`                          | **`nil`**
`@NO`                           | **`nil`**
`@0`                            | **`nil`**
`@1`                            | **`nil`**
`@2`                            | **`nil`**
`@(-1)`                         | **`nil`**
`@8`                            | **`nil`**
`@1415162234`                   | **`nil`**
`@5.94` as `NSDecimalNumber`    | **`nil`**
`@4.13` as `NSDecimalNumber`    | **`nil`**
`@"potato"`                     | **`nil`**
`@""`                           | **`nil`**
`@"8.45"`                       | **`nil`**
`@"the 21.5 slices"`            | **`nil`**
`@"two"`                        | **`nil`**
`[NSNull null]`                 | **`nil`**
Any `NSArray`                   | **`nil`**
Any `NSDictionary`              | `EBTExtractor` with Original Dictionary
Any non-JSON-compatible class   | **`nil`**

### Typed Array Value Methods
The following methods are provided are provided as a convenience to ensure the contents of an array are of a given type.

Method Value                                | Array Contents
:-------------------------------------------|:-------------------------------
`- (NSArray *)arrayOfNumbersForKey:`        | `NSNumber` objects (integer style)
`- (NSArray *)arrayOfStringsForKey:`        | `NSString` objects
`- (NSArray *)arrayOfUnixDatesForKey:`      | `NSDate` objects
`- (NSArray *)arrayOfDecimalNumbersForKey:` | `NSDecimalNumber` objects
`- (NSArray *)arrayOfArraysForKey:`         | `NSArray` objects (not type specific)
`- (NSArray *)arrayOfDictionariesForKey:`   | `NSDictionary` objects
`- (NSArray *)arrayOfExtractorsForKey:`     | `EBTExtractor` objects

The contents of the returned arrays are subject to the same rules as the single-value methods. For example, requesting `arrayOfNumbersForKey:` for an array `@[ @5.24, @8.99 ]` will return `@[ @5, @8 ]`.

If an original array has contents that cannot be converted to the requested type, those items will be omitted. For example, requesting `arrayOfNumbersForKey:` for an array `@[ @"4", @"bar", @"9.24" ]` will return `@[ @4, @9 ]`.

#### Unconvertible Markers
The typed array methods have extended versions that can accept an “unconvertible marker”. In the event that an object in the original array could not be converted, the provided marker will be used in its place. This is useful when the exact indexing positions of the original array must be maintained.

For example, requesting `arrayOfNumbersForKey:unconvertibleMarker:` with `@(-1)` for an array `@[ @"4", @"bar", @"9.24" ]` will return `@[ @4, @(-1), @9 ]`.

**Note:** The marker object does not necessarily have to be of the originally requested type. Thus, you can use an `NSString` object as an unconvertible marker for an array that otherwise contains `NSNumber` objects. You should ensure that you handle this gracefully in your code.

### Forcing Values to Be Returned
The value methods all have alternative methods that will guarantee that _some value_ will be returned. This behavior may be useful in cases where returning `nil` would be unwanted and a “default” value is acceptable.

This only takes place when the normal methods would have returned `nil`.

#### Forced Fallback Values
Forced Value Method                                 | Forced Fallback Value
:---------------------------------------------------|:-------------------------------
`- (NSNumber *)forcedNumberForKey:`                 | `@0`
`- (NSString *)forcedStringForKey:`                 | `@""`
`- (NSDate *)forcedUnixDateForKey:`                 | `[NSDate dateWithTimeIntervalSince1970:0]`
`- (NSDecimalNumber *)forcedDecimalNumberForKey:`   | `[NSDecimalNumber notANumber]`
`- (NSArray *)forcedArrayForKey:`                   | `@[]`
`- (NSDictionary *)forcedDictionaryForKey:`         | `@{}`
`- (EBTExtractor *)forcedExtractorForKey:`          | `[EBTExtractor extractorWithDictionary:@{}]`
All Typed Array Methods                             | `@[]`

#### Example
```objc
EBTExtractor *extractor = [EBTExtractor extractorWithDictionary:@{ @"type" : @"member" }];
NSMutableDictionary *someDictionary = [NSMutableDictionary dictionary];

[someDictionary setObject:[extractor forcedStringForKey:@"name"] forKey:"userName"]; // @""
[someDictionary setObject:[extractor forcedNumberForKey:@"userID"] forKey:"identifier"]; // @0
[someDictionary setObject:[extractor forcedStringForKey:@"type"] forKey:"accountType"]; // @"member" (normal behavior)
```
