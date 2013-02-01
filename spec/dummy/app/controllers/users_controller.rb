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
  #
  # http_responses:
  #   - 200
  #   - 401
  #   - 403
  #
  # params:
  #   - name: page
  #     description: number of page in pagination
  #     type: optional
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
  # response_format: json
  # description: Return an user.
  #
  # params:
  #   - name: id
  #     required: true
  #     description: user id
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
  # response_format: json
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
  #       adfdasf adsf adf
  #
  #         lkjkljklj
  #
  #   - name: job
  #     type: string
  #     required: false
  #     include: job1, job2, job3
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
