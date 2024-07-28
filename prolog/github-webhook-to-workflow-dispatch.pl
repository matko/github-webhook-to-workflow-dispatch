#!/usr/bin/env swipl
:- use_module([library(http/http_server),
               library(http/http_client),
               library(http/http_log),
               library(http/json),
               library(sha)]).

:- use_module([config, github]).

:- initialization(main, main).

main(_) :-
    initialize_log_settings,
    webhook_port(Port),
    http_server([port(Port),
                 workers(1)]),
    % cute trick - attach to one of the workers so this thread won't ust exit.
    % However, if this thread goes down for any other reason (normal worker pool behavior?)
    % the whole program crashes.
    http_current_worker(Port, ThreadId),
    thread_join(ThreadId, _).

initialize_log_settings :-
    get_time(Time),
    asserta(http_log:log_stream(user_error, Time)).

% Endpoint doesn't matter, this is a single purpose service
:- http_handler(root(_), handler, [methods([post])]).

:- meta_predicate(do_or_die(:, +)).
do_or_die(Goal, Error) :-
    (  Goal
    -> true
    ;  throw(http_reply(bytes("text/plain", Error), [status(400)]))).

handler(Request) :-
    do_or_die(memberchk(x_hub_signature_256(ProvidedHash), Request),
              "No header X-Hub-Signature-256"),
    http_read_data(Request, Data, [to(string)]),
    webhook_secret(Secret),
    hmac_sha(Secret, Data, Hmac, [algorithm(sha256)]),
    hash_atom(Hmac, HmacHex),
    do_or_die(format(atom(ProvidedHash), "sha256=~s", [HmacHex]),
              "Hash invalid"),
    open_string(Data, Stream),
    do_or_die(catch(json_read_dict(Stream, _Json, [default_tag(json)]),
                    error(syntax_error(json(_)),_),
                    fail),
              "Invalid json"),

    % We got called, and we verified it was trustworthy.
    % Time to actually send out the dispatch
    workflow_pat(Token),
    workflow_owner(Owner),
    workflow_repo(Repo),
    workflow_dispatch_event(Event),
    dispatch_workflow(Token, Owner, Repo, Event, null),

    % github really only cares about getting back a 202 status code
    format("Status: 202~n~n").
