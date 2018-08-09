package controllers

import helpers.ResponseBuilder
import helpers.Session
import helpers.UniqueID
import libs.datetime.ImmutableDatetime
import libs.json.Json
import models.CategoriesPrediction
import org.slf4j.LoggerFactory

class PredictionCRUD(val session: Session){
    private val log = LoggerFactory.getLogger(PredictionCRUD::class.java)
    private val beganAt = ImmutableDatetime.now()
    val traceId = UniqueID.plain()

    fun showHistories(){
        val entries = CategoriesPrediction().use {model->
            val queried = model.selectPredictedHistories()
            Json().stringify(queried)
        }
        session.params.put("entries",entries)
        session.renderJsp("/views/PredictedHistories.jsp")
    }

    fun selectPredictions(){
        val rsp = try {
            val limit = 100
            val page = session.params["page"]!!.toInt()
            val id = session.params["id"]!!
            val offset = (page-1)*limit
            val history = CategoriesPrediction().use { it.selectPredictedHistory(id) }
            val totalCount = history["row_count"]!! // 若為null就會exception
            val totalPage = Math.ceil(totalCount.toDouble()/limit).toInt()
            val docs = CategoriesPrediction().use { it.selectPredictions(id, offset, limit) }

            ResponseBuilder(false).traceId(traceId)
                    .beganAt(beganAt).endedAt(ImmutableDatetime.now()).msg("ok").status("100")
                    .put("docs", docs).put("page", page).put("total_page", totalPage)
                    .toString()

        }catch (e:Exception){
            val msg = "selectPredictions because of ${e.message} tracd_id:$traceId"
            log.warn(msg, e)
            ResponseBuilder(true).traceId(traceId)
                    .beganAt(beganAt).endedAt(ImmutableDatetime.now()).msg(msg).status("101")
                    .stackTrace(e).toString()
        }

        session.render(rsp)
    }

    fun showPredictions(){
        session.renderJsp("/views/Predictions.jsp")
    }

    fun updatePrediction(){
        val rsp = try {
            val n = Json().parse(session.body()!!)
            CategoriesPrediction().use {
                it.updateAnswerOnPredictions(
                        n["prediction_id"].asText(),
                        n["answer"].asText(),
                        n["corrected_category_no"].asText(),
                        n["corrected_category"].asText()
                )
            }
            ResponseBuilder(false).traceId(traceId)
                    .beganAt(beganAt).endedAt(ImmutableDatetime.now()).msg("ok").status("100")
                    .toString()
        }
        catch (e:Exception){
            val msg = "updatePredictionFailed because of ${e.message} tracd_id:$traceId"
            log.warn(msg, e)
            ResponseBuilder(true).traceId(traceId)
                    .beganAt(beganAt).endedAt(ImmutableDatetime.now()).msg(msg).status("101")
                    .stackTrace(e).toString()
        }
        session.render(rsp)
    }

}