

function read_operation(callback)
{    
    var handler = new XMLHttpRequest()
    handler.onreadystatechange = function()
    {
        if (handler.readyState === XMLHttpRequest.DONE)
        {
            var buf = handler.responseText.toString()
            if (buf)
                callback(buf)
        }
    };
    handler.open("GET", "https://api.jsonbin.io/v3/b/63f78bd7c0e7653a057d33d0/latest");
    handler.setRequestHeader('X-Master-Key', '$2b$10$nSgrCugk5FgqjQHkyuzS7OJqqk9dBREqlLZp7dDCfNC6ZTv0TXfnS');
    handler.send();
}
