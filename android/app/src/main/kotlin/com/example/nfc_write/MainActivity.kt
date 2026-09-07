package dev.aster.nfc_write

import android.app.AlarmManager
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val NFC_CHANNEL = "dev.aster.nfc_write/nfc"
    private val TIMER_CHANNEL = "dev.aster.nfc_write/timer"
    private var channel: MethodChannel? = null
    private var timerChannel: MethodChannel? = null
    private var pendingPayload: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, NFC_CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            if (call.method == "getPendingPayload") {
                result.success(pendingPayload)
                pendingPayload = null
            } else {
                result.notImplemented()
            }
        }

        timerChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TIMER_CHANNEL)
        timerChannel?.setMethodCallHandler { call, result ->
            when (call.method) {
                "scheduleTimerAlarm" -> {
                    val triggerAtMillis = (call.argument<Number>("triggerAtMillis"))?.toLong() ?: 0L
                    val title = call.argument<String>("title") ?: "Timer Finished"
                    val label = call.argument<String>("label") ?: "Focus Session"
                    scheduleAlarm(triggerAtMillis, title, label)
                    result.success(true)
                }
                "cancelTimerAlarm" -> {
                    cancelAlarm()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun scheduleAlarm(triggerAtMillis: Long, title: String, label: String) {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
        val intent = Intent(this, TimerAlarmReceiver::class.java).apply {
            putExtra("title", title)
            putExtra("label", label)
        }
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            1001,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            alarmManager.setExactAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        } else {
            alarmManager.setExact(
                AlarmManager.RTC_WAKEUP,
                triggerAtMillis,
                pendingIntent
            )
        }
    }

    private fun cancelAlarm() {
        val alarmManager = getSystemService(Context.ALARM_SERVICE) as? AlarmManager ?: return
        val intent = Intent(this, TimerAlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            this,
            1001,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)

        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
        notificationManager?.cancel(1001)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        handleIntent(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent?) {
        if (intent == null) return
        if (NfcAdapter.ACTION_NDEF_DISCOVERED == intent.action) {
            val rawMsgs = intent.getParcelableArrayExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)
            if (rawMsgs != null && rawMsgs.isNotEmpty()) {
                val msg = rawMsgs[0] as NdefMessage
                val record = msg.records[0]
                
                // Parse text or URI record
                val text = parseNdefRecord(record)
                if (text != null) {
                    if (channel != null) {
                        channel?.invokeMethod("onNfcTagScanned", text)
                    } else {
                        pendingPayload = text
                    }
                }
            }
        }
    }

    private fun parseNdefRecord(record: NdefRecord): String? {
        val tnf = record.tnf
        if (tnf == NdefRecord.TNF_WELL_KNOWN) {
            val type = record.type
            if (type.contentEquals(NdefRecord.RTD_TEXT)) {
                try {
                    val payload = record.payload
                    val langLen = (payload[0].toInt() and 0x3F)
                    return String(payload, 1 + langLen, payload.size - 1 - langLen, Charsets.UTF_8)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            } else if (type.contentEquals(NdefRecord.RTD_URI)) {
                try {
                    val payload = record.payload
                    val prefix = getUriPrefix(payload[0])
                    val uriString = String(payload, 1, payload.size - 1, Charsets.UTF_8)
                    return prefix + uriString
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
        return null
    }

    private fun getUriPrefix(prefixCode: Byte): String {
        return when (prefixCode.toInt()) {
            0x00 -> ""
            0x01 -> "http://www."
            0x02 -> "https://www."
            0x03 -> "http://"
            0x04 -> "https://"
            0x05 -> "tel:"
            0x06 -> "mailto:"
            else -> ""
        }
    }
}
