# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    if user.super_admin?
      can :manage, :all
    elsif user.admin?
      # can :read, Post, user_id: user.id
      # can :update, Post, user_id: user.id
      can %i[read update], Post, user_id: user.id
    end
  end
end
