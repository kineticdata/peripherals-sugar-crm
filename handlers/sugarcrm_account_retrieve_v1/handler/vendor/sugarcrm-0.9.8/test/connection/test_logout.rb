require 'helper'

class TestLogout < Test::Unit::TestCase
  context "A SugarCRM.connection" do
    setup do
      SugarCRM::Connection.new(URL, USER, PASS, {:register_modules => false})
    end
    should "logout and not be able to login with the old session id" do
      assert (SugarCRM.connection.logout.class == Hash)
    end
  end
end