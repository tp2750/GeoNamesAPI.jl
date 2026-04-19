module EzXMLExt

using GeoNamesAPI, EzXML


function __init__()
    global GeoNamesAPI.ret_dict["ezxml"] = EzXML.XMLDocument()
    global GeoNamesAPI.rettype = EzXML.XMLDocument()
end

function GeoNamesAPI.search(::EzXML.Document ; kwargs...)
    res = GeoNamesAPI.search(""; kwargs..., type="xml")
    EzXML.parsexml(res)
end


end
