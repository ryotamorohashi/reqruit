class User < ApplicationRecord
  validates :user_id, presence: true, length: { in: 6..30 }
  validates :password, presence: true, length: { in: 8..20 }, format: { with: /\A[¥x20-¥x7F]+\z/, message: '半角英数字記号（空白と制御コードを除くASCII文字）のみ使えます' }
  validates :nickname, presence: true, length: { maximum: 30 }
  validates :comment, presence: true, length: { maximum: 100 }
end
