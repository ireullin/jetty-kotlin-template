package helpers

import org.slf4j.LoggerFactory
import java.util.*

typealias Conf = Configurations
object Configurations {
    private val log = LoggerFactory.getLogger(Configurations::class.java)
    private val prop = Properties()

    init {
        reload()
    }

    fun reload() {
        val classLoader = Thread.currentThread().getContextClassLoader()
        val input = classLoader.getResourceAsStream("setting.properties")
        //val input = FileInputStream("/data/conf/uitox-categories-predictor-v1.0-SNAPSHOT.properties")
        prop.load(input)
    }

    fun has(key: String): Boolean = prop.containsKey(key)

    operator fun get(key: String): String {
        return if(has(key)) {
            prop.getProperty(key)
        }else{
            throw Exception("key doesn't exist")
        }
    }

    override fun toString(): String {
        return prop.toString()
    }
}

