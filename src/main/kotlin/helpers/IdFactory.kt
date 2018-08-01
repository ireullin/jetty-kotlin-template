package helpers

import libs.datetime.ImmutableDatetime
import org.slf4j.LoggerFactory
import java.net.InetAddress

object IdFactory {

    private val log = LoggerFactory.getLogger(IdFactory::class.java)
    private var seq = 1
    private val ID_LOCK = Any()
    private var prefix: String = prefix()

    private fun prefix(): String {
        try {
            val addr = InetAddress.getLocalHost()
            prefix = addr.hostName
            return prefix
        } catch (ex: Exception) {
            log.warn("get hostname failed")
            return ""
        }
    }


    fun generate(): String {
        var currentSeq = 0
        synchronized(ID_LOCK) {
            if (seq > 999) {
                seq = 1
            }

            currentSeq = seq
            seq++
        }

        val sb = StringBuilder(50)
        sb.append(prefix()).append("-")
        try {
            sb.append(ImmutableDatetime.now().toString("yyyyMMddHHmmssSSS"))
        } catch (e: Exception) {
            val msg = "generate timestamp failed"
            log.warn(msg, e)
            sb.append("00000000000000000")
        }

        sb.append(String.format("%03d", currentSeq))
        return sb.toString()
    }


}
