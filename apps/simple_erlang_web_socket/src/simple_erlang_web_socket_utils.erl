-module(simple_erlang_web_socket_utils).

-export([
    checkSchema/3,
    serviceResponse/4
]).

checkSchema([], _, NotFound) -> NotFound;
checkSchema([Field|Fields], Data, NotFound) -> 
    NNotFound = checkField((catch lists:keyfind(Field, 1, Data)), Field, NotFound),
    checkSchema(Fields, Data, NNotFound).

checkField(false, Field, NotFound) -> [Field|NotFound];
checkField({'EXIT',{badarg, _}}, Field, NotFound) -> [Field|NotFound];
checkField(_, _, NotFound) -> NotFound.

serviceResponse(Result, 200, Req, State) -> 
    Response = jsx:encode([
        {<<"status">>, 200},
        {<<"result">>, Result}]),
    {reply, {text, Response}, Req, State};
serviceResponse(Error, Code, Req, State) -> 
    Response = jsx:encode([
        {<<"status">>, Code},
        {<<"error">>, Error}]),
    {reply, {text, Response}, Req, State}.
