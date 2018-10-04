package controllers

import com.google.common.cache.Cache
import com.google.common.cache.CacheBuilder
import helpers.Session
import libs.datetime.ImmutableDatetime
import libs.datetime.days
import libs.datetime.now
import libs.json.Json
import libs.json.toJson
import models.Recommendation
import models.ShowMainDoc
import models.ShowMainDuplication
import org.slf4j.LoggerFactory
import java.util.concurrent.TimeUnit

class Pedm(val session: Session){

    private val log = LoggerFactory.getLogger(this.javaClass)

    companion object {
        val cache: Cache<String, List<String>> = CacheBuilder
                .newBuilder()
                .expireAfterWrite(12, TimeUnit.HOURS)
                .build()
    }

    fun index(){
        session.renderJsp("/views/pedm/Index.jsp")
    }

    fun selectTransactions(){
        val env = session["env"]!!
        val memberId = session["member_id"]!!
        val from = (now() - 30.days).toBeginOfDay()
        val transactions = Recommendation(env).use { it.selectTransactions(memberId, from) }
                .groupBy { it["tranid"] }
                .toJson()

        session.render(transactions)
    }

    fun selectPrediction(){
        try {
            val env = session["env"]!!
            val memberId = session["member_id"]!!
            val predictionRow = Recommendation(env).use { it.selectPrediction(memberId) }
            val predictions = Json.parse(predictionRow["recommendation_list"]!!)
                    .map {
                        val doc = ShowMainDuplication.queryBySmSeq(it["sm_seq"]?.asText()?:"")?: ShowMainDoc()
                        mapOf(
                                "smSeq" to (it["sm_seq"]?.asText()?:""),
                                "from" to it["cpname_from"]?.joinToString(","){ it.asText()?:"" },
                                "ref" to (it["ref"]?.asText()?:""),
                                "cpName" to doc.cpName,
                                "smPic" to doc.smPic,
                                "smName" to doc.smName
                        )
                    }

            session.render(predictions.toJson())
        }
        catch (e:Exception){
            log.info(e.message, e)
            session.render("{}")
        }
    }

    fun selectMembers(){
        val memberIds = cache.get("memberIds") {
            val from = (now() - 30.days).toBeginOfDay()
            models.Recommendation(session["env"]!!).use { it.selectRecentMemberIds(from) }
        }.toJson()
//        log.info(memberIds)
        session.render(memberIds)
    }

    fun trainingHistories(){
        val histories = models.Recommendation(session["env"]!!).use { it.selectTrainingHistories() }
        session.params.put("histories", histories.toJson())
        session.renderJsp("/views/pedm/TrainingHistories.jsp")
    }

    fun importHistories(){
        val histories = models.Recommendation(session["env"]!!).use { it.selectImportHistories() }
        session.params.put("histories", histories.toJson())
        session.renderJsp("/views/pedm/ImportHistories.jsp")
    }
}