# nlydv/brew
Personal homebrew tap for integrating apps/packages/casks I'd like to manage via Homebrew, but that aren't in the official `homebrew/cask` tap.

## Usage

To be able to refrence brew packages added in this tap like any other (just using its name), first add this tap:

```
brew tap nlydv/brew
```

Now if this contains an application package (aka a Cask) called `demo-cask` that doesn't exist in the official/default taps

... simply install as you would any other cask:

```
brew install demo-cask
```

It could also be installed without adding the tap first by prepending the tap name to the cask name:

```
brew install nlydv/brew/demo-cask
```

A cask or formula with a conflicting name across different taps should be refrenced this way.

## Documentation
More info on Homebrew itself:

`brew help`

`man brew`

[Homebrew's documentation](https://docs.brew.sh).

## Disclaimer
_For any programs, applications, or other software that may be refrenced herein by way of inclusion, documentation, packaging, or distribution, such refrence in and of itself does not constitute, and should not be construed as, an indication of personal affiliation, endorsement, support, or any other form of connection by or between the author hereof and any creators, publishers, maintainers, or owners of such software herein referenced._
