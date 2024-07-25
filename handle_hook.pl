#!/usr/bin/env swipl
:- use_module([library(http/http_server),
               library(http/http_json)
              ]).

:- initialization(main, main).

main(_) :-
  http_server([port(8080),
               workers(1)]),
  % cute trick - attach to one of the workers so this thread won't ust exit.
  % However, if this thread goes down for any other reason (normal worker pool behavior?)
  % the whole program crashes.
  http_current_worker(8080, ThreadId),
  thread_join(ThreadId, _).

% Endpoint doesn't matter, this is a single purpose service
:- http_handler(root(_), handler, []).

handler(_Request) :-
    reply_json_dict(
        _{
            hello: "World"
        }).
