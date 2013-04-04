module FA::Utils::Structurizer
  extend self

  class SimpleRelation
    attr_accessor :from, :to, :how
    alias :relation_type :how
    alias :from_model    :from
    alias :to_model      :to

    def initialize(opts)
      @from = opts[:from]
      @to   = opts[:to]
      @how  = opts[:how]
    end

    def to_s
      "#{from} #{how} #{to}"
    end

  end

  def models
    @@models ||= ActiveRecord.send :subclasses
  end

  def model_names
    models.map(&:name)
  end

  def relations
    @@relations ||= \
      models.map { |model|
        model.reflect_on_all_associations.map do |assoc|
          SimpleRelation.new(
            from: model,
            to:   assoc.class_name.constantize,
            how:  assoc.macros
          )
        end
      }.flatten
  end

  private

end
