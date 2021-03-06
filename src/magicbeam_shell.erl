%% @private
-module(magicbeam_shell).
-behaviour(shellbeam).

-include("magicbeam.hrl").

-export([commands/0]).
-export([hotload/1, thunderdome/1, setenv/3, rehash/0, shell/0, remote/1]).

commands() ->
    [
     {["hotload", {"module", atom}], "Recompile and reload a beam", fun ?MODULE:hotload/1},
     {["thunderdome", {"enable", bool}], "Enable/Disable aggressive thunderbeam activity", fun ?MODULE:thunderdome/1},
     {["appenv"], "Application Environment Configuration Shell", {subshell, [magicbeam_shell_appenv], "config ^_^"}},
     {["rehash"], "Rehash magicbeam configuration from OTP Application Environment", fun ?MODULE:rehash/0},
     {["shell"], "Normal Erlang shell", fun ?MODULE:shell/0},
     {["remote", {"node", string}], "Remote erlang shell", fun ?MODULE:remote/1}
    ].

hotload(M) when is_atom(M) ->
    ok = hotbeam:mod(M),
    {ok, "Hot reload of ~p requested", [M]};
hotload(_) -> syntax.

thunderdome(true) ->
    thunderbeam:enabled(true),
    {ok, "Thunderbeam enabled"};
thunderdome(false) ->
    thunderbeam:enabled(false),
    {ok, "Thunderbeam disabled"};
thunderdome(_) -> syntax.

setenv(A, K, V) when is_atom(A), is_atom(K) ->
    application:set_env(A, K, p_distill_val(V)),
    {ok, "Set ~p:~p to ~p", [A, K, V]}.

p_distill_val(V) ->
    case catch list_to_integer(V) of
        I when is_integer(I) ->
            I;
        {'EXIT',{badarg,[{erlang,list_to_integer,[V]} | _]}} ->
            case catch list_to_existing_atom(string:to_lower(V)) of
                A when is_atom(A) ->
                    A;
                {'EXIT',{badarg,[{erlang,list_to_existing_atom,[V]} | _]}} ->
                    V
            end
    end.

rehash() ->
    ok = magicbeam:rehash(),
    {ok, "Rehashed."}.

shell() -> shell(shell:start(), ?enow()).
shell(P, T) when is_pid(P) ->
    timer:sleep(1000),
    case is_process_alive(P) of
        true ->
            shell(P, T);
        false -> {ok, "Shell complete after ~ps", [?enow() - T]}
    end.

remote(A) ->
    N = list_to_atom(A),
    case net_adm:ping(N) of
        pang ->
            {error, "Unable to contact ~s", [A]};
        pong ->
            remote(A, ?enow(), rpc:call(N, shell, start, []))
    end.

remote(A, T, P) when is_pid(P) ->
    case is_process_alive(P) of
        true -> remote(A, T, P);
        false ->
            {ok, "Remote shell to ~p complete after ~ps", [A, ?enow() - T]}
    end.
