# Stripe Push Provisioning
# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-dontwarn com.google.crypto.tink.subtle.Ed25519Sign$KeyPair
-dontwarn com.google.crypto.tink.subtle.Ed25519Verify
-dontwarn com.google.crypto.tink.subtle.X25519
-dontwarn com.stripe.android.pushProvisioning.EphemeralKeyUpdateListener
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider

-keep class com.stripe.android.pushProvisioning.** { *; }
-keep class com.reactnativestripesdk.pushprovisioning.** { *; }
-keep class io.flutter.embedding.engine.deferredcomponents.** { *; }

-keep class com.stripe.android.model.** { *; }  # Might be needed
-keep class com.stripe.android.view.** { *; }   # Might be needed
-keep class com.stripe.android.payments.** { *; } # Might be needed
-keep class com.stripe.android.Stripe** { *; } # Might be needed
-keep class com.stripe.android.ApiResult** { *; }
-keep class com.stripe.android.EphemeralKeyProvider** { *; }
-keep class com.stripe.android.PaymentIntent** { *; }
-keep class com.stripe.android.SetupIntent** { *; }
-keep class com.stripe.android.Source** { *; }
-keep class com.stripe.android.Token** { *; }
-keep class com.stripe.android.Customer** { *; }
-keep class com.stripe.android.Card** { *; }
-keep class com.stripe.android.BankAccount** { *; }
-keep class com.stripe.android.Address** { *; }
-keep class com.stripe.android.Exception** { *; }
-keep class com.stripe.android.model.PaymentMethod$Card** { *; }
-keep class com.stripe.android.model.PaymentMethod$BillingDetails** { *; }
-keep class com.stripe.android.model.PaymentMethod$Card$Networks** { *; }
-keep class com.stripe.android.model.PaymentMethodCreateParams$Card** { *; }
-keep class com.stripe.android.model.PaymentMethodCreateParams$BillingDetails** { *; }
-keep class com.stripe.android.model.PaymentMethodCreateParams$Card$Networks** { *; }
-keep class com.stripe.android.model.Source$Receiver** { *; }
-keep class com.stripe.android.model.Source$Redirect** { *; }
-keep class com.stripe.android.model.Source$CodeVerification** { *; }
-keep class com.stripe.android.model.Source$Wechat** { *; }
-keep class com.stripe.android.model.Source$Alipay** { *; }
-keep class com.stripe.android.model.Source$Ideal** { *; }
-keep class com.stripe.android.model.Source$Sofort** { *; }
-keep class com.stripe.android.model.Source$Giropay** { *; }
-keep class com.stripe.android.model.Source$Bancontact** { *; }
-keep class com.stripe.android.model.Source$Eps** { *; }
-keep class com.stripe.android.model.Source$Fpx** { *; }
-keep class com.stripe.android.model.Source$P24** { *; }
-keep class com.stripe.android.model.Source$Multibanco** { *; }
-keep class com.stripe.android.model.Source$Oney** { *; }
-keep class com.stripe.android.model.Source$Klarna** { *; }
-keep class com.stripe.android.model.Source$Paypal** { *; }
-keep class com.stripe.android.model.Source$SepaDebit** { *; }
-keep class com.stripe.android.model.Source$AuBecsDebit** { *; }
-keep class com.stripe.android.model.Source$BacsDebit** { *; }
-keep class com.stripe.android.model.Source$GiroPay** { *; }
-keep class com.stripe.android.model.Source$AlipayHK** { *; }
-keep class com.stripe.android.model.Source$WeChatPay** { *; }
-keep class com.stripe.android.model.Source$GrabPay** { *; }
-keep class com.stripe.android.model.Source$Card** { *; }
-keep class com.stripe.android.model.Source$Ideal$Bank** { *; }
-keep class com.stripe.android.model.PaymentMethodCreateParams$Card$Networks$CardBrand** { *; }

-keep class com.google.android.play.** { *; }
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.crypto.tink.** { *; }
-keep class com.nimbusds.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }

# Keep any classes referenced by react-native-stripe-sdk
-keep class com.reactnativestripesdk.** { *; }

# Keep inner classes
-keep class * {
    static <fields>;
}