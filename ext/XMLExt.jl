module XMLExt

using GeoNamesAPI, XML

function __init__()
    # global GeoNamesAPI.rettype = XML.Node(1)
    global GeoNamesAPI.rettype = XML.LazyNode(XML.Raw([UInt8(1)]))
end

function GeoNamesAPI.search(::XML.Node ; kwargs...)
    res = GeoNamesAPI.search(""; kwargs..., type="xml")
    parse(Node, string(res))
end

function GeoNamesAPI.search(::XML.LazyNode ; kwargs...)
    res = GeoNamesAPI.search(""; kwargs..., type="xml")
    parse(LazyNode, string(res))
end



end
