#SwiftNote

Note taking app with recent notes today widget and iCloud syncing. Written in swift

##Things to watch out for with the today widget

1. Make sure to set the height using self.preferredContentSize

##Sharing data between the today widget and app

1. Add an app group through the entitlements screen for both the widget and the app
2. Make sure to specify the same group for each
3. Make the core data store url exist in the app group's shared container:

```
var storeURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(kAppGroupIdentifier)
        storeURL = storeURL.URLByAppendingPathComponent("SwiftNote.sqlite");
```

4. Use this storeURL in both the today widget and app

##Debugging the today widget

1. Run the container app (SwiftNote) after making any changes
2. Stop debugging
3. In menu bar select Debug -> Attach to process -> By Process Identifier or Name
4. Attach to the process com.appbrewllc.SwiftNote.SwiftNoteTodayWidget
5. Breakpoint all the things!

##iCloud syncing

This is currently not working. If anyone knows how to get this working please let me know

