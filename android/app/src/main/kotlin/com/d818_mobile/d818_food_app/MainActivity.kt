package com.d818_mobile.d818_food_app

import android.view.View
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity() {
    override fun onStart() {
        super.onStart()
        window.decorView.visibility = View.VISIBLE
    }

    override fun onStop() {
        window.decorView.visibility = View.GONE
        super.onStop()
    }
}
