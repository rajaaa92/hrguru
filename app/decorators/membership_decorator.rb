class MembershipDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :role

  def user_name
    user.present? ? user.name : '---'
  end

  def duration_in_words
    if terminated?
      h.distance_of_time_in_words(from, to)
    elsif started?
      'current'
    else
      'not started'
    end
  end

  def date_range
    range = "#{h.icon('calendar')} #{from.to_date}"
    range << " ... #{to.to_date}" if to
    h.raw range
  end

  def icon_edit(options = {})
    h.link_to "##{options[:id]}", data: {toggle: 'modal'}, class: 'edit' do
      h.fa_icon('pencil-square-o')
    end
  end
end
