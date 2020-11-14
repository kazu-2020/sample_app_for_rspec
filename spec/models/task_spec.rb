require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:task) { build(:task) }
    let(:another_task) { build(:task) }

    it 'is valid with all attributes' do
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end

    it 'is invalid without title' do
      task.title = ''
      expect(task).to be_invalid
      expect(task.errors[:title]).to eq ["can't be blank"]
    end

    it 'is invalid without status' do
      task.status = ''
      expect(task).to be_invalid
      expect(task.errors[:status]).to eq ["can't be blank"]
    end

    it 'is invalid with a duplicate title' do
      task.save
      another_task = task.dup
      expect(another_task).to be_invalid
      expect(another_task.errors[:title]).to eq ["has already been taken"]
    end

    it 'is valid with a another title' do
      task.save
      expect(another_task).to be_valid
      expect(another_task.errors).to be_empty
    end
  end
end
