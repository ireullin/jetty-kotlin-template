package controllers

import helpers.ResponseBuilder
import helpers.Session
import libs.json.Json
import libs.json.toJson
import models.ShowMainDoc
import models.ShowMainDuplication
import org.slf4j.LoggerFactory


class RelatedItems(val session: Session){
    private val log = LoggerFactory.getLogger(this.javaClass)

    fun index(): Unit {
        session.renderJsp("/views/alsoView/index.jsp")
    }

    fun selectItems(){
        val env = session["env"]!!
        val items = ShowMainDuplication.queryAllData().map { mapOf(
                "smSeq" to it.smSeq,
                "smName" to it.smName,
                "cpName" to it.cpName
        ) }
        session.render(items.toJson())
    }

    fun selectPrediction(): Unit {
        val sm = ShowMainDuplication
        try {
            val smSeq = session["sm_seq"]!!
            val env = session["env"]!!
            val mainItem = sm.queryBySmSeq(smSeq)!!
            log.info("mainItem="+mainItem.toJson())
            val predictionRows = models.AlsoView(env).use { it.selectPrediction(smSeq) }
            log.info(predictionRows["predictions"])
            val predictions = mutableMapOf<String,List<Map<String,String>>>()
            val root = Json.parse(predictionRows["predictions"]?:"[]")
            root.fields().forEach { (nameOfAlgorithm,nodeOfAlgorithm) ->
                val details = nodeOfAlgorithm.map {
                    val smSeq = it["sm_seq"]?.asText() ?: ""
                    val doc = try{
                        ShowMainDuplication.queryBySmSeq(smSeq)!!
                    }catch (e:Exception){
                        log.info("smSeq:$smSeq not found")
                        ShowMainDoc()
                    }

                    mapOf(
                            "smSeq" to smSeq,
                            "smName" to doc.smName,
                            "cpName" to doc.cpName,
                            "smPic" to doc.smPic,
                            "ref" to (it["ref"]?.asText()?:""),
                            "score" to (it["score"]?.asText()?:"")
                    )

                }
                predictions.put(nameOfAlgorithm, details)
            }


            val rsp = mapOf(
                    "id" to predictionRows["id"],
                    "mainItem" to mainItem,
                    "relatedItems" to predictions,
                    "createdAt" to predictionRows["created_at"]
            )
            session.render(rsp.toJson())
        }
        catch (e:Exception){
            log.info(e.message, e)
            session.render("{}")
        }
    }
}