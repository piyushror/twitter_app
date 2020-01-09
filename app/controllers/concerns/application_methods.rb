module ApplicationMethods
  extend ActiveSupport::Concern

  PER_PAGE_COUNT = 10

  included do
    before_action :authenticate_user
    around_action :handle_exceptions
  end

  private

  # Catch exception and return JSON-formatted error
  def handle_exceptions
    begin
      yield
    rescue ActiveRecord::RecordNotFound => e
      @status = 404
    rescue ActiveRecord::RecordInvalid => e
      render_unprocessable_entity_response(e.record) && return
    rescue ArgumentError => e
      @status = 400
    rescue StandardError => e
      @status = 500
    end
    detail = {detail: e.try(:message)}
    detail.merge!(trace: e.try(:backtrace)) if Rails.env.development?
    json_response({ success: false, message: e.class.to_s, errors: [detail] }, @status) unless e.class == NilClass
  end

  def render_unprocessable_entity_response(resource)
    json_response({
      success: false,
      message: 'Validation failed',
      errors: ValidationErrorsSerializer.new(resource).serialize
    }, 422)
  end

  def render_unprocessable_entity(message)
    json_response({
      success: false,
      message: message
    }, 422) and return true
  end

  def render_success_response(resources = {}, message = "", status = 200, meta = {})
    json_response({
      success: true,
      message: message,
      data: resources,
      meta: meta
    }, status)
  end

  def json_response(options = {}, status = 500)
    render json: JsonResponse.new(options), status: status
  end

  def render_unauthorized_response
    json_response({
      success: false,
      message: 'You are not authorized.'
    }, 401) and return
  end

  def array_serializer
    ActiveModel::Serializer::CollectionSerializer
  end

  def single_serializer
    ActiveModelSerializers::SerializableResource
  end

  def authenticate_user!(options = {})
    render_unauthorized_response unless signed_in?
  end

  def current_user
    @current_user ||= super
  end

  def signed_in?
    @current_user.present?
  end

  def authenticate_user
    if request.headers['Authorization'].present?
      authenticate_or_request_with_http_token do |token|
        begin
          jwt_payload = JWT.decode(token, Rails.application.secrets.secret_key_base).first
          render_unauthorized_response if jwt_payload['id'].blank?
          @current_user = User.find(jwt_payload['id'])
        rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError
          render_unauthorized_response
        end
      end
    else
      render_unauthorized_response
    end
  end

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end
end
