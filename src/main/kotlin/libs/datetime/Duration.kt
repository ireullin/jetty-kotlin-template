package libs.datetime

interface Duration {
    fun dayPart(): Int
    fun hourPart(): Int
    fun minPart(): Int
    fun secPart(): Int
    fun millisPart(): Int

    fun totalDay(): Double
    fun totalHour(): Double
    fun totalMin(): Double
    fun totalSec(): Double
    fun totalMillis(): Long

    fun stamp(): Long
}
