package controllers

import helpers.Conf
import helpers.Session
import libs.json.toJson
import models.ShowMainDuplication
import org.slf4j.LoggerFactory
import java.util.*
import kotlin.concurrent.schedule

class ShowMain(val session: Session){

    companion object {
        private val log = LoggerFactory.getLogger("ShowMainController")

        private var timer:TimerTask? = null

        fun startTimer(){
            log.info("refresh ShowMain")
            refreshShowMain()
            timer = Timer().schedule(1*60*60*1000){ startTimer()}
        }

        fun refreshShowMain() = ShowMainDuplication.duplicate(Conf["env.name"],"AW002052")
    }

    fun selectShowMain(){
        try {
            val doc = ShowMainDuplication.queryBySmSeq(session["sm_seq"]!!)!!
            session.render(doc.toJson())
        }
        catch (e:Exception){
            session.render("not fount. "+e.message)
        }
    }

    fun refreshShowMain(){
        try {
            ShowMain.refreshShowMain()
            session.render("ok")
        }
        catch (e:Exception){
            session.render("failed because of "+e.message)
        }

    }
}