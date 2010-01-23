Dir.chdir(File.dirname(__FILE__)) { (s = lambda { |f| File.exist?(f) ? require(f) : Dir.chdir("..") { s.call(f) } }).call("spec/spec_helper.rb") }

describe Puppet::Type.type(:logical_volume) do
    before do
        @type = Puppet::Type.type(:logical_volume)
        @valid_params = {
            :name => 'mylv',
            :volume_group => 'myvg',
            :size => '1g',
            :ensure => :present
        }
    end

    it "should exist" do
        @type.should_not be_nil
    end

    describe "when specifying the 'name' parameter" do
        it "should exist" do
            @type.attrclass(:name).should_not be_nil
        end

        it "should not allow qualified files" do
            lambda { @type.new :name => "my/lv" }.should raise_error(Puppet::Error)
        end
        
        it "should support unqualified names" do
            @type.new(:name => "mylv")[:name].should == "mylv"
        end
    end

    describe "when specifying the 'volume_group' parameter" do
        it "should exist" do
            @type.attrclass(:volume_group).should_not be_nil
        end
    end

    
    describe "when specifying the 'ensure' parameter" do
        it "should exist" do
            @type.attrclass(:ensure).should_not be_nil
        end

        it "should support 'present' as a value" do
            with(valid_params)[:ensure].should == :present
        end

        it "should support 'absent' as a value" do
            with(valid_params.merge(:ensure => :absent))[:ensure].should == :absent
        end

        it "should not support other values" do
            specifying(valid_params.merge(:ensure => :foobar)).should raise_error(Puppet::Error)
        end
    end

end