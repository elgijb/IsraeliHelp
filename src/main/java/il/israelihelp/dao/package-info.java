/**
 * DAO (Data Access Object) — слой доступа к базе данных.
 *
 * Только в этих классах пишутся SQL-запросы. Все запросы выполняются
 * через PreparedStatement, чтобы защититься от SQL-инъекций.
 */
package il.israelihelp.dao;
