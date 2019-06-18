require 'helper'

class TestResponse < Test::Unit::TestCase
  context "A SugarCRM::Response instance" do
    setup do
      @connection = SugarCRM::Connection.new(URL, USER, PASS)
      @json =  {"entry_list"=> [{
                "name_value_list"=> {
                  "address_city" => {"name"=>"address_city", "value"=>""},
                  "receive_notifications" => {"name"=>"receive_notifications", "value"=>"1"},
                  "is_group" => {"name"=>"is_group", "value"=>"0"},
                  "pwd_last_changed" => {"name"=>"pwd_last_changed", "value"=>"never"}
                },
                "id"=>"1",
                "module_name"=>"Users"
              }],
             "relationship_list"=>[]}
  
      @response = SugarCRM::Response.handle(@json)
    end
      
    should "return an instance of a SugarCRM Module" do
      assert_instance_of SugarCRM::User, @response
    end
      
  end
end