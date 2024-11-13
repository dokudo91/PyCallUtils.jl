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

macro pyfrom(name, varnames...)
    mname = PyCall.modulename(name)
    for Name in varnames
        quoteName = Expr(:quote, Name)
        quote
            if !isdefined($__module__, $quoteName)
                const $(esc(Name)) = PyCall._pywrap_pyimport(pyimport($mname))
            elseif !isa($(esc(Name)), Module)
                error("@pyimport: ", $(Expr(:quote, Name)), " already defined")
            end
            nothing
        end
    end
end
python(cmd) = run(`$(PyCall.python) -m $cmd`)