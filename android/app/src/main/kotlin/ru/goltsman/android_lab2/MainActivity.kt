package ru.goltsman.android_lab2

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.ContactsContract
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "ru.goltsman.android_lab2/contacts"
    private val permissionRequestCode = 408456

    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
            .setMethodCallHandler { call, result -> handleCall(call, result) }
    }

    private fun handleCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "checkPermission" -> result.success(currentPermission())
            "requestPermission" -> requestPermission(result)
            "openAppSettings" -> result.success(openAppSettings())
            "readContacts" -> readContacts(result)
            else -> result.notImplemented()
        }
    }

    private fun currentPermission(): String {
        val granted = checkSelfPermission(Manifest.permission.READ_CONTACTS) ==
            PackageManager.PERMISSION_GRANTED

        if (granted) {
            return "granted"
        }

        if (shouldShowRequestPermissionRationale(Manifest.permission.READ_CONTACTS)) {
            return "denied"
        }

        return if (wasRequestedBefore()) "permanentlyDenied" else "denied"
    }

    private fun wasRequestedBefore(): Boolean {
        val preferences = getSharedPreferences("lab2_permissions", MODE_PRIVATE)

        return preferences.getBoolean("contacts_requested", false)
    }

    private fun markRequested() {
        getSharedPreferences("lab2_permissions", MODE_PRIVATE)
            .edit()
            .putBoolean("contacts_requested", true)
            .apply()
    }

    private fun requestPermission(result: MethodChannel.Result) {
        if (currentPermission() == "granted") {
            result.success("granted")
            return
        }

        if (pendingResult != null) {
            result.error("ALREADY_RUNNING", "Запрос разрешения уже выполняется", null)
            return
        }

        pendingResult = result

        markRequested()

        requestPermissions(arrayOf(Manifest.permission.READ_CONTACTS), permissionRequestCode)
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)

        if (requestCode != permissionRequestCode) {
            return
        }

        val result = pendingResult
        pendingResult = null

        result?.success(currentPermission())
    }

    private fun openAppSettings(): Boolean {
        return try {
            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.fromParts("package", packageName, null)
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)

            startActivity(intent)

            true
        } catch (error: Exception) {
            false
        }
    }

    private fun readContacts(result: MethodChannel.Result) {
        if (currentPermission() != "granted") {
            result.error("PERMISSION_DENIED", "Нет разрешения READ_CONTACTS", null)
            return
        }

        try {
            result.success(queryContacts())
        } catch (error: Exception) {
            result.error("READ_FAILED", error.message, null)
        }
    }

    private fun queryContacts(): List<Map<String, Any?>> {
        val contacts = LinkedHashMap<String, MutableMap<String, Any?>>()

        val projection = arrayOf(
            ContactsContract.Data.CONTACT_ID,
            ContactsContract.Data.DISPLAY_NAME_PRIMARY,
            ContactsContract.Data.MIMETYPE,
            ContactsContract.Data.DATA1,
            ContactsContract.Data.DATA2
        )

        val cursor = contentResolver.query(
            ContactsContract.Data.CONTENT_URI,
            projection,
            null,
            null,
            ContactsContract.Data.DISPLAY_NAME_PRIMARY + " ASC"
        ) ?: return emptyList()

        cursor.use {
            val idIndex = it.getColumnIndexOrThrow(ContactsContract.Data.CONTACT_ID)
            val nameIndex = it.getColumnIndexOrThrow(ContactsContract.Data.DISPLAY_NAME_PRIMARY)
            val mimeIndex = it.getColumnIndexOrThrow(ContactsContract.Data.MIMETYPE)
            val valueIndex = it.getColumnIndexOrThrow(ContactsContract.Data.DATA1)

            while (it.moveToNext()) {
                val id = it.getString(idIndex) ?: continue
                val name = it.getString(nameIndex) ?: ""
                val mimeType = it.getString(mimeIndex) ?: ""
                val value = it.getString(valueIndex)

                val contact = contacts.getOrPut(id) {
                    mutableMapOf(
                        "id" to id,
                        "displayName" to name,
                        "phones" to mutableListOf<Map<String, String>>(),
                        "emails" to mutableListOf<Map<String, String>>(),
                        "organization" to null,
                        "note" to null,
                        "birthday" to null
                    )
                }

                if (value.isNullOrBlank()) {
                    continue
                }

                when (mimeType) {
                    ContactsContract.CommonDataKinds.Phone.CONTENT_ITEM_TYPE -> {
                        @Suppress("UNCHECKED_CAST")
                        val phones = contact["phones"] as MutableList<Map<String, String>>
                        phones.add(mapOf("label" to "mobile", "number" to value))
                    }

                    ContactsContract.CommonDataKinds.Email.CONTENT_ITEM_TYPE -> {
                        @Suppress("UNCHECKED_CAST")
                        val emails = contact["emails"] as MutableList<Map<String, String>>
                        emails.add(mapOf("label" to "personal", "address" to value))
                    }

                    ContactsContract.CommonDataKinds.Organization.CONTENT_ITEM_TYPE -> {
                        contact["organization"] = value
                    }

                    ContactsContract.CommonDataKinds.Note.CONTENT_ITEM_TYPE -> {
                        contact["note"] = value
                    }

                    ContactsContract.CommonDataKinds.Event.CONTENT_ITEM_TYPE -> {
                        contact["birthday"] = value
                    }
                }
            }
        }

        return contacts.values.toList()
    }
}
