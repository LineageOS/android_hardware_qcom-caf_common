package org.lineageos.qtitelephony.compat;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.UserManager;
import android.util.Log;

public class BootReceiver extends BroadcastReceiver {
    private static final String TAG = "QTC-BootReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        Log.d(TAG, "onReceive() called with intent: " + intent.getAction());
        Intent service = new Intent(context, QtiTelephonyCompatService.class);
        context.startService(service);
    }
}
