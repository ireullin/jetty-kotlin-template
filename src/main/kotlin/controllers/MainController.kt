package controllers

import helpers.*
import org.slf4j.LoggerFactory
import javax.servlet.ServletConfig
import javax.servlet.annotation.MultipartConfig
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@MultipartConfig
class MainController : HttpServlet() {
    private val log = LoggerFactory.getLogger(MainController::class.java)
    private val ENV = Conf["env.name"]
    private val PREFIX_URL = "/${Conf["env.ver"]}/jetty-kotlin-template"

    override fun destroy() {
        super.destroy()
    }

    override fun init(config: ServletConfig?) {
        super.init(config)
    }

    override fun doPost(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        doForAnyRequests(req, rsp)
    }

    override fun doGet(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        doForAnyRequests(req, rsp)
    }

    private fun doForAnyRequests(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        try {
            ResponseExample.setUtf8Encoding(req, rsp)
            routeMap(Router(req,rsp))
        }
        catch (e:Exception){
            println("badRequest")
            log.info(e.message, e)
            ResponseExample.badRequest(req, rsp)
        }
    }

    private fun routeMap(router:Router) {
        router
        .ifMatch("GET", "$PREFIX_URL/vue_test", { VueTest(it).run() })
        .ifMatch("GET", "$PREFIX_URL/info", this::showInfo)
        .ifMatch("GET", "$PREFIX_URL/host", this::showHost)
        .elseDo(this::showNotFound)
    }

    private fun showHost(session: Session){
        session.rsp?.outputStream?.print(Host.name)
    }

    private fun showInfo(session: Session){
        session.render(Conf.toString())
    }

    private fun showNotFound(session: Session){
        ResponseExample.notFound(session.req, session.rsp)
    }
}