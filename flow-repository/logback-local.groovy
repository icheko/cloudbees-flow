// This file customizes the logging configuration of the CloudBees Flow
// repository server.

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

//
// Log level configuration
//
logger "com.electriccloud", DEBUG