package controllers

import helpers.UniqueID
import helpers.Session
import org.slf4j.LoggerFactory

class VueTest(val session: Session){
    private val log = LoggerFactory.getLogger(VueTest::class.java)
    val traceId = UniqueID.plain()

    fun run(){
        log.info("received a request id:"+traceId)
        session.renderJsp("/views/VueTest.jsp")
    }
}