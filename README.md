# Plugin: `dev-rel-automated-messages`

Replaces the author of certain system messages with a randomly picked member of a given group.

---

## Features

- This plugin transfers ownership of certain system messages from the `system` user to a user from a random group that can be configured via the settings of the plugin. The following system messages are affected:

  - `welcome_tl1_user`: Users get this message whenever they are given trust level 1.

  - `welcome_tl2_user`: Users get this message whenever they are given trust level 2.

---

## Impact

### Community

Users that receive these system messages now get them from a staff user instead of the system user. This makes the messages feel more personal and users will react better to them.

### Internal

Developer Relations staff members that are in the targeted group might get more notifications / questions from community members as they reply to the author-altered system messages.

### Resources

A negligible performance impact whenever a new post is created, to determine whether it is a system message and to change the author if so.

### Maintenance

Developer Relations must ensure that the group reference in settings is always up-to-date and that the group has at least 1 member. When the name of the group changes, the setting must be updated to match.

---

## Technical Scope

The plugin uses the integrated `DiscourseEvent.on(:topic_created)` to find out whenever a new post is created, and then determines whether the post is a private system message of the type that we want to manipulate, and subsequently changes the author of that system message from the Discourse system user to a random user from the target group.

Since DiscourseEvent provides a highly explicit contract about the event, it is unlikely for the plugin functionality to break throughout Discourse updates. The event would have to be deprecated and no longer triggered in Discourse source for the plugin to stop working. In the unlikely case that happens, nothing apart from the plugin itself should break at that point, the forum will continue to function.

To determine whether the message is of a type that we want to manipulate, we perform a title match using the available locale entries, scoped to the locale of the user that received the system message.

There is a fragile dependency on the existence of the group. The group is only referred to by name in settings. Should the group name change unexpectedly without the setting changing to match, then the plugin won't be able to find the group and won't be able to change the author of the system messages.

---

## Configuration

After installation, the setting `dev_rel_automated_messages_group` must be set to contain the name of the group from which people will be randomly picked as the author of the system messages.
