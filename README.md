# Flutter Provider + Shared Preferences

A simple demo of Flutter [provider][0] and [shared_preferences][1] based on
the default Example app you get when you do `flutter create APPNAME`.

If you just want to see the code, check out the [Gist][2] instead.

The basic use-case I needed to solve here is that I have some user preferences
that need to be available to the various Widgets (views) and also early in the
program's execution.  For instance, to decide whether the user wants to use
WhatsApp or Signal for messaging.

I _think_ this demonstrates a reasonably clean and `~~` idiomatic way to do
this.

## RFC

I'm putting this out there as a public service, but also because I will
probably need to remember it myself some day.  If you find anything wrong,
or have any suggestions, please feel free open an "Issue" here.

And as long as you're here, have a look at some [art][3]!

Cheers

_-- frosty_


 ---

 ```END```

 <!-- links -->

 [0]: https://pub.dev/packages/provider
 [1]: https://pub.dev/packages/shared_preferences
 [2]: https://gist.github.com/biztos/1218306341b89eb9bda62cb003e49b01
 [3]: https://kevinfrost.com/

