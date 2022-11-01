# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :index, :show, to: :display
    alias_action :edit,:update,:destroy, to: :change

    if user.present?
      if user.has_role? :admin
        can :display, Event
        can :change, Event, user_id: user.id
      else
        can :read, Event
        can :enrol, Event
        can :register, Event
      end
    else
      can :display, Event
      can :read, Event
    end
  end
  
end
