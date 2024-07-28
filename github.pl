:- module(github, [dispatch_workflow/5]).
:- use_module(library(http/http_client)).

dispatch_workflow(Token, Owner, Repo, Event, Payload) :-
    format(string(Url), "https://api.github.com/repos/~s/~s/dispatches", [Owner, Repo]),
    Pre_Data = json{
                   event_type: Event
               },
    (  nonvar(Payload),
       Payload \= null
    -> put_dict(payload, Pre_Data, Payload, Data)
    ;  Data = Pre_Data),

    http_post(Url,
              json(Data),
              _,
              [
                  authorization(bearer(Token))
              ]).
