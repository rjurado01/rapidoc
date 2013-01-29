class AlbumsController < ApplicationController

  # =begin resource
  # description: Represents an user in the system.
  # =end

  respond_to :json

  # =begin action
  # method: GET
  # action: index
  # requires_authentication: no
  # response_format: json
  # description: Return all users of the system.
  # http_responses:
  #   - 200
  #   - 401
  #   - 403
  # =end
  def index
  end

  # =begin action
  # method: GET
  # action: show
  # requires_authentication: no
  # response_format: json
  # description: Return an user.
  # http_responses:
  #   - 200
  #   - 401
  #   - 403
  # =end
  def show
  end

  # =begin action
  # method: POST
  # action: create
  # requires_authentication: yes
  # response_format: json
  # description: Create new user.
  # params:
  #   - name: Name
  #     type: string
  #     required: true
  #
  #   - name: email
  #     type: string
  #     required: true
  #     description: user email
  #
  #   - name: password
  #     type: string
  #     required: true
  # http_responses:
  #   - 201
  #   - 401
  #   - 422
  # =end
  def create
  end

end
