module Smith
  module Client
    ClientPrimaryRegistrationSteps = RSpec::EM.async_steps do

      def assert_primary_registration_code_sent_when_server_initially_reachable(&callback)
        d1 = add_command_pipe_expectation do |command|
          expect(command).to eq(CMD_REGISTRATION_CODE)
          expect(registration_file_contents).to eq(expected_registration_file_contents)
        end

        d2 = add_http_request_expectation registration_endpoint do |request_params|
          expect(request_params[:firmware]).to eq(VERSION)
          expect(request_params[:type_id]).to eq(Settings.spark_printer_type_id)
        end

        when_succeed(d1, d2) { callback.call }

        start_client
      end

      def assert_primary_registration_succeeded_sent_when_notified_of_registration_code_entry(&callback)
        # Expect both a health check to be posted to server and the registration complete command to be sent to command pipe
        
        add_command_pipe_expectation do |command|
          expect(command).to eq(CMD_REGISTERED)
          callback.call
        end

        # Simulate user entering registration code into portal
        dummy_server.post_registration(registration_code: dummy_server.registration_code)
        
      end

      def assert_registration_reattempted_after_server_not_reachable(&callback)
        d1 = add_log_subscription(LogMessages::RETRY_REGISTRATION_AFTER_REQUEST_FAILED,
                                  Settings.server_url, Settings.client_retry_interval) do
          # After first attempt, server becomes reachable
          Settings.server_url = dummy_server.url
        end
        
        d2 = add_command_pipe_expectation do |command|
          expect(command).to eq(CMD_REGISTRATION_CODE)
          expect(registration_file_contents).to eq(expected_registration_file_contents)
        end

        when_succeed(d1, d2) { callback.call }

        start_client
      end

      def assert_registration_reattempted_after_not_in_valid_state(&callback)
        d1 = add_log_subscription(LogMessages::RETRY_REGISTRATION_AFTER_ERROR, '', Settings.client_retry_interval) do
          set_printer_status(state: HOME_STATE)
        end
        
        d2 = add_command_pipe_expectation do |command|
          expect(command).to eq(CMD_REGISTRATION_CODE)
          expect(registration_file_contents).to eq(expected_registration_file_contents)
        end

        when_succeed(d1, d2) { callback.call }

        start_client
      end

      def assert_identity_persisted(&callback)
        expect(@state.printer_id).to eq(dummy_server.printer_id)
        expect(@state.auth_token).to eq(dummy_server.auth_token)
        callback.call
      end

    end
  end
end
