require "rails_helper"

RSpec.describe User, type: :model do
  it "is a valid user" do
    user = build(:user)
    expect(user).to be_valid
  end
  it "is invalid without email" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  it "is invalid without password" do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end
  it "stores downcase email" do
    user = create(:user, email: "UPPER@email.COM")
    expect(user.email).to eq("upper@email.com")
  end
  pending "devise modules"
end
