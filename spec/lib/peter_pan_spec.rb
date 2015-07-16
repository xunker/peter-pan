require 'spec_helper'

describe PeterPan do
  describe '#write' do
    let(:letter_x) { 0 }
    let(:letter_y) { 1 }
    it 'writes all characters in the string to the buffer' do
      chars = 'ABC'
      chars.split('').each do |char|
        expected_character = subject.send(:font_character, char)
        expect(subject).to receive(:plot_sprite).with(expected_character, letter_x, letter_y)
        subject.write(letter_x, letter_y, char)
      end
    end
    context 'font does not have a character' do
      let(:char) { 'あ' }
      it 'prints ? instead' do
        ques_character = subject.send(:font_character, '?')
        expect(subject).to receive(:plot_sprite).with(ques_character, letter_x, letter_y)
        subject.write(letter_x, letter_y, char)
      end
    end
  end
end