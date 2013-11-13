#
# Cookbook Name:: attribute-validator
# Recipe:: converge-time-check
#
# Copyright (C) 2013 Clinton Wolfe
# 

include_recipe 'attribute-validator::install'

ruby_block 'convergence time attribute validation' do
  block do
    violas = Chef::Attribute::Validator.new(node).validate_all
    unless violas.empty?
      message  = "The node attributes for this chef run failed validation!\n"
      message += "A total of #{violas.size} violation(s) were encountered.\n"

      Chef::Log.warn(message)
      violas.each do |violation|
        snippet = violation.rule_name + ' at ' + violation.path + ': ' + violation.message
        message += snippet + "\n"
        if node['attribute-validator']['fail-action'] == 'warn'
          Chef::Log.warn 'Violation: ' + snippet
        end
      end

      if node['attribute-validator']['fail-action'] == 'error'
        fail message
      end
    end
  end
end
