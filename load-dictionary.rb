#!/usr/bin/env ruby

require 'json'
require 'pp'

# PARTS OF SPEECH
parts_of_speech_file = File.open("./tokipona-partsofspeech.txt")
parts_of_speech_contents = parts_of_speech_file.read.split("\n")

pos_dictionary = {}

part = nil

parts_of_speech_contents.each do |line|
    if line =~ /^\w+/
        part = line
    elsif line =~ /^\s+/
        definition = line.strip
        pos_dictionary[part] = definition
    else
        puts "ERROR READING PARTS OF SPEECH FILE"
        exit
    end
end


# DEFINITIONS
dict_file = File.open("./tokipona-formatted.txt")
dict_file_contents = dict_file.read.split("\n")

definitions_dict = {}

word = nil

dict_file_contents.each do |line|
    if line =~ /^\w+/
        word = line
    elsif line =~ /^\s+/
        definition = line.strip
        if definitions_dict[word] == nil
            definitions_dict[word] = []
        end

        definitions_dict[word].append(definition)
    else
        puts "ERROR READING DICTIONARY FILE"
        exit
    end
end


# BUILDING ENTIRE DICTIONARY INTO JSON-ABLE STRUCTURE
dictionary = []

definitions_dict.each do |word,definitions|
    definitions_array = []
    definitions.each do |definition|
        value_matched = false
        pos_dictionary_checked = false
        pos_dictionary.each do |pos,pos_definition|
            if definition.start_with?(pos) and value_matched == false
                trimmed_definition = definition.sub(/^#{pos}\s/, '')
                definitions_array.append({ pos: pos.to_sym, definition: trimmed_definition })
                #definitions_array.append({ pos.to_sym => trimmed_definition })
                value_matched = true
            end
        end
        pos_dictionary_checked = true
        if value_matched == false and pos_dictionary_checked == true
            definitions_array.append({ pos: :extra, definition: definition })
        end
    end
    dictionary.append({ word: word.to_sym, definitions: definitions_array })
end

dict_output = File.open("./toki-dictionary.json", "wb")
dict_output.write(JSON.pretty_generate(dictionary))

pos_output = File.open("./toki-partsofspeech.json", "wb")
pos_output.write(JSON.pretty_generate(pos_dictionary))