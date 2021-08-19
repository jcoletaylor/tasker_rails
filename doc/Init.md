# Init

```bash
rails generate model AnnotationType name:string description:string --no-migration

rails generate model DependentSystemObjectMap dependent_system_one:references dependent_system_two:references remote_id_one:string remote_id_two:string --no-migration

rails generate model DependentSystem name:string description:string --no-migration

rails generate model NamedStep dependent_system:references name:string description:string --no-migration

rails generate model NamedTask name:string description:string --no-migration

rails generate model NamedTasksNamedStep named_task:references named_step:references skippable:boolean default_retryable:boolean default_retry_limit:integer --no-migration

rails generate model TaskAnnotation task:references annotation_type:references annotation:jsonb --no-migration

rails generate scaffold Task named_task:references status:string complete:boolean requested_at:datetime initiator:string source_system:string reason:string bypass_steps:json tags:jsonb context:jsonb identity_hash:string --no-migration

rails generate scaffold WorkflowStep task:references named_step:references depends_on_step:references status:string retryable:boolean retry_limit:integer in_process:boolean processed:boolean processed_at:datetime attempts:integer last_attempted_at:datetime backoff_request_seconds:integer inputs:jsonb results:jsonb --no-migration
```