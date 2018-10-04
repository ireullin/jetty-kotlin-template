package models

import helpers.Conf
import libs.sql.connections.JdbcFactory
import org.slf4j.LoggerFactory

class RelatedItems(val env:String):AutoCloseable{
    private val log = LoggerFactory.getLogger(this.javaClass)

    private val cn = JdbcFactory.newPostgreSql(Conf.toDbOptions("related_items.db"))

    private val predictionsForItems = if(env=="production") "predictions_for_items" else "predictions_for_items_preview"
    private val trainingHistories = if(env=="production") "training_histories" else "training_histories_preview"

    fun selectPrediction(smSeq:String):Map<String,String>{
        val cmd = """
        |SELECT *
        |FROM ${predictionsForItems}
        |WHERE sm_seq = '${smSeq}'
        |ORDER BY created_at DESC LIMIT 1
        """.trimMargin()
        log.info(cmd)
        return cn.queryToMap(cmd).first()
    }

    fun selectTrainingHistories():List<Map<String,String>>{
        val cmd = """
        |SELECT *
        |FROM ${trainingHistories}
        |ORDER BY id desc
        """.trimMargin()
        log.info(cmd)
        return cn.queryToMap(cmd)
    }


    override fun close() {
        this.cn.close()
    }
}