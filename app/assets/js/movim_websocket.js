/**
 * Movim Websocket
 *
 * This file define the websocket behaviour and handle its connection
 */

WebSocket.prototype.unregister = function() {
    this.send(JSON.stringify({'func' : 'unregister'}));
};

WebSocket.prototype.register = function(host) {
    this.send(JSON.stringify({'func' : 'register', 'host' : host}));
};

WebSocket.prototype.admin = function(key) {
    this.send(JSON.stringify({'func' : 'admin', 'key' : key}));
};

/**
 * @brief Definition of the MovimWebsocket object
 * @param string error
 */

var MovimWebsocket = {
    connection: null,
    attached: new Array(),
    registered: new Array(),
    unregistered: false,
    attempts: 1,

    launchAttached : function() {
        for(var i = 0; i < MovimWebsocket.attached.length; i++) {
            MovimWebsocket.attached[i]();
        }
    },

    launchRegistered : function() {
        for(var i = 0; i < MovimWebsocket.registered.length; i++) {
            MovimWebsocket.registered[i]();
        }
    },

    init : function() {
        if(SECURE_WEBSOCKET) {
            var uri = 'wss://' + BASE_HOST + '/ws/';
        } else {
            var uri = 'ws://' + BASE_HOST + '/ws/';
        }

        this.connection = new WebSocket(uri);

        this.connection.onopen = function(e) {
            console.log("Connection established!");
            MovimWebsocket.attempts = 1;
            MovimWebsocket.launchAttached();
        };

        this.connection.onmessage = function(e) {
            //console.log(e.data);
            data = pako.ungzip(base64_decode(e.data), { to: 'string' });
            //data = e.data;

            var obj = JSON.parse(data);

            if(obj != null) {
                if(obj.func == 'registered') {
                    MovimWebsocket.launchRegistered();
                }

                if(obj.func == 'disconnected') {
                    movim_disconnect();
                }

                MovimWebsocket.handle(obj);
            }

        };

        this.connection.onclose = function(e) {
            console.log("Connection closed by the server or session closed");
            if(e.code == 1006 || e.code == 1000) {
                if(MovimWebsocket.unregistered == false) {
                    movim_disconnect();
                } else {
                    MovimWebsocket.unregistered = false;
                    MovimWebsocket.init();
                }
            }
        };

        this.connection.onerror = function(e) {
            console.log(e.code);
            console.log(e);
            console.log("Connection error!");

            setTimeout(function () {
                // We've tried to reconnect so increment the attempts by 1
                MovimWebsocket.attempts++;

                // Connection has closed so try to reconnect every 10 seconds.
                MovimWebsocket.init();
            }, MovimWebsocket.generateInterval());

            // We prevent the onclose launch
            this.onclose = null;
        };
    },

    send : function(widget, func, params) {
        if(this.connection.readyState == 1) {
            this.connection.send(
                JSON.stringify(
                    {'func' : 'message', 'body' :
                        {
                            'widget' : widget,
                            'func' : func,
                            'params' : params
                        }
                    }
                )
            );
        }
    },

    attach : function(func) {
        if(typeof(func) === "function") {
            this.attached.push(func);
        }
    },

    register : function(func) {
        if(typeof(func) === "function") {
            this.registered.push(func);
        }
    },

    clearAttached : function() {
        this.attached = new Array();
    },

    handle : function(funcalls) {
        //var funcalls = JSON.parse(json);
        if(funcalls != null) {
            for(h = 0; h < funcalls.length; h++) {
                var funcall = funcalls[h];
                //console.log(funcall);
                if(funcall.func != null && (typeof window[funcall.func] == 'function')) {
                    try {
                        window[funcall.func].apply(null, funcall.params);
                    } catch(err) {
                        console.log("Error caught: " + err.toString() + " - " + funcall.func + ":" + JSON.stringify(funcall.params));
                    }
                } else if(funcall.func != null) {
                    var funcs  = funcall.func.split('.');
                    var called = funcs[0];
                    if(typeof window[called] == 'object') {
                        window[funcs[0]][funcs[1]].apply(null, funcall.params);
                    }
                }
            }
        }
    },

    unregister : function(reload) {
        if(reload == false) this.unregistered = true;
        this.connection.unregister();
    },

    generateInterval :function() {
        var maxInterval = (Math.pow(2, MovimWebsocket.attempts) - 1) * 1000;

        if (maxInterval > 30*1000) {
            maxInterval = 30*1000; // If the generated interval is more than 30 seconds, truncate it down to 30 seconds.
        }

        // generate the interval to a random number between 0 and the maxInterval determined from above
        return Math.random() * maxInterval; 
    }
}

function remoteUnregister()
{
    MovimWebsocket.unregister(false);
}

function remoteUnregisterReload()
{
    MovimWebsocket.unregister(true);
}

document.addEventListener("visibilitychange", function () {
    if(!document.hidden) {
        if(MovimWebsocket.connection.readyState == 3) {
            MovimWebsocket.init();
        }
    }
});

window.onbeforeunload = function() {
    MovimWebsocket.connection.onclose = function () {}; // disable onclose handler first
    MovimWebsocket.connection.close()
};

movim_add_onload(function() {
    // And we start it
    MovimWebsocket.init();
});
