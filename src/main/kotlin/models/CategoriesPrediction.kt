package models

import controllers.PredictionCRUD
import helpers.Conf
import libs.datetime.ImmutableDatetime
import libs.sql.connections.PostgreSqlConnection
import org.slf4j.LoggerFactory

class CategoriesPrediction:AutoCloseable{
    private val log = LoggerFactory.getLogger(CategoriesPrediction::class.java)

    private val cn = PostgreSqlConnection(Conf.toDbOptions("db1"))

    fun selectPredictions(predictedHistoryId:String, offset:Int, limit:Int):List<Map<String,String>>{
        val cmd = """
            select * from predictions
            where predicted_history_id = '$predictedHistoryId'
            order by id
            offset $offset limit $limit
            """.trimIndent()
        return this.cn.queryToMap(cmd)
    }

    fun selectPredictedHistories()
            = this.cn.queryToMap("select * from predicted_histories order by id desc")

    fun selectPredictedHistory(id:String)
            = this.cn.queryToMap("select * from predicted_histories where id = $id order by id desc").get(0)

    fun updateAnswerOnPredictions(id:String, answer:String, correctedCategoryNo:String, correctedCategory:String){
        val cmd = """
            update predictions
            set answer='$answer',
            corrected_category_no='$correctedCategoryNo',
            corrected_category='$correctedCategory',
            updated_at='${ImmutableDatetime.now()}'
            where id = $id
            """.trimIndent()

//        println(cmd)
        this.cn.execMutiCommands(cmd);

    }


    override fun close() {
        this.cn.close()
    }
}