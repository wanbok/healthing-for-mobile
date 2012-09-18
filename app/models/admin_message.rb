class AdminMessage < ActiveRecord::Base
  attr_accessible :message, :version, :download_url
end
