package helpers

import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

typealias RouteCallback = (Session) -> Unit
class Session(val req: HttpServletRequest?, val rsp: HttpServletResponse?, val params:ParamsOfMap){
    init{
        req?.setAttribute("params", params)
    }

    fun renderJsp(pageName:String){
        req?.getRequestDispatcher(pageName)?.forward(req,rsp)
    }

    fun render(content:String){
        rsp?.outputStream?.print(content)
        rsp?.outputStream?.flush()
    }

    operator fun get(paramsKey:String) = params[paramsKey]
}