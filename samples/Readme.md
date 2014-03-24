#Apigee iOS SDK Sample Apps

The sample apps in this directory are intended to show basic usage of some of the major features of App Services using the Apigee iOS SDK. By default, all of the sample apps are set up to use the unsecured 'sandbox' application that was created for you when you created your Apigee account.

##Included Samples Apps

* **monitoringSample** - An app that lets you test the App Monitoring feature by sending logging, crash and error reports to your account.

##Running the sample apps

To run the sample apps, simply open the .xcodeproj file in Xcode, then run the app.

Before you do, however, each of the sample apps require you to include the Apigee iOS SDK.

For instructions on how to do this, visit our [iOS SDK install guide](http://apigee.com/docs/app-services/content/installing-apigee-sdk-ios). 

Some of the apps also require you to provide your organization name by updating the call to ApigeeClient in the app's source. Near the top of the code in each app, you should see something similar to this:

	```obj-c
NSString * orgName = @"yourorgname"; //Your Apigee.com username
NSString * appName = @"sandbox"; //Your App Services app name
```

Simply change the value of the orgName property to your Apigee organization name.