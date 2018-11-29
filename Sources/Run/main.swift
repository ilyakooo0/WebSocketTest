import App

#if os(Linux)
import SwiftGlibc
srandom(UInt32(time(nil)))
#endif


try app(.detect()).run()
