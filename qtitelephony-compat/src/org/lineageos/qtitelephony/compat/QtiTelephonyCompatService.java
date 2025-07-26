package org.lineageos.qtitelephony.compat;

import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.os.PersistableBundle;
import android.os.RemoteException;
import android.telephony.CarrierConfigManager;
import android.telephony.SubscriptionManager;
import android.telephony.TelephonyManager;
import android.util.Log;

import androidx.annotation.NonNull;

import com.android.internal.telephony.util.ArrayUtils;

import com.qti.extphone.Client;
import com.qti.extphone.ExtPhoneCallbackListener;
import com.qti.extphone.ExtTelephonyManager;
import com.qti.extphone.NrConfig;
import com.qti.extphone.ServiceCallback;
import com.qti.extphone.Status;
import com.qti.extphone.Token;

public class QtiTelephonyCompatService extends Service {
    private static final String TAG = "QtiTelephonyCompatService";

    private Client mClient;
    private ExtTelephonyManager mExtTelephonyManager;
    private TelephonyManager mTelephonyManager;

    private boolean mServiceConnected;
    private String mPackageName;

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();

        mPackageName = getApplicationContext().getPackageName();
        mCarrierConfigManager = getSystemService(CarrierConfigManager.class);
        mTelephonyManager = getSystemService(TelephonyManager.class);

        mExtTelephonyManager = ExtTelephonyManager.getInstance(getApplicationContext());
        mExtTelephonyManager.connectService(mServiceCallback);

        registerCarrierConfigReceiver();
    }

    @Override
    public void onDestroy() {
        super.onDestroy();

        mExtTelephonyManager.unregisterCallback(mExtPhoneCallbackListener);
        mExtTelephonyManager.disconnectService();
    }

    private ExtPhoneCallbackListener mExtPhoneCallbackListener = new ExtPhoneCallbackListener() {
        @Override
        public void onNrConfigStatus(int slotId, Token token, Status status, NrConfig nrConfig)
                throws RemoteException {
            int config = (nrConfig != null) ? nrConfig.get() : NrConfig.NR_CONFIG_INVALID;
            String configStr = "INVALID";

            switch (config) {
                case NrConfig.NR_CONFIG_COMBINED_SA_NSA:
                    configStr = "COMBINED_SA_NSA";
                    break;
                case NrConfig.NR_CONFIG_NSA:
                    configStr = "NSA";
                    break;
                case NrConfig.NR_CONFIG_SA:
                    configStr = "SA";
                    break;
            }

            Log.d(TAG, "onNrConfigStatus: slotId = " + slotId +
                    ", token = " + token +
                    ", status = " + status +
                    ", nrConfig = " + configStr + " (" + config + ")");
        }
    };

    private ServiceCallback mServiceCallback = new ServiceCallback() {
        @Override
        public void onConnected() {
            Log.d(TAG, "Connected to ExtTelephonyService");
            mServiceConnected = true;
            int[] events = new int[] {};
            mClient = mExtTelephonyManager.registerCallbackWithEvents(
                    mPackageName, mExtPhoneCallbackListener, events);
            Log.d(TAG, "Client = " + mClient);
            for (int slotId = 0; slotId < mTelephonyManager.getActiveModemCount();
                    slotId++) {
                Token token = mExtTelephonyManager.queryNrConfig(slotId, mClient);
                Log.d(TAG, "queryNrConfig: " + token + ", slotId: " + slotId);
            }
        }

        @Override
        public void onDisconnected() {
            Log.d(TAG, "Disconnected from ExtTelephonyService");
            if (mServiceConnected) {
                mExtTelephonyManager.unregisterCallback(mExtPhoneCallbackListener);
                mServiceConnected = false;
                mClient = null;
            }
        }
    };

    private final BroadcastReceiver mCarrierConfigReceiver = new BroadcastReceiver() {
        @Override
        public void onReceive(Context context, Intent intent) {
            if (CarrierConfigManager.ACTION_CARRIER_CONFIG_CHANGED.equals(intent.getAction())) {
                int slotId = intent.getIntExtra(SubscriptionManager.EXTRA_SLOT_INDEX, -1);
                int subId = intent.getIntExtra(TelephonyManager.EXTRA_SUBSCRIPTION_ID, -1);

                if (slotId != -1) {
                    PersistableBundle bundle = mCarrierConfigManager.getConfigForSubId(subId);
                    if (bundle != null) {
                        updateCarrierNrConfig(bundle, slotId);
                    }
                }
            }
        }
    };

    private void registerCarrierConfigReceiver() {
        IntentFilter filter = new IntentFilter();
        filter.addAction(CarrierConfigManager.ACTION_CARRIER_CONFIG_CHANGED);
        registerReceiver(mCarrierConfigReceiver, filter);
    }

    private void updateCarrierNrConfig(@NonNull PersistableBundle b, int slotId) {
        final int[] supportedNrModes =
                b.getIntArray(CarrierConfigManager.KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY);
        int configType = NrConfig.NR_CONFIG_COMBINED_SA_NSA;

        boolean is5gStandalone =
                ArrayUtils.contains(
                        supportedNrModes, CarrierConfigManager.CARRIER_NR_AVAILABILITY_SA);
        boolean is5gNonStandalone =
                ArrayUtils.contains(
                        supportedNrModes, CarrierConfigManager.CARRIER_NR_AVAILABILITY_NSA);

        if (is5gNonStandalone && !is5gStandalone) {
            configType = NrConfig.NR_CONFIG_NSA;
        } else if (is5gStandalone && !is5gNonStandalone) {
            configType = NrConfig.NR_CONFIG_SA;
        }

        NrConfig nrConfig = new NrConfig(configType);
        mExtTelephonyManager.setNrConfig(slotId, nrConfig, mClient);
    }
}
