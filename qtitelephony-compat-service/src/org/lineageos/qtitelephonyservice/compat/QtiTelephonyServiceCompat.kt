/*
 * SPDX-FileCopyrightText: 2025 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.qtitelephonyservice.compat

import android.Manifest
import android.app.Service
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.IBinder
import android.os.PersistableBundle
import android.telephony.CarrierConfigManager
import android.telephony.SubscriptionManager
import android.telephony.TelephonyManager
import android.util.Log
import androidx.annotation.RequiresPermission
import com.android.internal.telephony.util.ArrayUtils
import com.qti.extphone.Client
import com.qti.extphone.ExtPhoneCallbackListener
import com.qti.extphone.ExtTelephonyManager
import com.qti.extphone.NrConfig
import com.qti.extphone.ServiceCallback
import com.qti.extphone.Status
import com.qti.extphone.Token

class QtiTelephonyServiceCompat : Service() {
    private var client: Client? = null
    private var serviceConnected = false

    private val carrierConfigManager: CarrierConfigManager by lazy {
        getSystemService(CarrierConfigManager::class.java)
    }
    private val extTelephonyManager: ExtTelephonyManager by lazy {
        ExtTelephonyManager.getInstance(applicationContext)
    }

    private val extPhoneCallbackListener =
        object : ExtPhoneCallbackListener() {
            override fun onNrConfigStatus(
                slotId: Int,
                token: Token?,
                status: Status?,
                nrConfig: NrConfig?,
            ) {
                val config = nrConfig?.get() ?: NrConfig.NR_CONFIG_INVALID
                val configStr =
                    when (config) {
                        NrConfig.NR_CONFIG_COMBINED_SA_NSA -> "COMBINED_SA_NSA"
                        NrConfig.NR_CONFIG_NSA -> "NSA"
                        NrConfig.NR_CONFIG_SA -> "SA"
                        else -> "INVALID"
                    }
                Log.d(TAG, "onNrConfigStatus: slotId = $slotId, nrConfig = $configStr")
            }

            override fun onSetNrConfig(slotId: Int, token: Token?, status: Status?) {
                client?.let { extTelephonyManager.queryNrConfig(slotId, it) }
            }
        }

    private val serviceCallback =
        object : ServiceCallback {
            override fun onConnected() {
                Log.d(TAG, "Connected to ExtTelephonyService")
                serviceConnected = true
                client =
                    extTelephonyManager.registerCallbackWithEvents(
                        applicationContext.packageName,
                        extPhoneCallbackListener,
                        intArrayOf(),
                    )
            }

            override fun onDisconnected() {
                Log.d(TAG, "Disconnected from ExtTelephonyService")
                if (serviceConnected) {
                    extTelephonyManager.unregisterCallback(extPhoneCallbackListener)
                    serviceConnected = false
                    client = null
                }
            }
        }

    private val carrierConfigReceiver =
        object : BroadcastReceiver() {
            @RequiresPermission(Manifest.permission.READ_PHONE_STATE)
            override fun onReceive(context: Context, intent: Intent) {
                if (CarrierConfigManager.ACTION_CARRIER_CONFIG_CHANGED == intent.action) {
                    val slotId = intent.getIntExtra(SubscriptionManager.EXTRA_SLOT_INDEX, -1)
                    val subId = intent.getIntExtra(TelephonyManager.EXTRA_SUBSCRIPTION_ID, -1)

                    if (slotId != -1) {
                        val bundle = carrierConfigManager.getConfigForSubId(subId)
                        if (bundle != null) {
                            updateCarrierNrConfig(bundle, slotId)
                        }
                    }
                }
            }
        }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()

        extTelephonyManager.connectService(serviceCallback)

        registerCarrierConfigReceiver()
    }

    override fun onDestroy() {
        extTelephonyManager.unregisterCallback(extPhoneCallbackListener)
        extTelephonyManager.disconnectService(serviceCallback)

        super.onDestroy()
    }

    private fun registerCarrierConfigReceiver() {
        val filter =
            IntentFilter().apply { addAction(CarrierConfigManager.ACTION_CARRIER_CONFIG_CHANGED) }
        registerReceiver(carrierConfigReceiver, filter)
    }

    private fun updateCarrierNrConfig(b: PersistableBundle, slotId: Int) {
        val supportedNrModes =
            b.getIntArray(CarrierConfigManager.KEY_CARRIER_NR_AVAILABILITIES_INT_ARRAY)

        val is5gStandalone =
            ArrayUtils.contains(supportedNrModes, CarrierConfigManager.CARRIER_NR_AVAILABILITY_SA)
        val is5gNonStandalone =
            ArrayUtils.contains(supportedNrModes, CarrierConfigManager.CARRIER_NR_AVAILABILITY_NSA)

        val configType =
            when {
                is5gNonStandalone && !is5gStandalone -> NrConfig.NR_CONFIG_NSA
                is5gStandalone && !is5gNonStandalone -> NrConfig.NR_CONFIG_SA
                else -> NrConfig.NR_CONFIG_COMBINED_SA_NSA
            }

        val nrConfig = NrConfig(configType)
        client?.let { extTelephonyManager.setNrConfig(slotId, nrConfig, it) }
    }

    companion object {
        private const val TAG = "QtiTelephonyServiceCompat"
    }
}
