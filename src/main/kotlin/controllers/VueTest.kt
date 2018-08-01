package controllers

import helpers.RouterSession

class VueTest(val session: RouterSession){

    fun run(){
        session.params.put("fuck","mother fuck")
        session.renderJsp("/views/VueTest.jsp")
    }
}