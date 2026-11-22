# DebugTools

Ever wanted to profile or debug something and have trouble doing it? Well you came to the right place (hopefully)!

This package will hopefully help you. It was inspired by [James Dempsey](https://jamesdempsey.net) at [SwiftSonic](https://swiftsonicconf.com/) with his and [John Haney](https://johnhaney.com)'s talk, Go Wide and Go Deep.

## Macros
### `@SignPoster`
The first (and only) macro for now helps you mark function calls in Instruments. The OSSignPoster api can be good, but its a lot of code to implement for not a ton of benefit. Especially when its temporary. Instead, just use `@SignPoster`. 

Attach SignPoster to any function like so:
```swift
@SignPoster(category: .pointsOfInterest)
func FooBar() {
    ...
}
```
It will standup the poster at beginning of the function, and tear it down when the function ends its execution.

> [!Note]
> If you would like to set a custom subsystem, that is also a parameter. By default, it will use the current bundle identifier.

For more information on OSSignPoster, read [here](https://developer.apple.com/documentation/os/ossignposter).
