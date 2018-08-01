package controllers

import helpers.Session
import libs.http.SimpleSender

class VueTest(val session: Session){

    fun run(){

        session.renderJsp("/views/VueTest.jsp")
    }
}