import controllers.Pedm
import controllers.RelatedItems
import controllers.ShowMain
import helpers.*
import libs.json.toJson
import models.ShowMainDuplication
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
        router.ifMatch("GET",    "/refresh_show_main"){ ShowMain(it).refreshShowMain() }
                .ifMatch("GET",  "/select_show_main/:sm_seq"){ ShowMain(it).selectShowMain() }

                .ifMatch("GET",  "/:env/pedm/import_histories"){ Pedm(it).importHistories() }
                .ifMatch("GET",  "/:env/pedm/training_histories"){ Pedm(it).trainingHistories() }
                .ifMatch("GET",  "/:env/pedm/select_members"){ Pedm(it).selectMembers() }
//                .ifMatch("GET",  "/:env/pedm/select_transactions/:member_id"){ Pedm(it).selectTransactions() }
                .ifMatch("GET",  "/:env/pedm/select_prediction/:member_id"){ Pedm(it).selectPrediction() }
                .ifMatch("GET",  "/:env/pedm"){ Pedm(it).index() }
                .ifMatch("GET",  "/:env/pedm/:member_id"){ Pedm(it).index() }
                .ifMatch("GET",  "/:env/pedm/:member_id/:training_id"){ Pedm(it).index() }

                .ifMatch("GET",  "/:env/related_items/select_prediction/:sm_seq"){ RelatedItems(it).selectPrediction() }
                .ifMatch("GET",  "/:env/related_items/select_items"){ RelatedItems(it).selectItems() }
                .ifMatch("GET",  "/:env/related_items/stories"){ RelatedItems(it).histories() }
                .ifMatch("GET",  "/:env/related_items"){ RelatedItems(it).index() }
                .ifMatch("GET",  "/:env/related_items/:sm_seq"){ RelatedItems(it).index() }
                .ifMatch("GET",  "/:env/related_items/:sm_seq/:training_id"){ RelatedItems(it).index() }



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
        ShowMain.startTimer()
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