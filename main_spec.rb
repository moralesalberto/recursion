require_relative 'main'

# reopen class to simulate db objects
class Folder < OpenStruct
  # the container for tests
  def self.db
    @db ||= [
      Folder.new({id: 'a', children: %w(b c d e), items: []}),
      Folder.new({id: 'b', children: %w(f g h), items: []}),
      Folder.new({id: 'c', children: [], items: %w(j)}),
      Folder.new({id: 'd', children: [], items: []}),
      Folder.new({id: 'e', children: [], items: []}),
      Folder.new({id: 'f', children: [], items: []}),
      Folder.new({id: 'g', children: [], items: []}),
      Folder.new({id: 'h', children: %w(i), items: %w(k l)}),
      Folder.new({id: 'i', children: [], items: []}),
      Item.new({id: 'j'}),
      Item.new({id: 'k'}),
      Item.new({id: 'l'}),
    ]
  end

  # simulate the finding of a record
  def self.get(id)
    db.find { |folder| folder.id == id }
  end
end


describe 'get' do
  let(:folder) { Folder.get('a') }

  it 'should find a folder by id' do
    expect(Folder.get('a')).not_to be_nil
    expect(Folder.get('a').id).to eq('a')
  end

  it 'should find all children via class method' do
    expect(Folder.all_children(folder).size).to eq(8)
    expect(Folder.all_children(folder).map(&:id).sort).to eq(%w(b c d e f g h i))
  end

  it 'should find all children via instance method' do
    expect(folder.all_children.size).to eq(8)
    expect(folder.all_children.map(&:id).sort).to eq(%w(b c d e f g h i))
  end

  it 'should find all children via all_child_folders.each method' do
    all = []
    folder.all_child_folders.each do |child|
      all << child
    end
    expect(all.size).to eq(8)
  end

  it 'should create a map if that is what folks want' do
    array = folder.all_child_folders.map(&:id).sort
    expect(array).to eq(%w(b c d e f g h i))
  end


  it 'should be fine with no children, (not blow up)' do
    folder = Folder.get('i')
    all = []
    folder.all_child_folders.each do |child|
      all << child
    end
    expect(all.size).to eq(0)
  end

  it 'should find all the items for the folder' do
    expect(folder.all_items.map(&:id).size).to eq(3)
    expect(folder.all_items.map(&:id).sort).to eq(%w(j k l))
  end
end

