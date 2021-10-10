# typed: false
# frozen_string_literal: true

TaskStruct =
  Struct.new(
    :task_id,
    :named_task_id,
    :name,
    :initiator,
    :source_system,
    :context,
    :reason,
    :bypass_steps,
    :tags,
    :requested_at,
    :complete,
    :status,
    :identity_hash
  ) do
    def initialize(options)
      options.each do |key, value|
        __send__("#{key}=".to_sym, value)
      end
    end
  end

StepSequenceStruct =
  Struct.new(
    :steps
  ) do
    def initialize(options)
      options.each do |key, value|
        __send__("#{key}=".to_sym, value)
      end
    end
  end

WorkflowStepStruct =
  Struct.new(
    :task_id,
    :workflow_step_id,
    :named_step_id,
    :name,
    :depends_on_step_id,
    :status,
    :attempts,
    :skippable,
    :retryable,
    :retry_limit,
    :processed,
    :processed_at,
    :in_process,
    :backoff_request_seconds,
    :last_attempted_at,
    :inputs,
    :results
  ) do
    def initialize(options)
      options.each do |key, value|
        __send__("#{key}=".to_sym, value)
      end
    end
  end

RSpec.describe RutieTaskHandler do
  context 'gem is sane' do
    it 'has a version number' do
      expect(RutieTaskHandler::VERSION).not_to be nil
    end
  end

  context 'the handler itself' do
    let(:task) do
      TaskStruct.new(
        task_id: 1,
        named_task_id: 1,
        name: 'dummy-task',
        initiator: 'dummy-initiator',
        source_system: 'dummy-system',
        context: { dummy_inputs: true },
        reason: 'just because',
        bypass_steps: [],
        tags: ['dummy'],
        requested_at: Time.zone.now,
        complete: false,
        status: 'pending',
        identity_hash: 'aasdfasdfadsfasfd'
      )
    end
    let(:step) do
      WorkflowStepStruct.new(
        task_id: 1,
        workflow_step_id: 1,
        named_step_id: 1,
        name: 'dummy_step_one',
        depends_on_step_id: nil,
        status: 'pending',
        attempts: 0,
        skippable: false,
        retryable: true,
        retry_limit: 3,
        processed: false,
        processed_at: nil,
        in_process: false,
        backoff_request_seconds: nil,
        last_attempted_at: nil,
        inputs: { dummy_inputs: true },
        results: nil
      )
    end
    let(:sequence) do
      StepSequenceStruct.new(steps: [step])
    end

    it 'can process a correctly shaped WorkflowStep-style Struct' do
      result_step = DummyRutieTaskHandler.handle(task, sequence, step)
      expect(result_step[:results]).to eq({ 'dummy' => true })
    end
  end
end
