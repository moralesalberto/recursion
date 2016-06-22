require 'ostruct'

# class to simulate our folder
class Folder < OpenStruct

  # recursive call, class method
  def self.all_children(folder, accummulator=[])
    return accummulator if folder.children.size == 0
    folder.children.each do |child_id|
      child = Folder.get(child_id)
      accummulator << child
      self.all_children(child, accummulator)
    end
    accummulator
  end

  # recursive call instance method
  def all_children(accummulator=[])
    return accummulator if children.size == 0
    children.each do |child_id|
      child = Folder.get(child_id)
      accummulator << child
      child.all_children(accummulator)
    end
    accummulator
  end

  ########## amorales preferred methods ######
  def all_child_folders
    AllChildFolders.new(self)
  end

  def all_items
    AllItems.new(self)
  end
  ############################################
end

# the class to simulate an item
class Item < OpenStruct
  def self.get(id)
    Folder.get(id)
  end
end

# the enumerator for child folders
class AllChildFolders
  include Enumerable

  attr_reader :source

  def initialize(source)
    @source = source
  end

  def each(&block)
    source.children.each do |child_id|
      child = Folder.get(child_id)
      yield child
      child.all_child_folders.each(&block)
    end
  end
end

# the enumerator for items
class AllItems
  include Enumerable

  attr_reader :source

  def initialize(source)
    @source = source
  end

  def each(&block)
    # iterate over the items in the folder
    source.items.each do |item_id|
      item = Item.get(item_id)
      yield item
    end
    # iterate over the other folders
    # and iterate over the items for those folders
    source.all_child_folders.each do |folder|
      folder.items.each do |item_id|
        item = Item.get(item_id)
        yield item
      end
    end
  end
end
