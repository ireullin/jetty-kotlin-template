import controllers.PredictionCRUD
import controllers.VueTest
import helpers.*
import org.slf4j.LoggerFactory
import javax.servlet.ServletConfig
import javax.servlet.annotation.MultipartConfig
import javax.servlet.http.HttpServlet
import javax.servlet.http.HttpServletRequest
import javax.servlet.http.HttpServletResponse

@MultipartConfig
class RouteServlet : HttpServlet() {
    private val log = LoggerFactory.getLogger(RouteServlet::class.java)

    private fun routeMap(router:Router) {
        router.ifMatch("GET",    "/vue_test",                     { VueTest(it).run() })
                .ifMatch("GET",  "/show_histories",               { PredictionCRUD(it).showHistories() })
                .ifMatch("GET",  "/select_predictions/:id/:page", { PredictionCRUD(it).selectPredictions()} )
                .ifMatch("GET",  "/show_predictions/:id",         { PredictionCRUD(it).showPredictions()} )
                .ifMatch("POST", "/update_prediction",            { PredictionCRUD(it).updatePrediction()} )
                .ifMatch("GET",  "/info", this::showInfo)
                .ifMatch("GET",  "/host", this::showHost)
                .elseDo(this::showNotFound)
    }

    override fun destroy() {
        super.destroy()
        log.info("server has finished")
    }

    override fun init(config: ServletConfig?) {
        super.init(config)
        log.info("server has started up")
    }

    override fun doPost(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        doForAnyRequests(req, rsp)
    }

    override fun doGet(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        doForAnyRequests(req, rsp)
    }

    private fun doForAnyRequests(req: HttpServletRequest?, rsp: HttpServletResponse?) {
        try {
            val prefixUrl = this.servletContext.contextPath
            ResponseExample.setUtf8Encoding(req, rsp)
            routeMap(Router(req,rsp,prefixUrl))
        }
        catch (e:Exception){
            println("badRequest")
            log.info(e.message, e)
            ResponseExample.badRequest(req, rsp)
        }
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