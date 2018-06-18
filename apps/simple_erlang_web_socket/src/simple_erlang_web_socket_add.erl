-module(simple_erlang_web_socket_add).

-export([init/2,
        terminate/3
    ]).

-export([
    websocket_init/1, websocket_handle/3,
    websocket_info/2, start/0
]).

-define(REQUIRE_FIELDS, [<<"left">>, <<"right">>]).

start() -> ok.

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_init(State) ->
	{ok, State}.

websocket_handle({text, Msg}, Req, State) ->
    Body = jsx:decode(Msg),
    NotFoundFields = simple_erlang_web_socket_utils:checkSchema(?REQUIRE_FIELDS, Body, []),
    execute(NotFoundFields, Body, Req, State).

execute([], Body, Req, State) -> 
    {<<"left">>, Left} = lists:keyfind(<<"left">>, 1, Body),
    {<<"right">>, Right} = lists:keyfind(<<"right">>, 1, Body),
    Result = Left + Right,
    simple_erlang_web_socket_utils:serviceResponse(Result, 200, Req, State);
execute(NotFoundFields, _, Req, State) -> 
    simple_erlang_web_socket_utils:serviceResponse(NotFoundFields, 400, Req, State).

websocket_info(_Info, State) ->
	{ok, State}.

terminate(_Reason, _Req, _State) ->
    ok.

