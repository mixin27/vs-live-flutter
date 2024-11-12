package com.billion.sport_live;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;

import com.onesignal.notifications.IDisplayableMutableNotification;
import com.onesignal.notifications.INotificationReceivedEvent;
import com.onesignal.notifications.INotificationServiceExtension;

@Keep
public class NotificationServiceExtension implements INotificationServiceExtension {
    @Override
    public void onNotificationReceived(@NonNull INotificationReceivedEvent event) {
        IDisplayableMutableNotification notification = event.getNotification();

        notification.setExtender(builder -> builder.setColor(0xFF785a0b));
    }
}
