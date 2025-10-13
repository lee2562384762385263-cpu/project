package com.example.notificationapp;

import android.app.Activity;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.Build;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;
import androidx.core.content.ContextCompat;
import android.Manifest;
import org.qtproject.qt.android.QtNative;

public class NotificationHelper {
    private static final String CHANNEL_ID = "NotificationAppChannel";
    private static final String CHANNEL_NAME = "Notification App";
    private static final String CHANNEL_DESCRIPTION = "Notifications for the app";
    private static final int PERMISSION_REQUEST_CODE = 1001;
    
    // Native methods implemented in C++
    public static native void onNotificationReceived(String title, String body, String data);
    public static native void onPermissionResult(boolean granted);
    
    public static void requestNotificationPermission() {
        Activity activity = QtNative.activity();
        if (activity == null) return;
        
        createNotificationChannel(activity);
        
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            if (ContextCompat.checkSelfPermission(activity, Manifest.permission.POST_NOTIFICATIONS) 
                != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(activity, 
                    new String[]{Manifest.permission.POST_NOTIFICATIONS}, 
                    PERMISSION_REQUEST_CODE);
            } else {
                onPermissionResult(true);
            }
        } else {
            // For older Android versions, notification permission is granted by default
            onPermissionResult(true);
        }
    }
    
    public static void createNotificationChannel(Context context) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel channel = new NotificationChannel(
                CHANNEL_ID,
                CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT
            );
            channel.setDescription(CHANNEL_DESCRIPTION);
            
            NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
            notificationManager.createNotificationChannel(channel);
        }
    }
    
    public static void showTestNotification(Context context, String title, String body, String data) {
        createNotificationChannel(context);
        
        // Create intent for when notification is tapped
        Intent intent = new Intent(context, org.qtproject.qt.android.bindings.QtActivity.class);
        intent.setAction("NOTIFICATION_CLICKED");
        intent.putExtra("notification_title", title);
        intent.putExtra("notification_body", body);
        intent.putExtra("notification_data", data);
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        
        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 
            PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        
        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentTitle(title)
            .setContentText(body)
            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
            .setContentIntent(pendingIntent)
            .setAutoCancel(true);
        
        NotificationManagerCompat notificationManager = NotificationManagerCompat.from(context);
        notificationManager.notify(1, builder.build());
        
        // Also call the native callback
        onNotificationReceived(title, body, data);
    }
    
    public static void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        if (requestCode == PERMISSION_REQUEST_CODE) {
            boolean granted = grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED;
            onPermissionResult(granted);
        }
    }
}