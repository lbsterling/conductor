class InitialMigration < ActiveRecord::Migration
  def self.up
    create_table :open_id_authentication_associations do |t|
      t.integer :issued, :lifetime
      t.string :handle, :assoc_type
      t.binary :server_url, :secret
    end

    create_table :open_id_authentication_nonces do |t|
      t.integer :timestamp, :null => false
      t.string :server_url, :null => true
      t.string :salt, :null => false
    end

    create_table :roles do |t|
      t.string :name, :default => "", :null => false
      t.timestamps
    end

    admin_role = Role.create! :name => 'Administrator'

    create_table :sessions do |t|
      t.string :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    create_table :user_roles do |t|
      t.integer :user_id
      t.integer :role_id
      t.timestamps
    end

    add_index :user_roles, :user_id
    add_index :user_roles, :role_id

    create_table :users do |t|
      t.string :display_name, :null => false
      t.string :state, :default => "unregistered", :null => false
      t.string :email, :default => "", :null => false

      t.string :crypted_password, :default => nil, :null => true
      t.string :password_salt, :default => nil, :null => true

      t.string :openid_identifier

      t.string :perishable_token, :default => "", :null => false
      t.string :remember_token, :null => false
      t.integer :login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at

      t.timestamps
    end
    
    # make sure the column information is up to date and that authlogic has the current state
    User.reset_column_information
    User.act_as_authentic
    
    admin_user = User.create :display_name => 'Administrator', :email => APP_CONFIG[:admin_email], :password => APP_CONFIG[:admin_password], :password_confirmation => APP_CONFIG[:admin_password]
    
    admin_user.update_attribute :state, 'active'
    admin_user.roles << admin_role

    add_index :users, :openid_identifier
    add_index :users, :remember_token
    add_index :users, :last_request_at
  end

  def self.down
    drop_table :users

    drop_table :user_roles

    drop_table :sessions

    drop_table :roles

    drop_table :open_id_authentication_nonces

    drop_table :open_id_authentication_associations
  end
end
