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

//    fun selectTransactions(){
//        val env = session["env"]!!
//        val memberId = session["member_id"]!!
//        val from = (now() - 30.days).toBeginOfDay()
//        val transactions = Recommendation(env).use { it.selectTransactions(memberId, from) }
//                .groupBy { it["tranid"] }
//                .toJson()
//
//        session.render(transactions)
//
//    }

    fun selectPrediction(){
        try {
            val env = session["env"]!!
            val memberId = session["member_id"]!!
            val wsSeq = "AW002052"
            Recommendation(env).use {cn ->
                val p = cn.selectRecommendationForUsers(memberId)
                val tranDate = ImmutableDatetime.readFrom(p["created_at"]!!, "yyyy-MM-dd HH:mm:ss").toBeginOfDay()
                val tranDate1MonthAgo = tranDate - 30.days
                val tranHistories = cn.selectTransactions(wsSeq, memberId, tranDate1MonthAgo, tranDate)
                        .groupBy { it["cp_name"] }
                        .mapValues {(_,v) -> v.sortedBy { -ImmutableDatetime.readFrom(p["created_at"]!!, "yyyy-MM-dd HH:mm:ss").stamp() }}

                data class prediction(val smSeq:String, val smName:String, val cpName:String, val smPic:String, val ref:String, val from:List<String>)

                val predictions = Json.parse(p["recommendation_list"]!!)
                        .map{ n ->
                            val doc = ShowMainDuplication.queryBySmSeq(n["sm_seq"]?.asText()?:"")?: ShowMainDoc()
                            prediction(
                                    n["sm_seq"]?.asText()?:"",
                                    doc.smName, doc.cpName, doc.smPic,
                                    n["ref"]?.asText()?:"",
                                    n["cpname_from"]?.map{it.asText()}?: listOf()
                            )
                        }
                        .filter { it.smName != "" }
                        .groupBy { it.from.sorted() }
                        .mapValues { (cpnames, predictions) ->
                            val becauseOf = cpnames.flatMap { cpName ->
                                val trans = tranHistories[cpName]?: listOf()
                                trans.map{
                                    mapOf(
                                            "tranId" to it["tranid"],
                                            "tranDate" to it["tran_date"],
                                            "smSeq" to it["sm_seq"],
                                            "smName" to it["sm_name"],
                                            "cpName" to it["cp_name"],
                                            "quantity" to it["quantity"]
                                    )
                                }
                            }
                            mapOf("predictions" to predictions, "becauseOf" to becauseOf)
                        }
                        .toJson()

//                val boughtAfterPredicted = cn.selectTransactions(wsSeq, memberId, tranDate, now())
                session.render(predictions)
            }
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