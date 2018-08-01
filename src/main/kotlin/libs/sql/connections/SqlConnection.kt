package libs.sql.connections

interface SqlConnection:AutoCloseable{
    fun <T> queryIndexed(cmd:String, callback:(Int, SqlRow)->T?):List<T>
    fun <T> query(cmd:String, callback:(SqlRow)->T?):List<T>
    fun queryToMap(cmd:String):List<Map<String,String>>
    fun queryToList(cmd:String):List<List<String>>
    fun execMutiCommands(cmd:String)
}