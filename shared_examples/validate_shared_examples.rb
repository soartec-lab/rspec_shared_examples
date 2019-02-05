# Using
#
# let(:object) { User.new }
# it_behaves_like 'presence constraint', attributes: %i(name email passwoord)
shared_examples_for 'presence constraint' do |opts|
  opts[:attributes].each do |attribute|
    context "when #{attribute} is nil" do
      before do
        object.send "#{attribute}=", nil
        object.valid?
      end
      it { expect(object.errors[attribute]).to be_present }
    end
  end
end

# Using
#
# let(:object) { User.new }
# 
# confirm only numericality
# it_behaves_like 'number constraint', attributes: %i(telephone_number code_number)
#
# Also check min and max
# it_behaves_like 'number constraint', attributes: %i(telephone_number code_number), constraint: { max: 99, min: 0 }
shared_examples_for 'number constraint' do |opts|
  opts[:attributes].each do |attribute|
    context "when #{attribute} is not a number" do
      before do
        object.send "#{attribute}=", 'string'
        object.valid?
      end
      it { expect(object.errors[attribute]).to be_present }
    end
    context "when #{attribute} is a number" do
      before do
        object.send "#{attribute}=", 1
        object.valid?
      end
      it { expect(object.errors[attribute]).not_to be_present }
    end

    if max = opts.dig(:constraint, :max)
      context "when #{attribute} is greater than #{max}" do
        before do
          object.send "#{attribute}=", (max + 1)
          object.valid?
        end
        it { expect(object.errors[attribute]).to be_present }
      end

      context "when #{attribute} is equal to #{max}" do
        before do
          object.send "#{attribute}=", max
          object.valid?
        end
        it { expect(object.errors[attribute]).not_to be_present }
      end
    end

    if min = opts.dig(:constraint, :min)
      context "when #{attribute} is less than #{min}" do
        before do
          object.send "#{attribute}=", (min - 1)
          object.valid?
        end
        it { expect(object.errors[attribute]).to be_present }
      end

      context "when #{attribute} is equal to #{min}" do
        before do
          object.send "#{attribute}=", min
          object.valid?
        end
        it { expect(object.errors[attribute]).not_to be_present }
      end
    end
  end
end

# Using
#
# let(:object) { User.new }
# it_behaves_like 'time constraint', attributes: %i(delivery_at order_at)
shared_examples_for 'time constraint' do |opts|
  opts[:attributes].each do |attribute|
    context "when #{attribute} is not a time" do
      before do
        object.send "#{attribute}=", 'string'
        object.valid?
      end
      it { expect(object.errors[attribute]).to be_present }
    end
    context "when #{attribute} is a time" do
      before do
        object.send "#{attribute}=", Time.now
        object.valid?
      end
      it { expect(object.errors[attribute]).not_to be_present }
    end
  end
end

# Using
#
# let(:object) { User.new }
# it_behaves_like 'boolean constraint', attributes: %i(delivery_complete order_complete)
shared_examples_for 'boolean constraint' do |opts|
  opts[:attributes].each do |attribute|
    context "when #{attribute} is not a boolean value" do
      before do
        object.send "#{attribute}=", 'string'
        object.valid?
      end
      it { expect(object.errors[attribute]).not_to be_present }
      it { expect(object.send attribute).to be false }
    end
    [true, false].each do |bool|
      context "when #{attribute} is #{bool}" do
        before do
          object.send "#{attribute}=", bool
          object.valid?
        end
        it { expect(object.errors[attribute]).not_to be_present }
        it { expect(object.send attribute).to be bool }
      end
    end
  end
end

# Using
#
# let(:object) { User.new }
# 
# confirm only length
# it_behaves_like 'length constraint', attributes: %i(name)
#
# Also check min and max
# it_behaves_like 'length constraint', attributes: %i(name), constraint: { max: 20, min: 1 }

shared_examples_for 'length constraint' do |opts|
  opts[:attributes].each do |attribute|
    if max = opts.dig(:constraint, :max)
      context "when #{attribute} is longer than #{max}" do
        before do
          object.send "#{attribute}=", 'あ' * (max + 1)
          object.valid?
        end
        it { expect(object.errors[attribute]).to be_present }
      end
    end

    if min = opts.dig(:constraint, :min)
      context "when #{attribute} is shorter than #{min}" do
        before do
          object.send "#{attribute}=", 'あ' * (min - 1)
          object.valid?
        end
        it { expect(object.errors[attribute]).to be_present }
      end
    end
  end
end

# Using
#
# let(:object) { User.new }
# it_behaves_like 'allow blank but nil deny', attributes: %i(commnet)
shared_examples_for 'allow blank but nil deny' do |opts|
  opts[:attributes].each do |attribute|
    context "when #{attribute} is empty string" do
      before do
        object.send "#{attribute}=", ''
        object.valid?
      end
      it { expect(object.errors[attribute]).not_to be_present }
    end
    context "when #{attribute} is missing" do
      before do
        object.send "#{attribute}=", nil
        object.valid?
      end
      it { expect(object.errors[attribute]).to be_present }
    end
  end
end