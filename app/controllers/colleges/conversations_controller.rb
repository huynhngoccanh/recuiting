class Colleges::ConversationsController < ApplicationController
  include CollegeScoped

  layout "profile"

  def edit_index
    load_conversations
  end

  def show
    load_conversation
  end

  def new
    find_or_initialize_conversation
    if @conversation.persisted?
      redirect_to conversation_path(@conversation)
    end
  end

  def create
    build_conversation
    @conversation.messages.first.user = current_user
    if @conversation.save
      redirect_to conversation_path(@conversation)
    else
      render "new"
    end
  end

  def destroy
    load_conversation
  end

  private

    def find_or_initialize_conversation
      @athlete = Athlete.find(params[:athlete_id])
      @conversation = Conversation.where(athlete: @athlete, organization: @college).first_or_initialize
    end

    def load_conversation
      @conversation = conversation_scope.find(params[:id])
    end

    def load_conversations
      @conversations = conversation_scope.to_a
    end

    def build_conversation
      @conversation ||= conversation_scope.build conversation_params
    end

    def conversation_scope
      @college.conversations
    end

    def conversation_params
      conversation_params = params[:conversation]
      conversation_params ? conversation_params.permit(:athlete_id, messages_attributes: [:body]) : {}
    end
end

