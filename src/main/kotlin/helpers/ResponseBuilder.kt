package helpers

import com.fasterxml.jackson.databind.ObjectMapper
import org.slf4j.LoggerFactory
import java.io.PrintWriter
import java.io.StringWriter

//typealias ResponseMap = kotlin.collections.mutableMapOf<String, Any>
class ResponseBuilder(val verbose:Boolean, val parserInstance:ObjectMapper){
    constructor():this(false, ObjectMapper())
    constructor(verbose: Boolean):this(verbose, ObjectMapper())
    constructor(parserInstance:ObjectMapper):this(false, parserInstance)

    private val log = LoggerFactory.getLogger(ResponseBuilder::class.java)

    private val header = mutableMapOf<String,Any>(
            "trace_id" to "xxxxxxxxxx",
            "status" to "999",
            "msg" to ""
    )

    private val body = mutableMapOf<String,Any>()

    fun traceId(traceId:String):ResponseBuilder{
        header.put("trace_id", traceId)
        return this
    }

    fun status(status:String):ResponseBuilder{
        header.put("status", status)
        return this
    }

    fun msg(msg:String):ResponseBuilder{
        header.put("msg", msg)
        return this
    }

    fun beganAt(beganAt: Any): ResponseBuilder {
        header.put("began_at", beganAt.toString())
        return this
    }

    fun endedAt(endedAt: Any): ResponseBuilder {
        header.put("ended_at", endedAt.toString())
        return this
    }

    /**
     * 此欄位要在一開始verbose設定為true時才會生效
     */
    fun stackTrace(e: Exception): ResponseBuilder {
        if (!this.verbose)
            return this

        val writer = StringWriter()
        e.printStackTrace(PrintWriter(writer))
        header.put("stacktrace", writer.toString())
        return this
    }

    fun put(key: String, value: Any): ResponseBuilder {
        body.put(key, value)
        return this
    }

    override fun toString(): String {
        val rsp = mutableMapOf<String,Any>()
        rsp.put("header", header)
        if(body.size!=0) {
            rsp.put("body", body)
        }
        return parserInstance.writeValueAsString(rsp)
    }
}