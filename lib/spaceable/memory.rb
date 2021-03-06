module Spaceable
  class Memory < ::ActiveRecord::Base

    has_many :memory_ratings, :dependent => :destroy 
    
    belongs_to :component, :polymorphic => :true
    belongs_to :learner,   :polymorphic => :true

    before_create lambda { self.due = Time.now }

    default_scope :order => 'due'
    scope :due_before, lambda { |time| where("due <= ?", time) }
    scope :latest_studied, :order => 'last_viewed DESC'

    def due?
      return self.due <= Time.now.utc
    end
    
    def viewed?
      return !last_viewed.nil?
    end

    def view(quality)

      if (quality > 5 || quality < 0)
        return
      end

      self.views += 1
      self.last_viewed = Time.now

      if quality < 3 
        self.streak = 0
      else
        self.streak += 1
      end

      new_ease = ease - 0.8 + 0.28*quality - 0.02*quality**2  
      if new_ease >= 1.3
        self.ease = new_ease 
      else
        self.ease = 1.3
      end

      if streak == 1
        self.interval = 1.0
      elsif streak == 2
        self.interval = 6.0
      elsif streak == 0
        self.interval = 0.0065
      else
        self.interval = interval*ease
      end

      self.due = Time.now + (interval * 24 * 60 * 60).round

      self.save()

      memory_rating = Spaceable::MemoryRating.create(:quality => quality,
                                                     :streak => streak, 
                                                     :interval => interval,
                                                     :ease => ease)
      self.memory_ratings << memory_rating
      memory_rating.save
      return true
    end

    def skip!
      self.views += 1
      self.last_viewed = Time.now
      self.due = Time.now + 1.day
      self.save
    end

    def reset
      self.views = 0
      self.streak = 0
      self.interval = 1.0
      self.ease = 2.5
      self.last_viewed = nil
      self.due = Time.now
      self.save
    end

    def remove!
      self.due = DateTime.now + 1000.years
      self.save
    end

    def removed?
      due >= (DateTime.now + 900.years)
    end

    def unlock!
      self.views += 1
      self.last_viewed = Time.now
      self.save
    end
      
  end
end
