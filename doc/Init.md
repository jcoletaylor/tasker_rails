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


```bash
rails generate graphql:object AnnotationType name:String description:String

rails generate graphql:object DependentSystem name:String description:String

rails generate graphql:object DependentSystemObjectMap dependent_system_one:\[DependentSystem\] dependent_system_two:\[DependentSystem\] remote_id_one:String remote_id_two:String

rails generate graphql:object NamedStep dependent_system:\[DependentSystem\] name:String description:String

rails generate graphql:object NamedTask name:String description:String

rails generate graphql:object NamedTasksNamedStep named_task:\[NamedTask\] named_step:\[NamedStep\] skippable:Boolean default_retryable:Boolean default_retry_limit:Int

rails generate graphql:object TaskAnnotation task:\[Task\] annotation_type:\[AnnotationType\] annotation:JSON

rails generate graphql:object Task named_task:\[NamedTask\] status:String complete:Boolean requested_at:ISO8601DateTime initiator:String source_system:String reason:String bypass_steps:json tags:JSON context:JSON identity_hash:String

rails generate graphql:object WorkflowStep task:\[Task\] named_step:\[NamedStep\] depends_on_step:\[WorkflowStep\] status:String retryable:Boolean retry_limit:Int in_process:Boolean processed:Boolean processed_at:ISO8601DateTime skippable:Boolean attempts:Int last_attempted_at:ISO8601DateTime backoff_request_seconds:Int inputs:JSON results:JSON
```