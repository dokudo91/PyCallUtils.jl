using PyCall

"""
    pyimport_object(modulename, condapkg, objectname)
    pyimport_object(modulename, objectname)
    
```
modulename = "google.oauth2.credentials"
condapkg = "google-auth"
objectname = :Credentials
pyimport_object(modulename, condapkg, objectname)
```
"""
function pyimport_object(modulename, condapkg, objectname)
    pymodule = pyimport_conda(modulename, condapkg)
    getproperty(pymodule, objectname)::PyObject
end

function pyimport_object(modulename, objectname)
    pymodule = pyimport_conda(modulename, modulename)
    getproperty(pymodule, objectname)::PyObject
end

macro pyfrom(lib, fs...)
    mdl = replace(string(lib), r"[\(\)]" => "")
    exs = [:($f = pyimport($mdl).$(string(f))) for f in fs]
    esc(Expr(:block, exs...))
end