// This file customizes the logging configuration of the CloudBees Flow
// server.

// If you want to use an event viewer like Lilith <http://lilith.huxhorn.de/>,
// uncomment the following:

//import ch.qos.logback.classic.net.SocketAppender
//
//appender("SOCKET", SocketAppender) {
//    port=4560
//    remoteHost="localhost"
//}
//
//if (useSetup) {
//    root(TRACE, ["ASYNC_FILE", "ASYNC_SETUP_FILE", "SOCKET"])
//} else {
//    root(TRACE, ["ASYNC_FILE", "SOCKET"])
//}

// To eavesdrop on HTTP headers, uncomment this line and restart
// the CloudBees Flow server:
//logger("com.electriccloud.commander.server.ApiRequestHandlerImpl", TRACE)

// Log all SQL DML statements as they are executed
//logger("org.hibernate.SQL", TRACE)

// Log all JDBC parameters
//logger("org.hibernate.type.descriptor.sql.BasicBinder", TRACE)

// Log messages related to Kerberos communication
//
// To activate these messages, also uncomment the parameters
// from "wrapper.java.additional.955" to "wrapper.java.additional.958" in
// the configuration file "wrapper.conf".
//
// The messages will be sent to file "commander-service.log".
//
//logger("com.electriccloud.security.kerberos", TRACE)

// If you want to drastically cut down on the number of log messages,
// uncomment this group to override the defaults:
logger("com.electriccloud", DEBUG)
//logger("com.electriccloud.commander.statemachine", ERROR)
//logger("com.electriccloud.operation", ERROR)

// Once you've done that, here are some areas you can selectively re-enable:

// CloudBees Flow API protocol messages:
//logger("com.electriccloud.commander.server.ApiRequestHandlerImpl", DEBUG)
//logger("com.electriccloud.commander.protocol.AbstractResponseHandlerImpl", DEBUG)