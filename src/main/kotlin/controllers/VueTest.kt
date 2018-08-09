package controllers

import helpers.Conf
import helpers.UniqueID
import helpers.Session
import org.slf4j.LoggerFactory

class VueTest(val session: Session){
    private val log = LoggerFactory.getLogger(VueTest::class.java)
    val traceId = UniqueID.plain()

    fun run(){

        session.renderJsp("/views/VueTest.jsp")
    }
}