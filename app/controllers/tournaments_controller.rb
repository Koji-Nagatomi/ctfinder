class TournamentsController < ApplicationController

  before_action :logged_in_user, only: [:join]

  def index
    @tournaments = Tournament.all
    # TODO: only future tournament
    if current_user
      participant_tournament_ids = current_user.participants.map { |h| h[:tournament_id] }
      @tournaments.map { |t| t[:participant] = true if participant_tournament_ids.include?(t.id) }
    end
  end

  def join
    @tournament = Tournament.find(params[:tournament_id])
    if !@tournament.nil? && \
      current_user.participants.build(tournament: @tournament, name: current_user.name).save
      if Action.find(user: current_user).exists?
	  Action.find(user: current_user).destroy
      end
      participant = @tournament.participants.find(user: current_user)
      Action.create(participant: participant, post: nil, user: current_user)

      flash[:debug] = "success participant."
      render :index
    else
      flash[:danger] = "参加に失敗しました"
    end
  end
  
  def show
    @tournament = Tournament.find(params[:id])
    redirect_to root_url if @tournament.nil? #, :alert 'この大会は存在しません'
    @participants = @tournament.participants
    if current_user && Participant.exists?(user: current_user)
      @participant = @participants.find(user: current_user)
      @post = @participant.post.build(post_params)
    end
    @posts = @tournament.post
  end

end
