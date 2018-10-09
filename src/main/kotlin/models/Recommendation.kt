package models

import helpers.Configurations
import libs.datetime.Datetime
import libs.sql.connections.JdbcFactory
import org.slf4j.LoggerFactory

class Recommendation(val env:String):AutoCloseable{
    private val log = LoggerFactory.getLogger(this.javaClass)

    private val cn = JdbcFactory.newPostgreSql(Configurations.toDbOptions("recommendation.db"))

    private val importHistories = if(env=="production") "import_histories" else "import_histories_preview"
    private val trainingHistoriesPreview = if(env=="production") "training_histories" else "training_histories_preview"
    private val recommendationForUsers = if(env=="production") "recommendation_for_users" else "recommendation_for_users_preview"

    fun selectTransactions(wsSeq:String, memberId:String, from:Datetime, end:Datetime):List<Map<String,String>>{
        val cmd = """
        |SELECT id,ws_seq,tranid,tran_date,member_id,sm_seq,sm_name,quantity,cp_name,created_at
        |FROM transactions
        |where member_id = '$memberId'
        |and ws_seq = '$wsSeq'
        |and tran_date >= '$from'
        |and tran_date <= '$end'
        |ORDER BY tran_date
        """.trimMargin()
        log.info(cmd)
        return cn.queryToMap(cmd)
    }

    fun selectRecentMemberIds(from:Datetime):List<String>{
        val cmd = """
        |select distinct member_id
        |from ${recommendationForUsers}
        |where created_at >= '${from}'
        """.trimMargin()
        log.info(cmd)
        return cn.query(cmd){it["member_id"]}
    }

    fun selectRecommendationForUsers(memberId:String):Map<String,String>{
        val cmd = """
        |select *
        |from $recommendationForUsers
        |where member_id = '$memberId'
        |order by created_at desc
        |limit 1
        """.trimMargin()
        log.info(cmd)
        return cn.queryToMap(cmd).first()
    }


    fun selectTrainingHistories():List<Map<String,String>>{
        val cmd = """
        |SELECT *
        |FROM ${trainingHistoriesPreview}
        |ORDER BY id desc
        |limit 200
        """.trimMargin()
        log.info(cmd)
        return cn.queryToMap(cmd)
    }

    fun selectImportHistories():List<Map<String,String>>{
        val cmd = """
        |SELECT *
        |FROM ${importHistories}
        |ORDER BY id desc
        |limit 200
        """.trimMargin()
        log.info(cmd)
        return cn.queryToMap(cmd)
    }


    override fun close() {
        cn.close()
    }
}