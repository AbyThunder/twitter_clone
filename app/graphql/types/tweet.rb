module Types
  class Tweet < GraphQL::Schema::Object
    field :id, ID, null: false
    field :content, String, null: false
    field :user_id, Integer, null: false
    field :created_at, Integer, null: false

    def created_at
      object.created_at.to_i
    end

  end
end
