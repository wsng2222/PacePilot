# Gson (used by flutter_local_notifications to persist scheduled notifications
# across reboots) relies on generic type information at runtime. R8 strips this
# by default, which crashes ScheduledNotificationBootReceiver on boot with
# "RuntimeException: Missing type parameter." Keep the signatures it needs.
-keepattributes Signature
-keepattributes *Annotation*

-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep public class * implements java.lang.reflect.Type

-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

-keep class com.dexterous.flutterlocalnotifications.models.** { *; }
-keep class com.dexterous.flutterlocalnotifications.** { *; }
