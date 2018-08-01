package helpers

import org.slf4j.LoggerFactory
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

object ResponseExample {
    private val log = LoggerFactory.getLogger(ResponseExample::class.java)

    fun notFound(req: HttpServletRequest?, rsp: HttpServletResponse?): HttpServletResponse? {
        rsp?.status = 404
        val out = rsp?.outputStream
        out?.print("not found")
        out?.flush()
        return rsp
    }

    fun badRequest(req: HttpServletRequest?, rsp: HttpServletResponse?): HttpServletResponse? {
        rsp?.status = 400
        val out = rsp?.outputStream
        out?.print("bad request")
        out?.flush()
        return rsp
    }

    fun setUtf8Encoding(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        req?.characterEncoding = "UTF-8"
        rsp?.characterEncoding = "UTF-8"
    }
}
