class UsersController < ApplicationController

  # =begin resource
  # description: Represents an user in the system.
  # =end

  respond_to :json

  # =begin action
  # method: GET
  # action: index
  # authentication_required: true
  # response_formats: json
  # description: Return all users of the system.
  #
  # http_responses:
  #   - 200
  #   - 401
  #   - 403
  #   - 404
  #
  # params:
  #   - name: page
  #     description: number of page in pagination
  #     required: false
  #     type: Integer
  #
  #   - name: limit
  #     description: number of elements by page in pagination
  #     type: Integer
  #
  #   - name: name
  #     description: name filter
  #     type: String
  #
  #   - name: gender
  #     description: gender filter
  #     inclusion: male, female
  #
  # =end
  def index
    @data_json = { "name" => "Antonio", "apellido" => "Jimenez" }
    render :json => @data_json
  end

  # =begin action
  #
  # method: GET
  # action: show
  # authentication_required: yes
  # response_formats: json
  # description: Return an user.
  #
  # http_responses:
  #   - 200
  #   - 401
  #   - 403
  #   - 404
  #
  # =end
  def show
  end

  # =begin action
  #
  # method: POST
  # action: create
  # authentication_required: false
  # response_formats: json
  # description: Create new user.
  #
  # params:
  #   - name: name
  #     type: String
  #     required: true
  #     description: User name.
  #
  #   - name: email
  #     type: String
  #     required: true
  #     description: User email.
  #
  #   - name: password
  #     type: String
  #     required: true
  #     description: > 
  #       User password. It will be required in loggin.
  #       Must be at least 8 caracters and be be safe.
  #
  #   - name: gender
  #     type: String
  #     required: true
  #     inclusion: male, female
  #     description: User gender.
  #
  #   - name: phone
  #     type: Number
  #
  # errors:
  #   - object: password
  #     message: too_short
  #     description: Password must be at least 4 characters.
  #
  # http_responses:
  #   - 201
  #   - 401
  #   - 422
  #   - 404
  #
  # =end
  def create
  end

end
