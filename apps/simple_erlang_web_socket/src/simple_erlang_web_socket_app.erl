-module(simple_erlang_web_socket_app).

-behaviour(application).

-define(APPS, [inets, ranch, crypto, cowlib, cowboy, jsx]).
-define(LPort, (case os:getenv("SIMPLE_WEB_SOCKET_PORT") of 
	false -> element(2, application:get_env(simple_erlang_web_socket, port)); 
	Port -> Port end)).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    init_apps(?APPS),
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/simple_erlang_web_socket", simple_erlang_web_socket_home, []},
			{"/simple_erlang_web_socket/add", simple_erlang_web_socket_add, []},
			{"/simple_erlang_web_socket/subtract", simple_erlang_web_socket_subtract, []},
			{"/simple_erlang_web_socket/multiply", simple_erlang_web_socket_multiply, []},
			{"/simple_erlang_web_socket/divide", simple_erlang_web_socket_divide, []},
			{'_', simple_erlang_web_socket_not_found, []}
		]}
	]),
	{ok, _} = cowboy:start_http(http_listener, 100,
		[{port, ?LPort}],
		[{env, [{dispatch, Dispatch}]}]
	),
    simple_erlang_web_socket_sup:start_link().

stop(_State) ->
    ok.

init_apps([]) -> ok;
init_apps([App | Apps]) ->
    case application:start(App) of
        ok -> init_apps(Apps);
        {error, {already_started, App}} -> init_apps(Apps)
    end.
