package helpers

import libs.datetime.ImmutableDatetime
import org.slf4j.LoggerFactory
import java.net.InetAddress
import java.math.BigInteger
import com.oracle.util.Checksums.update
import java.security.MessageDigest



object UniqueID {

    private val log = LoggerFactory.getLogger(UniqueID::class.java)
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

    fun md5():String{
        try {
            val  instance:MessageDigest = MessageDigest.getInstance("MD5")//获取md5加密对象
            val digest:ByteArray = instance.digest(plain().toByteArray())//对字符串加密，返回字节数组
            var sb : StringBuffer = StringBuffer()
            for (b in digest) {
                var i :Int = b.toInt() and 0xff//获取低八位有效值
                var hexString = Integer.toHexString(i)//将整数转化为16进制
                if (hexString.length < 2) {
                    hexString = "0" + hexString//如果是一位的话，补0
                }
                sb.append(hexString)
            }
            return sb.toString()

        } catch (e: Exception) {
            val msg = "caculate md5 failed"
            log.warn(msg, e)
            return "";
        }
    }


    fun plain(): String {
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
