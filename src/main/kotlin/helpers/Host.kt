package helpers

import org.slf4j.LoggerFactory
import java.net.InetAddress

object Host {
    private val log = LoggerFactory.getLogger(Host::class.java)
    val name = refreshHostName()

    private fun refreshHostName(): String {
        try {
            val addr = InetAddress.getLocalHost()
            return addr.hostName
        } catch (e: Exception) {
            log.warn("can't get hostname", e)
            return "unknown host"
        }
    }
}