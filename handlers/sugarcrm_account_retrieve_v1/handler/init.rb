# Require the REXML ruby library.
require 'rexml/document'
# Require the dependencies file to load the vendor libraries
require File.expand_path(File.join(File.dirname(__FILE__), 'dependencies'))

class SugarcrmAccountRetrieveV1
  # Prepare for execution by building Hash objects for necessary values, and 
  # validating the present state.  This method sets the following instance 
  # variables:
  # * @input_document - A REXML::Document object that represents the input Xml.
  # * @parameters - A Hash of parameter names to parameter values.
  # * @info_values - A Hash of name/value pairs used to define the SugarCRM 
  #   server and login credentials.
  #
  # This is a required method that is automatically called by the Kinetic Task
  # Engine.
  #
  # ==== Parameters
  # * +input+ - The String of Xml that was built by evaluating the node.xml 
  #   handler template.
  def initialize(input)
    # Set the input document attribute
    @input_document = REXML::Document.new(input)

    # Store infos in the node.xml in a hash attribute named @info_values.
    @info_values = {}
    REXML::XPath.match(@input_document, '/handler/infos/info').each do |node|
      @info_values[node.attribute('name').value] = node.text
    end
    log("Connecting to \"#{@info_values['server_url']}\" as \"#{@info_values['username']}\"")
    
    # Store parameters in the node.xml in a hash attribute named @parameters.
    @parameters = {}
    REXML::XPath.match(@input_document, '/handler/parameters/parameter').each do |node|
      @parameters[node.attribute('name').value] = node.text
    end
    log("Handler Parameters: #{@parameters.inspect}")
  end
  
  # Establishes a connection to the SugarCRM server and retrieves the Account 
  # record identified by the account name.  If the account cannot be found, 
  # an exception is raised.
  #
  # This is a required method that is automatically called by the Kinetic Task
  # Engine.
  #
  # ==== Returns
  # An Xml formatted String representing the return variable results.
  def execute()
    # Connect to the SugarCRM server
    begin
        SugarCRM::Base.establish_connection(
            @info_values['server_url'],
            @info_values['username'], 
            @info_values['password']
        )
    rescue
      # raise an error with a meaningful message if failed to establish a
      # connection to the SugarCRM server
      msg = "Could not establish connection to the SugarCRM server at: "
      msg += @info_values['server_url']
      msg += " with the user: #{@info_values['username']}"
      
      raise (msg)
    end

    # Retrieve the Account
    account = SugarCRM::Account.find_by_name(@parameters['account_name'])
    
    # Raise an exception if no accounts matched the supplied name
    raise "The account '#{@parameters['account_name']}' does not exist." unless account
    log("Account details: #{account}")

    # Build and return the results xml that will be returned by this handler.
    results = <<-RESULTS
    <results>
        <result name="Id">#{escape(account.id)}</result>
        <result name="Account Type">#{escape(account.account_type)}</result>
        <result name="Assigned User Id">#{escape(account.assigned_user_id)}</result>
        <result name="Assigned User Name">#{escape(account.assigned_user_name)}</result>
        <result name="Billing Address City">#{escape(account.billing_address_city)}</result>
        <result name="Billing Address Country">#{escape(account.billing_address_country)}</result>
        <result name="Billing Address Postal Code">#{escape(account.billing_address_postalcode)}</result>
        <result name="Billing Address Street">#{escape(account.billing_address_street)}</result>
        <result name="Billing Address Street 2">#{escape(account.billing_address_street_2)}</result>
        <result name="Billing Address Street 3">#{escape(account.billing_address_street_3)}</result>
        <result name="Billing Address Street 4">#{escape(account.billing_address_street_4)}</result>
        <result name="Campaign Id">#{escape(account.campaign_id)}</result>
        <result name="Campaign Name">#{escape(account.campaign_name)}</result>
        <result name="Created By">#{escape(account.created_by)}</result>
        <result name="Created By Name">#{escape(account.created_by_name)}</result>
        <result name="Date Entered">#{escape(account.date_entered)}</result>
        <result name="Date Modified">#{escape(account.date_modified)}</result>
        <result name="Description">#{escape(account.description)}</result>
        <result name="Email 1">#{escape(account.email1)}</result>
        <result name="Industry">#{escape(account.industry)}</result>
        <result name="Modified By Name">#{escape(account.modified_by_name)}</result>
        <result name="Modified User Id">#{escape(account.modified_user_id)}</result>
        <result name="Name">#{escape(account.name)}</result>
        <result name="Ownership">#{escape(account.ownership)}</result>
        <result name="Parent Id">#{escape(account.parent_id)}</result>
        <result name="Parent Name">#{escape(account.parent_name)}</result>
        <result name="Phone Alternate">#{escape(account.phone_alternate)}</result>
        <result name="Phone Fax">#{escape(account.phone_fax)}</result>
        <result name="Phone Office">#{escape(account.phone_office)}</result>
        <result name="Rating">#{escape(account.rating)}</result>
        <result name="Shipping Address City">#{escape(account.shipping_address_city)}</result>
        <result name="Shipping Address Country">#{escape(account.shipping_address_country)}</result>
        <result name="Shipping Address Postal Code">#{escape(account.shipping_address_postalcode)}</result>
        <result name="Shipping Address State">#{escape(account.shipping_address_state)}</result>
        <result name="Shipping Address Street">#{escape(account.shipping_address_street)}</result>
        <result name="Shipping Address Street 2">#{escape(account.shipping_address_street_2)}</result>
        <result name="Shipping Address Street 3">#{escape(account.shipping_address_street_3)}</result>
        <result name="Shipping Address Street 4">#{escape(account.shipping_address_street_4)}</result>
        <result name="SIC Code">#{escape(account.sic_code)}</result>
        <result name="Ticker Symbol">#{escape(account.ticker_symbol)}</result>
        <result name="Valid">#{escape(account.valid?)}</result>
        <result name="Website">#{escape(account.website)}</result>
    </results>
    RESULTS
    log("Results: \n#{results}")

    return results
  end

  ##############################################################################
  # General handler utility functions
  ##############################################################################

  # This is a template method that is used to escape results values (returned in
  # execute) that would cause the XML to be invalid.  This method is not
  # necessary if values do not contain character that have special meaning in
  # XML (&, ", <, and >), however it is a good practice to use it for all return
  # variable results in case the value could include one of those characters in
  # the future.  This method can be copied and reused between handlers.
  def escape(string)
    # Globally replace characters based on the ESCAPE_CHARACTERS constant
    string.to_s.gsub(/[&"><]/) { |special| ESCAPE_CHARACTERS[special] } if string
  end
  # This is a ruby constant that is used by the escape method
  ESCAPE_CHARACTERS = {'&'=>'&amp;', '>'=>'&gt;', '<'=>'&lt;', '"' => '&quot;'}

  # This is a sample helper method that illustrates one method for retrieving
  # values from the input document.  As long as your node.xml document follows
  # a consistent format, these type of methods can be copied and reused between
  # handlers.
  def get_info_value(document, name)
    # Retrieve the XML node representing the desird info value
    info_element = REXML::XPath.first(document, "/handler/infos/info[@name='#{name}']")
    # If the desired element is nil, return nil; otherwise return the text value of the element
    info_element.nil? ? nil : info_element.text
  end
  
  # This method prints a message to the Kinetic Task log file if the 
  # "debug_logging_enabled" info value is set to "Yes".
  def log(msg)
    puts(msg) if @info_values['enable_debug_logging'] == "Yes"
  end
end