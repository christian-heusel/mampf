class Clicker < ApplicationRecord
  belongs_to :editor, class_name: 'User'
  belongs_to :question, optional: true

  before_create :set_basics

  validates :title, uniqueness: { scope: [:editor_id] }
  validates :title, presence: true

  has_many :votes, dependent: :destroy

  def user_link
    clicker_url(self, host: 'localhost').gsub('clickers','c')
  end

  def editor_link
    clicker_url(self,
                host: 'localhost',
                params: { code: code }).gsub('clickers','c')
  end

  def closed?
    !open?
  end

  def open!
    update(open: true, instance: SecureRandom.uuid)
  end

  def close!
    update(open: false)
  end

  def reset!
    close!
    votes.delete_all
  end

  private

  def set_basics
    self.code = SecureRandom.uuid
    self.alternatives = 3
  end
end
