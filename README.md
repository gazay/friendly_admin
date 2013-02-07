friendly_admin
==============

A set of templates and DSLs to quickly create RESTful admin interfaces.

Design principles
-----------------

* Make the common things we do easy, yet ensure uncommon things are still possible.
* Make all the things the most common way of (the Rails way).
* We should be framework & library agnostic.
* Many independent modules are better than all-in-one.
* Mixing of the MVC levels is always bad idea.

Installation
--------------

Because of friendly_admin design principles it does not contain any strong
dependencies. So, you could start from default set of gems and replace them
by your favorites.

   ```
   gem 'friendly_admin'
   gem 'inherited_resources'        # Really needed
   gem 'bootstrap-sass', '> 2.2'    # Bootstrap >= 2.2
   gem 'bootstrap-kaminari-views'   # Kaminari styling for bootstrap (your app may have own)
   gem 'simple_form'                # Or formtastic
   gem 'kaminari'                   # Or will_paginate
   gem 'has_scope'                  # To use scopes
   ```

Generate the common template (TODO: GENERATOR):

   ```
   rails g friendly_admin:install
   ```

Quick example
-------------

Overriding, overriding, overriding...
-------------------------------------

Authors
-------

@gazay
@gzigzigzeo


Temporary sample trash
----------------------

Controller

class Admin::UsersController < Admin::BaseController
  actions :all
  paginated
  batch_action :destroy

  has_order_scope default: [:email, :asc]
end

Base controller

class Admin::BaseController < ApplicationController
  include FriendlyAdmin::Dsl

  # GET INTO INHERITED_RESOURCES ASSOCIATION CHAIN
  # TODO: Conditionally: if end_of_association_chain defined
  def end_of_association_chain_with_friendly
    scope = end_of_association_chain_without_friendly
    scope = apply_paginate_scope(scope)
    scope
  end

  # PAGINATED MODULE
  alias_method_chain :end_of_association_chain, :friendly

  cattr_accessor :paginated

  # TODO: Comment about why to use block (to change per_page dynamically)
  def self.paginated(*args, &block)
    args = args || true
    self.paginated = block_given? ? yield : args
  end

  def apply_paginate_scope(scope)
    # TODO: raise if no kaminari
    # TODO: will_paginate
    # TODO: yielded block
    scope = scope.page(params[:page]) if self.paginated
    scope
  end

  # BATCH ACTION
  cattr_accessor :batch_actions, instance_writer: false

  def define_batch_action(action, &proc)
    batch_actions[action] = proc
  end


  # Mixed with shared actions
  # TODO: Change batch_action method name
  def self.batch_action(*args)
    options = args.extract_options!

    action_names = args

    define_method :batch_action do
      batch_action = params[:batch_action].to_sym
      action = self.batch_actions.key(batch_action)

      raise ArgumentError, 'Unknown action' if action.blank?

      end_of_association_chain.where(id: params[:id]).each do |record|
        action.call(record)
      end
    end
  end

  # ORDER SCOPE
  # ?order[]=name&order[]=asc
  # + friendly_sort_mark
  # depends on has_scope
  # TODO: Sanitize sql
  # TODO: Limit fields
  # TODO: Rename scope
  # TODO: Limit directions
  # TODO: Get it work when > 1 field (order[]=name&order[]=asc&order[]=email&order[]=desc)
  # TODO: How to pass default value to friendly sort mark
  def self.has_order_scope(*args)
    options = args.extract_options!
    options.merge!(type: :array)

    has_scope(:order, options) do |controller, scope, value|
      method, direction = value
      scope.order(%{"#{resource_class.table_name}"."#{method}" #{direction}})
    end
  end
end

_table.html.haml

= friendly_table do
  %thead
    %th
    %th
      = friendly_column_name(:id)
      = friendly_sort_mark(:id)
    %th
      = friendly_column_name(:email)
      = friendly_sort_mark(:email)
    %th= friendly_column_name(:first_name)
    %th= friendly_column_name(:last_name)
    %th
  %tbody
    - collection.each do |row|
      %tr
        %td= friendly_row_checkbox(row)
        %td= row[:id]
        %td= row[:email]
        %td= row[:first_name]
        %td= row[:last_name]
        %td
          .pull-right
            = friendly_resource_action(:edit, row)
