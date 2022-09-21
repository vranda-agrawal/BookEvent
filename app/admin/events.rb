ActiveAdmin.register Event do
  permit_params :event_name, :description, :event_date, :event_time, :price, :admin_user_id

  form do |f|
    f.inputs do
      f.input :event_name
      f.input :description
      f.input :event_date
      f.input :event_time
      f.input :price
      f.input :admin_user_id, :input_html => { :value => f.current_admin_user.id }, as: :hidden
    end
    f.actions
  end
  
end
