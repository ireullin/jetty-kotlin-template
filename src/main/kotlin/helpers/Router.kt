package helpers

import org.slf4j.LoggerFactory
import java.util.stream.Collectors
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse



typealias ParamsOfMap = MutableMap<String,String>
class Router(req: HttpServletRequest?, rsp: HttpServletResponse?, val contextPath:String) {

    private val log = LoggerFactory.getLogger(Router::class.java)
    private val req = req
    private val rsp = rsp
    private var hasDone = false
    private val uris = req?.requestURI?.split("/")

    fun hasDone() = this.hasDone

    fun elseDo(callback: RouteCallback){
        if(this.hasDone) {
            return
        } else{
            val session = Session(req, rsp, mutableMapOf())
            callback(session)
        }
    }

    fun ifMatch(method:String, pattern:String, callback:RouteCallback):Router{
        if(this.hasDone){
            return this
        }
        if(req?.method?.toUpperCase()!=method.toUpperCase()) {
            return this
        }
        val params = match(pattern)
        if(params==null){
            return this
        }
        // getReader跟getParameterMap只能用一個
        if(req?.method?.toUpperCase()=="POST"){
            val body = req.reader.lines().collect(Collectors.joining("\n"))
            params.put("__body__", body)
        }
        else{
            req?.parameterMap?.forEach({k,v -> params.put(k, v[0])})
        }

        val session = Session(req,rsp,params)
        callback(session)
        this.hasDone = true
        return this
    }


    private fun match(pattern:String):ParamsOfMap?{
        val patterns = (contextPath+pattern).split("/")
        if(patterns.size!=uris?.size)
            return null

        val params = mutableMapOf<String,String>()
        params.put("__path__",contextPath)
        for((i,p) in patterns.withIndex()){
            if(p.length>0 && p[0]==':'){
                params.put(p.substring(1), uris[i])
            }
            else if(p==uris[i]){
                // pass verification, do nothing
            }
            else {
                return null
            }
        }
        return params
    }
}