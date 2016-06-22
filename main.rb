require 'ostruct'

# simulate db objects
class DB
  # the container for tests
  def self.bucket
    @db ||= [
      Folder.new({id: 'a', children: %w(b c d e)}),
      Folder.new({id: 'b', children: %w(f g h), items: %w(m n)}),
      Folder.new({id: 'c', children: [], items: %w(j k l)}),
      Folder.new({id: 'd', children: []}),
      Folder.new({id: 'e', children: []}),
      Folder.new({id: 'f', children: []}),
      Folder.new({id: 'g', children: []}),
      Folder.new({id: 'h', children: %w(i)}),
      Folder.new({id: 'i', children: []}),
      Item.new({id: 'j'}),
      Item.new({id: 'k'}),
      Item.new({id: 'l'}),
      Item.new({id: 'm'}),
      Item.new({id: 'n'})
    ]
  end
end

# class to simulate our folder
class Folder < OpenStruct

  def all_child_folders
    AllChildFolders.new(self)
  end

  def all_items
    AllItems.new(self)
  end

  def self.get(id)
    DB.bucket.find { |f| f.id == id }
  end
end

# simulate the item class
class Item < OpenStruct
  def self.get(id)
    DB.bucket.find { |f| f.id == id }
  end
end

# the base class for the walker
class Walker
  attr_reader :source # folder or item instance
  include Enumerable

  def initialize(source)
    @source = source
  end

  # the iterator
  def each(&block)
    children.each do |child_id|
      child = klass.get(child_id)
      yield child
      child.each(&block)
    end
  end
end

class AllChildFolders < Walker
  def klass
    Folder
  end

  def children
    source.children
  end
end

class AllItems < Walker
  def klass
    Item
  end

  def children
    source.items
  end
end
