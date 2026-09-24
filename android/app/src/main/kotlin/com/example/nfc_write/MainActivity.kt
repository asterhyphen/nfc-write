package dev.aster.nfc_write

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.os.Build
import android.os.Bundle
import androidx.core.app.NotificationCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val NFC_CHANNEL = "dev.aster.nfc_write/nfc"
    private val TIMER_CHANNEL = "dev.aster.nfc_write/timer"
    private val ONGOING_NOTIFICATION_ID = 1002
    private val ALARM_NOTIFICATION_ID = 1001
    private val LIVE_CHANNEL_ID = "tiptaptup_timer_live_channel"

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
                "showOngoingNotification" -> {
                    val whenMillis = (call.argument<Number>("whenMillis"))?.toLong() ?: 0L
                    val label = call.argument<String>("label") ?: "Timer"
                    val isCountdown = call.argument<Boolean>("isCountdown") ?: true
                    showOngoingNotification(whenMillis, label, isCountdown)
                    result.success(true)
                }
                "hideOngoingNotification" -> {
                    hideOngoingNotification()
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

    private fun showOngoingNotification(whenMillis: Long, label: String, isCountdown: Boolean) {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager ?: return

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                LIVE_CHANNEL_ID,
                "Live Timer Countdown",
                NotificationManager.IMPORTANCE_LOW
            ).apply {
                description = "Live ticking timer countdown on lock screen and notification bar"
                setShowBadge(false)
                enableVibration(false)
                setSound(null, null)
            }
            notificationManager.createNotificationChannel(channel)
        }

        val launchIntent = Intent(this, MainActivity::class.java).apply {
            flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        val pendingIntent = PendingIntent.getActivity(
            this,
            1002,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val title = if (isCountdown) "⏳ $label" else "⏱️ $label"
        val subtitle = if (isCountdown) "Counting down…" else "Focus flow in progress…"

        val builder = NotificationCompat.Builder(this, LIVE_CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle(title)
            .setContentText(subtitle)
            .setWhen(whenMillis)
            .setUsesChronometer(true)
            .setChronometerCountDown(isCountdown)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setPriority(NotificationCompat.PRIORITY_LOW)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)
            .setContentIntent(pendingIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)

        notificationManager.notify(ONGOING_NOTIFICATION_ID, builder.build())
    }

    private fun hideOngoingNotification() {
        val notificationManager = getSystemService(Context.NOTIFICATION_SERVICE) as? NotificationManager
        notificationManager?.cancel(ONGOING_NOTIFICATION_ID)
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
        notificationManager?.cancel(ALARM_NOTIFICATION_ID)
        notificationManager?.cancel(ONGOING_NOTIFICATION_ID)
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
