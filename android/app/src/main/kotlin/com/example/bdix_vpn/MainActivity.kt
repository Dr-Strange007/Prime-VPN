package com.example.bdix_vpn

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.engine.FlutterEngine
import android.net.TrafficStats
import android.content.Context
import android.net.ConnectivityManager
import android.os.Build
import android.net.Network


class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.bdix_vpn/trafficStats"
    private val KILL_SWITCH_CHANNEL = "com.example.bdix_vpn/killSwitch"

    private var vpnConnected = false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        startMonitoringNetwork()
        MethodChannel(flutterEngine.dartExecutor, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getTrafficStats") {
                val trafficStats = getTrafficStats()
                result.success(trafficStats)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor, KILL_SWITCH_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "checkVpnStatus") {

                if (!vpnConnected) {
                    disconnectVpn()
                    result.success("VPN disconnected due to kill switch")
                } else {
                    print("Kill switch triggered: VPN is connected")
                    result.success("VPN is connected")
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getTrafficStats(): Map<String, Int> {
        val stats = mutableMapOf<String, Int>()

        val bytesSent = TrafficStats.getTotalTxBytes()
        val bytesReceived = TrafficStats.getTotalRxBytes()

        val kbSent = if (bytesSent < 0) 0 else (bytesSent / 1024).toInt()
        val kbReceived = if (bytesReceived < 0) 0 else (bytesReceived / 1024).toInt()

        stats["bytesSent"] = kbSent
        stats["bytesReceived"] = kbReceived

        return stats
    }


    private fun startMonitoringNetwork() {
        val connectivityManager = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            connectivityManager.registerDefaultNetworkCallback(object : ConnectivityManager.NetworkCallback() {
                override fun onLost(network: Network) {
                    super.onLost(network)
                    println("Network lost detected")
                    println("VPN connected status: $vpnConnected")
                    if (vpnConnected) {
                        disconnectVpn()
                        invokeKillSwitch()  // Ensure this happens after disconnecting VPN
                    }
                }

                override fun onAvailable(network: Network) {
                    super.onAvailable(network)
                    println("Network available: $network")
                }
            })
        } else {
            println("Network monitoring not supported on this device.")
        }
    }

    private fun invokeKillSwitch() {
        try {
            if (!vpnConnected) {
                MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, KILL_SWITCH_CHANNEL).invokeMethod("checkVpnStatus", null)
                println("Kill switch invoked successfully")
            }
        } catch (e: Exception) {
            println("Kill switch invocation failed: ${e.message}")
        }
    }

    private fun connectVpn() {
        vpnConnected = true
        println("VPN connected.")
    }


    private fun disconnectVpn() {
        vpnConnected = false
        println("VPN disconnected.")
        invokeKillSwitch()
    }

}