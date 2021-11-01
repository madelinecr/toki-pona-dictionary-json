#!/usr/bin/env ruby

dict_file = File.open("./tokipona-formatted.txt")
dict_file_contents = dict_file.read.split("\n")

dictionary = {}

word = nil

dict_file_contents.each do |line|
    if line =~ /^\w+/
        word = line
    elsif line =~ /^\s+/
        definition = line.strip
        if dictionary[word] == nil
            dictionary[word] = []
        end

        dictionary[word].append(definition)
    else
        puts "ERROR READING DICTIONARY FILE"
        exit
    end
end

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

puts "DICTIONARY:"

dictionary.each do |k,v|
    puts "#{k}: #{v}"
end

puts "PARTS OF SPEECH:"

pos_dictionary.each do |k,v|
    puts "#{k}: #{v}"
end