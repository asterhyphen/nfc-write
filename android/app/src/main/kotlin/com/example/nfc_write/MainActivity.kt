package dev.aster.nfc_write

import android.content.Intent
import android.nfc.NfcAdapter
import android.nfc.NdefMessage
import android.nfc.NdefRecord
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "dev.aster.nfc_write/nfc"
    private var channel: MethodChannel? = null
    private var pendingPayload: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        channel?.setMethodCallHandler { call, result ->
            if (call.method == "getPendingPayload") {
                result.success(pendingPayload)
                pendingPayload = null
            } else {
                result.notImplemented()
            }
        }
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
