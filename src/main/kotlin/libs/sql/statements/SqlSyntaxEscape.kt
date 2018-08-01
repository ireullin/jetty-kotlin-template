package libs.sql.statements

object SqlSyntaxEscape {
    operator fun invoke(s: String): String {
        return s.replace("'", "''")
    }
}