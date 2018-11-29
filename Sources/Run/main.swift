import App

#if os(Linux)
srandom(UInt32(time(nil)))
#endif


try app(.detect()).run()
