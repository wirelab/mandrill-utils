require 'spec_helper'

module Papio
  describe EmailSanitizer do
    describe '.sanitize' do
      it 'returns just the email if no name was given' do
        expect(EmailSanitizer.sanitize email: 'test@example.com').to eq 'test@example.com'
      end

      it 'delegates to sanitize_email if a name was given' do
        expect(EmailSanitizer).to receive(:sanitize_email).with("name", "email")
        EmailSanitizer.sanitize email: "email", name: 'name'
      end
    end

    describe '.sanitize_email' do
      it 'should use sanitize_name for the name' do
        expect(EmailSanitizer).to receive(:sanitize_name).with("bob")
        EmailSanitizer.sanitize_email 'bob', 'test@example.com'
      end

      it 'returns a proper name and email combination' do
        expect(EmailSanitizer.sanitize_email('bob', 'bob_3@example.com')).to eq "bob <bob_3@example.com>"
      end
    end

    describe '.sanitize_name' do
      describe 'names' do
        it 'should change "Manon Rijsbergen, van" into "Manon Rijsbergen"' do
          expect(EmailSanitizer.sanitize_name("Manon Rijsbergen, van")).to eq "Manon Rijsbergen"
        end
        it 'should not change "Alexa Op \'t Land"' do
          expect(EmailSanitizer.sanitize_name("Alexa Op 't Land")).to eq "Alexa Op 't Land"
        end
        it 'should not change "Stichting Proud2Bme"' do
          expect(EmailSanitizer.sanitize_name("Stichting Proud2Bme")).to eq "Stichting Proud2Bme"
        end
        it 'should not change "roos-anne van dorsten"' do
          expect(EmailSanitizer.sanitize_name("roos-anne van dorsten")).to eq "roos-anne van dorsten"
        end
        it 'should not change "Helen van den Nieuwenhuijzen"' do
          expect(EmailSanitizer.sanitize_name("Helen van den Nieuwenhuijzen")).to eq "Helen van den Nieuwenhuijzen"
        end
        it 'should not change "Daniëlle Springer"' do
          expect(EmailSanitizer.sanitize_name("Daniëlle Springer")).to eq "Daniëlle Springer"
        end
        it 'should not change "Esmée Bos"' do
          expect(EmailSanitizer.sanitize_name("Esmée Bos")).to eq "Esmée Bos"
        end
        it 'should not change "Lee-Ann Tsiang"' do
          expect(EmailSanitizer.sanitize_name("Lee-Ann Tsiang")).to eq "Lee-Ann Tsiang"
        end
        it 'should not change "Noëlle As"' do
          expect(EmailSanitizer.sanitize_name("Noëlle As")).to eq "Noëlle As"
        end
      end

      describe 'strip "(),:;<>@[\\]' do
        it 'should strip "," and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word, Another word")).to eq "A word"
        end

        it 'should strip ":" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word: Another word")).to eq "A word"
        end

        it 'should strip "<" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word< Another word")).to eq "A word"
        end

        it 'should strip ">" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word> Another word")).to eq "A word"
        end

        it 'should strip "(" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word( Another word")).to eq "A word"
        end

        it 'should strip ")" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word) Another word")).to eq "A word"
        end

        it 'should strip "@" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word@ Another word")).to eq "A word"
        end

        it 'should strip "\\" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word\\ Another word")).to eq "A word"
        end

        it 'should strip "[" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word[ Another word")).to eq "A word"
        end

        it 'should strip "]" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word] Another word")).to eq "A word"
        end

        it 'should strip ";" and everything thereafter' do
          expect(EmailSanitizer.sanitize_name("A word; Another word")).to eq "A word"
        end
      end

      it 'should strip !-\'#$%&+/^? at the beginning of the line, but not in the middle' do
        specials = '!-\'#$%&+/^?'
        expect(EmailSanitizer.sanitize_name("#{specials}A word#{specials} Another word")).to eq "A word#{specials} Another word"
      end
    end
  end
end
