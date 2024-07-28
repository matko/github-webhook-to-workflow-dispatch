:- module(config, [webhook_port/1,
                   webhook_secret/1,
                   workflow_owner/1,
                   workflow_repo/1,
                   workflow_dispatch_event/1,
                   workflow_pat/1]).

webhook_port(Port) :-
    (  getenv('WEBHOOK_PORT', PortString)
    -> atom_number(PortString, Port)
    ;  Port = 8080).

webhook_secret(Secret) :-
    getenv('WEBHOOK_SECRET', Secret).

workflow_owner(Owner) :-
    getenv('WORKFLOW_OWNER', Owner).

workflow_repo(Repo) :-
    getenv('WORKFLOW_REPO', Repo).

workflow_dispatch_event(Event) :-
    getenv('WORKFLOW_DISPATCH_EVENT', Event).

workflow_pat(Token) :-
    getenv('WORKFLOW_PAT', Token).
