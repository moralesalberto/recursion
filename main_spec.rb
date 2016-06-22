require_relative 'main'



describe 'get' do

  it 'should find all children via all children enumerator method' do
    folder = Folder.get('a')
    all = []
    folder.all_child_folders.each do |child|
      all << child
    end
    #expect(all.size).to eq(8)
    expect(folder.all_child_folders.map(&:id).sort).to eq(%w(b c d e f g h i))
  end

  it 'should be fine with no children, (not blow up)' do
    folder = Folder.get('i')
    all = []
    folder.all_child_folders.each do |child|
      all << child
    end
    expect(all.size).to eq(0)
  end
end

