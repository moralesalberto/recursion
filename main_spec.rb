require_relative 'main'

# reopen class to simulate db objects
class Folder < OpenStruct
  # the container for tests
  def self.db
    @db ||= [
      Folder.new({id: 'a', children: %w(b c d e)}),
      Folder.new({id: 'b', children: %w(f g h)}),
      Folder.new({id: 'c', children: []}),
      Folder.new({id: 'd', children: []}),
      Folder.new({id: 'e', children: []}),
      Folder.new({id: 'f', children: []}),
      Folder.new({id: 'g', children: []}),
      Folder.new({id: 'h', children: %w(i)}),
      Folder.new({id: 'i', children: []}),
    ]
  end

  # simulate the finding of a record
  def self.get(id)
    db.find { |folder| folder.id == id }
  end
end

describe 'get' do
  it 'should find a folder by id' do
    expect(Folder.get('a')).not_to be_nil
    expect(Folder.get('a').id).to eq('a')
  end

  it 'should find all children via class method' do
    folder = Folder.get('a')
    expect(Folder.all_children(folder).size).to eq(8)
    expect(Folder.all_children(folder).map(&:id).sort).to eq(%w(b c d e f g h i))
  end

  it 'should find all children via instance method' do
    folder = Folder.get('a')
    expect(folder.all_children.size).to eq(8)
    expect(folder.all_children.map(&:id).sort).to eq(%w(b c d e f g h i))
  end

  it 'should find all children via each method' do
    folder = Folder.get('a')
    all = []
    folder.each_child do |child|
      all << child
    end
    expect(all.size).to eq(8)
    expect(folder.all_children.map(&:id).sort).to eq(%w(b c d e f g h i))
  end
end

