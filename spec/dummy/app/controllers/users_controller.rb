class AlbumsController < ApplicationController

  # =begin resource
  # description: Represents an user in the system.
  # =end

  respond_to :json

  # =begin action
  # method: GET
  # action: index
  # requires_authentication: no
  # response_formats: json
  # description: Return all users of the system.
  #
  # http_responses:
  #   - 200
  #   - 401
  #   - 403
  #
  # params:
  #   - name: page
  #     description: number of page in pagination
  #     required: false
  #     type: Integer
  #   - name: limit
  #     description: number of elements by page in pagination
  #   - name: name
  #     description: name filter
  #
  # =end
  def index
  end

  # =begin action
  # method: GET
  # action: show
  # requires_authentication: no
  # response_formats: json
  # description: Return an user.
  #
  # params:
  #   - name: id
  #     required: true
  #     description: user id
  #     type: String
  #
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
  # response_formats: json
  # description: Create new user.
  #
  # params:
  #   - name: name
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
  #     description: >
  #       must be 8 caracters
  #       and be safe
  #
  #   - name: job
  #     type: string
  #     required: false
  #     inclusion: job1, job2, job3
  #
  # errors:
  #   - object: password
  #     message: too_short
  #     description: Password should has at least 4 characters.
  #
  # http_responses:
  #   - 201
  #   - 401
  #   - 422
  #
  # =end
  def create
  end

end
