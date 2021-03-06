# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'Directory - Allow' do
  let(:acl_manifest) do
    <<-MANIFEST
      file { '#{target_parent}':
        ensure => directory
      }

      file { '#{target}':
        ensure  => directory,
        require => File['#{target_parent}']
      }

      user { '#{user_id}':
        ensure     => present,
        groups     => 'Users',
        managehome => true,
        password   => "L0v3Pupp3t!"
      }

      acl { '#{target}':
        permissions  => [
          { identity => '#{user_id}', perm_type => 'allow', rights => ['#{rights}'] },
        ],
      }
    MANIFEST
  end

  let(:verify_acl_command) { "icacls #{target}" }

  context '"execute" Rights for Identity on Directory' do
    let(:rights) { 'execute' }
    let(:target) { "c:/temp/allow_#{rights}_rights_dir" }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(Rc,S,X,RA\)} }

    include_examples 'execute manifest'
  end

  context '"modify" Rights for Identity on Directory' do
    let(:rights) { 'modify' }
    let(:target) { "c:/temp/allow_#{rights}_rights_dir" }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(M\)} }

    include_examples 'execute manifest'
  end

  context '"read, execute" Rights for Identity on Directory' do
    let(:rights) { "read', 'execute" }
    let(:target) { 'c:/temp/allow_re_rights_dir' }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(RX\)} }

    include_examples 'execute manifest'
  end

  context '"read" Rights for Identity on Directory' do
    let(:rights) { 'read' }
    let(:target) { "c:/temp/allow_#{rights}_rights_dir" }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(R\)} }

    include_examples 'execute manifest'
  end

  context '"write, execute" Rights for Identity on Directory' do
    let(:rights) { "write','execute" }
    let(:target) { 'c:/temp/allow_we_rights_dir' }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(W,Rc,X,RA\)} }

    include_examples 'execute manifest'
  end

  context '"write, read" Rights for Identity on Directory' do
    let(:rights) { "write','read" }
    let(:target) { 'c:/temp/allow_wr_rights_dir' }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(R,W\)} }

    include_examples 'execute manifest'
  end

  context '"write, read, execute" Rights for Identity on Directory' do
    let(:rights) { "write','read','execute" }
    let(:target) { 'c:/temp/allow_wre_rights_dir' }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(RX,W\)} }

    include_examples 'execute manifest'
  end

  context '"write" Rights for Identity on Directory' do
    let(:rights) { 'write' }
    let(:target) { "c:/temp/allow_#{rights}_rights_dir" }
    let(:acl_regex) { %r{.*\\bob:\(OI\)\(CI\)\(W,Rc\)} }

    include_examples 'execute manifest'
  end
end
