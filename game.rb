#!/bin/env ruby
# encoding: utf-8
require 'rubygems'
require 'chance'
require 'pp'
require 'optparse'

require_relative 'deck'
require_relative 'card'
require_relative 'dog'

puts Dog.all
puts

Dog.all.each do |class_of_dog|
  dog = class_of_dog.new
  deck = Deck.new
  hand = 5.times.collect { deck.cards.random_pop}
  puts dog.name + " will now read their hand."
  dog.read hand
  puts "--------"
  puts "The true hand:"
  puts hand
  puts
  puts
end