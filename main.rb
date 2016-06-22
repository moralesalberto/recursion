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
  def all_children(starting_folder=self, accummulator=[])
    return accummulator if children.size == 0
    children.each do |child_id|
      child = Folder.get(child_id)
      accummulator << child
      child.all_children(starting_folder, accummulator)
    end
    accummulator
  end
end
