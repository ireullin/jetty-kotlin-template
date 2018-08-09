package libs.json

import com.fasterxml.jackson.databind.ObjectMapper

class Json(val parserInstance:ObjectMapper){
    constructor():this(ObjectMapper())
    fun stringify(obj:Any) = parserInstance.writeValueAsString(obj)
    fun parse(s:String) = parserInstance.readTree(s)
}