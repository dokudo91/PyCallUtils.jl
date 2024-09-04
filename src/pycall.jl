using PyCall

"""
    pyimport_object(modulename, condapkg, objectname)
    
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