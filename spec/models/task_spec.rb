require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    let(:task) { FactoryBot.create(:task) }
    let(:another_task) { FactoryBot.create(:task) }

    it 'is valid with all attributes' do
      expect(task).to be_valid
    end

    it 'is invalid without title' do
      task.title = ''
      expect(task).to be_invalid
    end

    it 'is invalid without status' do
      task.status = ''
      expect(task).to be_invalid
    end

    it 'is invalid with a duplicate title' do
      another_task = task.dup
      expect(another_task).to be_invalid
    end

    it 'is valid with a another title' do
      expect(another_task).to be_valid
    end
  end
end
