# NSPMapProtocol

The `NSPMapProtocol` library defines the `nspmap://` URL protocol to be used in Cocoa applications. Calling an URL with this protocol and the appropriate query parameters returns a `.png` image that represents a snapshot of the map of the specified region.

The real strength of this protocol can be seen when using it in [TVML](https://developer.apple.com/library/tvos/documentation/TVMLKitJS/Conceptual/TVMLProgrammingGuide/) apps where there is no simple out-of-the-box solution provided by Apple to include static map screenshots in the application. With `NSPMapProtocol` including a static screenshot to your TVML app becomes as simple as linking to a remote image:

    <img src="nspmap://?ll=45.4654,9.1859&w=400&h=400" width="400" height="400" />

## Installation

NSPMapProtocol is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "NSPMapProtocol"

Or simply include the contents of the `NSPMapProtocol` directory in your project.

## Usage

`NSPMapProtocol` automatically registers itself at `NSURLProtocol` so if you compiled the source files to your project you can start making `nspmap://` requests right when your app starts.

### Native code

This code creates an `UIImage` with the map around Milan, Italy:

    NSURL* url = [NSURL URLWithString:@"nspmap://?ll=45.4654,9.1859&w=400&h=400"];
    NSData* data = [NSData dataWithContentsOfURL:url];
    UIImage* image = [UIImage imageWithData:data];

### TVML code

This code embeds an image in the TVML page with the map around Milan, Italy:

    <img src="nspmap://?ll=45.4654,9.1859&amp;w=400&amp;h=400" width="400" height="400" />

Note that for the correct parsing of your TVML page you need to use the `&amp;` entity instead of the simple & ampersands in TVML URLs. You can use `nspmap://` URLs not only for `img` tags but everywhere when an image URL is expected.

## Query parameters

You can use the following query parameters with `nspmap://` protocol:

 - `t`: defines the type of the map. One of `k` (satellite), `h` (hybrid) or `m` (stanard map, this is the default). Example: `nspmap://?t=h`
 - `ll`: a comma separated pair of numbers representing the latitude and longitude values of the center of the map. Example: `nspmap://?ll=45.4654,9.1859`
 - `spn`: a comma separated pair of numbers representing the latitude delta and longitude delta values of the span (length of the sides) of the map. Example: `nspmap://?ll=45.4654,9.1859&spn=3,3`
 - `w` and `h`: the width and height in pixels of the resulting image. Example: `nspmap://?w=200&h=200`
 - `p`: a comma separated pair of numbers representing the latitude and longitude values of a pin on the map. You can show more than one pin specifying more then one `p` parameter: `nspmap://?ll=45.4654,9.1859&spn=2,2&p=45.4654,9.1859&p=45.1404,10.0326`

## Author

Developed by [Janos Tolgyesi](www.linkedin.com/in/janostolgyesi), powered by [Neosperience](http://www.neosperience.com/).

## License

NSPMapProtocol is available under the MIT license. See the LICENSE file for more info.


