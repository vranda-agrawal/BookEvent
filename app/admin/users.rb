ActiveAdmin.register User do

  index do
    selectable_column
    id_column
    column :email
    column :fullname
    column :phone_number
    column :age
    actions
  end

  permit_params :email, :encrypted_password, :fullname, :phone_number, :age, :reset_password_token, :reset_password_sent_at, :remember_created_at, :role_ids, :password, :password_confirmation
  
  form do |f|
    f.inputs do
      f.input :fullname
      f.input :email
      f.input :phone_number
      f.input :age
      f.input :role_ids, :input_html => { :value => 2 }, as: :hidden
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
