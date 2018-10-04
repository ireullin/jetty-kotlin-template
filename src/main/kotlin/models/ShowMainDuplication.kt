package models

import com.fasterxml.jackson.databind.JsonNode
import helpers.Conf
import libs.datetime.now
import libs.json.Json
import org.slf4j.LoggerFactory
import solrdao.SolrDao
import solrdao.option.Options
import java.util.concurrent.Callable
import java.util.concurrent.ConcurrentHashMap
import java.util.concurrent.Executors

object ShowMainDuplication{

    private val log = LoggerFactory.getLogger(this.javaClass)

    private val collection = "a-zh-tw-show-main"
    private val handler = "select"
    private val data = arrayListOf<ShowMainDoc>()
    private val indexSmSeq = ConcurrentHashMap<String,ShowMainDoc>()
    private val indexCpName = ConcurrentHashMap<String,ArrayList<ShowMainDoc>>()
    private var wsSeq = ""
    private var lastUpdatedAt = now()

    fun lastUpdatedAt() = lastUpdatedAt

    fun queryBySmSeq(smSeq:String):ShowMainDoc? = indexSmSeq[smSeq]

    fun queryByCpName(cpName:String):List<ShowMainDoc> = indexCpName[cpName]?: listOf()

    fun queryAllData():List<ShowMainDoc> = data

    val dataSize get() = data.size

    fun duplicate(env:String, wsSeq:String):ShowMainDuplication{
        this.wsSeq = wsSeq

        val opt = Options()
                .set(SolrDao.ZOOKEEPERS, Conf["solr.show-main.zookeeper"])
                .set(SolrDao.UNIQUE_KEY, Conf["solr.show-main.uniquekey"])
                .set(SolrDao.RETRY, 3)

        val dao = SolrDao.create(opt)

        val numFound = queryAll(dao, 0,0)["response"]["numFound"].asInt(0)
        log.info("solr numFound=$numFound")
        val numRows = 1000


        val callables = (0 until numFound step numRows).map{ start ->
            Callable{
                log.info("download start=$start rows=$numRows")
                val rsp = queryAll(dao, start, numRows)
                rsp["response"]["docs"].map {
                    ShowMainDoc(
                            it["WS_SEQ"]?.asText()?:"",
                            it["SM_SEQ"]?.asText()?:"",
                            it["SM_NAME"]?.asText()?:"",
                            it["CP_SEQ"]?.asText()?:"",
                            it["CP_NAME"]?.asText()?:"",
                            it["ROUTE_SM_COLOR_SEQ"]?.asText()?:"",
                            it["SM_PIC"]?.asText()?:""
                    )
                }
            }
        }

        val threadPool = Executors.newFixedThreadPool(10)
        val results = threadPool.invokeAll(callables).flatMap { it.get() }
        dao.release()
        data.addAll(results)
        log.info("data.size=${data.size}")
        makeIndexSmSeq()
        log.info("indexSmSeq.size=${indexSmSeq.size}")
        makeIndexCpName()
        threadPool.shutdown()
        lastUpdatedAt = now()
        return this
    }

    private fun makeIndexSmSeq(){
        val buff = data.map { it.smSeq to it }.toMap()
        indexSmSeq.clear()
        indexSmSeq.putAll(buff)
    }

    private fun makeIndexCpName(){
        indexCpName.clear()
        data.forEach{
            indexCpName.getOrPut(it.cpName){ arrayListOf()}.add(it)
        }
    }

    private fun queryAll(dao:SolrDao, start:Int, rows:Int): JsonNode {
        val query = listOf(
                "q=WS_SEQ:$wsSeq",
                " AND SM_SOLDQTY:*",
                " AND -SM_SOLDQTY:0",
                " AND ISLIFEEXPIRED:0",
                " AND SM_STATUS:1",
                " AND (IS_ORGI_ITEM:0 OR IS_ORGI_ITEM:1)",
                "&start=$start",
                "&rows=$rows",
                "&wt=json",
                "&sort=ROUTE_SM_COLOR_SEQ+asc"
        ).joinToString("")

        try{
            val rsp = dao.select(collection, query, handler)
            return Json.parse(rsp)
        }
        catch(e:Exception){
            log.warn("request solr failed. query string:"+query,e)
            return Json.parse("[]")
        }
    }
}