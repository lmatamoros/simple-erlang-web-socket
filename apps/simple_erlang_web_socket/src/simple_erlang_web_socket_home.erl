-module(simple_erlang_web_socket_home).

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

websocket_handle({text, _Msg}, Req, State) ->
  Response = jsx:encode([
    {<<"path">>, <<"home">>},
    {<<"method">>, <<"websocket_handle">>}]),
  {reply, {text, Response}, Req, State}.

websocket_info(_Info, State) ->
  Response = jsx:encode([
    {<<"path">>, <<"home">>},
    {<<"method">>, <<"websocket_info">>}]),
  {reply, {text, Response}, State}.

terminate(_Reason, _Req, _State) ->
  ok.

