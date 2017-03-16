import pyEasyGo as ego

gmod = ego.GoModule("exampleGoModule/exampleGoModule.so")
print gmod
print 'Test1', gmod.Test1()
gmod.Test2(1234)
gmod.Test2("abcd")
gmod.Test3("abcd")
gmod.Test5()


