# encoding: utf-8
module Rapidoc

  class ActionDoc
    attr_accessor :action, :method, :url

    def initialize( info )
      @action           = info["action"]
      @method           = info["method"]
      @urls             = info["urls"]
      @description      = info["description"]
      @http_status      = info["http_status"]
      @response_formats = info["response_format"]

=begin
      @params = ""

      @request = ""
      @response = ""

      @requires_authentication = "No"
      @account_password_required = "No"
=end
    end
  end
end
