use chrono::{DateTime, Utc};
use serde::{Deserialize, Serialize};
use serde_json::Value as JsonValue;

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct Task {
    pub task_id: i64,
    pub named_task_id: i32,
    pub status: String,
    pub complete: bool,
    pub requested_at: DateTime<Utc>,
    pub initiator: Option<String>,
    pub source_system: Option<String>,
    pub reason: Option<String>,
    pub bypass_steps: Option<JsonValue>,
    pub tags: Option<JsonValue>,
    pub context: Option<JsonValue>,
    pub identity_hash: String,
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct WorkflowStep {
    pub workflow_step_id: i64,
    pub task_id: i64,
    pub named_step_id: i32,
    pub depends_on_step_id: Option<i64>,
    pub status: String,
    pub retryable: bool,
    pub retry_limit: Option<i32>,
    pub in_process: bool,
    pub processed: bool,
    pub processed_at: Option<DateTime<Utc>>,
    pub attempts: Option<i32>,
    pub last_attempted_at: Option<DateTime<Utc>>,
    pub backoff_request_seconds: Option<i32>,
    pub inputs: Option<JsonValue>,
    pub results: Option<JsonValue>,
}

#[derive(Clone, Serialize, Deserialize, Debug)]
pub struct StepSequence {
    pub steps: Vec<WorkflowStep>
}
