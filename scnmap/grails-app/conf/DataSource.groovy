dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {
        dataSource {
           // dbCreate = "create-drop" // one of 'create', 'create-drop','update'
            // url = "jdbc:hsqldb:mem:devDB"            // url = "jdbc:hsqldb:mem:devDB"
            driverClassName = "com.mysql.jdbc.Driver"
            dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
            dbCreate =  "update" // "create-drop"           // "create"
            username = "k-int"
            password = "k-int"
            pooled = true
            url = "jdbc:mysql://localhost/kiunittest?autoReconnect=true&amp;characterEncoding=utf8"
            properties {
                validationQuery="select 1"
                testWhileIdle=true
                timeBetweenEvictionRunsMillis=60000
            }
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb;MVCC=TRUE"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            driverClassName = "com.mysql.jdbc.Driver"
            dbCreate = "create-drop" // one of 'create', 'create-drop', 'update', 'validate', ''
            dbCreate =  "update" // "create-drop"           // "create"
            username = "k-int"
            password = "k-int"
            pooled = true
            url = "jdbc:mysql://localhost/scn?autoReconnect=true&amp;characterEncoding=utf8"
            properties {
               maxActive = -1
                validationQuery="select 1"
                testWhileIdle=true
                minEvictableIdleTimeMillis=1800000
                timeBetweenEvictionRunsMillis=1800000
                numTestsPerEvictionRun=3
                testOnBorrow=true
                testWhileIdle=true
                testOnReturn=true

            }
        }
    }
}
