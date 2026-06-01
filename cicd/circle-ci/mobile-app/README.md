# Mobile app

CircleCI pipeline that builds a mobile app. The project was done in 2024.

Please note that the config was written in 2024, before AI psychosis.

The pipeline can build either APK or iOS or both - which option is used depends on the commit message.
The commit message should include a build trigger - some characters that tell the pipeline which binary to build.

For example, a commit message like
```bash
<<apk>> building v1
```
will build the APK binary.

A commit message like
```bash
<<ios>> building v1
```
will build for iOS

And a commit message like
```bash
<<apk>> <<ios>> building v1
```
will build for both APK and iOS.

Since the build triggers are defined in the config file it is possible to customize the triggers.

The pipeline is using the `continuation` orb that checks if any of the expected triggers are present in the commit message. If they are then another CCI config will be launched.

The pipeline includes all the steps that you'd normally go through when building a mobile app for either Android or iOS. This particular example is also using Fastlane - templates not included.
