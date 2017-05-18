module Events
  module CheckAuthorized
    extend ActiveSupport::Concern

    included do
      before_action :current_user_belongs_to_organization

      def event_organization
        @event = Event.find(params[:event_id])
        @event.organization
      end

      def current_user_belongs_to_organization
        unless event_organization == current_user.organization || current_user.admin?
          redirect_to root_path, notice: "Access forbidden."
        end
      end
    end
  end
end
