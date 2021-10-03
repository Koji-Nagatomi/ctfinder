# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'securerandom'

# users
70.times do |n|
    User.create!(
        name: SecureRandom.alphanumeric(rand(10..20)), 
        email: SecureRandom.alphanumeric(rand(10..20)) + "@gmail.com", 
        password: "tintin#{n}", 
        web: [5, [n/2, 1].max].min,
        crypt: [5, [n/2, 1].max].min,
        reversing: [5, [n/2, 1].max].min,
        pwn: [5, [n/2, 1].max].min,
        misc: [5, [10, 1].max].min,
        self_introduction: "俺がナンバーワンだ！"
    )
end

# tournaments
10.times do |n|
    Tournament.create!(
        name: SecureRandom.alphanumeric(rand(10..20)), 
        date: Time.parse('2020-01-01 12:00:00')
    )
end

# participants
10.times do |n|
    Participant.create!(
        user: User.all.sample(1)[0], 
        tournament: Tournament.all.sample(1)[0]
    )
end

# posts
10.times do |n|
    participant = Participant.all.sample(1)[0]
    Post.create!(
        participant: participant, 
        tournament: participant.tournament,
        content: SecureRandom.alphanumeric(rand(1..140))
    )
end

# likes
10.times do |n|
    liker = User.all.sample(1)[0]
    liked = User.all.sample(1)[0]
    while liker == liked do
        liked = User.all.sample(1)[0]
    end
    Like.create!(
        liker: liker,
        liked: liked
    )
end

# matching
10.times do |n|
    user1 = User.all.sample(1)[0]
    user2 = User.all.sample(1)[0]
    while user1 == user2 do
        user2 = User.all.sample(1)[0]
    end
    Matching.create!(
        user1: user1,
        user2: user2
    )
end

# direct_message
10.times do |n|
    matching = Matching.all.sample(1)[0]
    DirectMessage.create!(
        matching: matching,
        sender: [matching.user1, matching.user2].sample(1)[0],
        content: SecureRandom.alphanumeric(rand(1..140))
    )
end