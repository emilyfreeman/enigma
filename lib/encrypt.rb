require_relative '../lib/enigma'
require_relative '../lib/key_generator'
require_relative '../lib/offset_generator'


class Encrypt

  attr_accessor :key_array

  CHAR_MAP = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", " ", ".", ","]

  def initialize
  end

  def encrypt_runner(input, output)
    secret_message = Enigma.new
    secret_message_string = secret_message.read_file(input)
    temp_message_array = create_message_array(secret_message_string)

    rotations = process_rotation_arrays
    encrypted_message = encrypt_message(temp_message_array, rotations)
    final_output = Enigma.new
    final_output.write_file(encrypted_message, output)
  end

  def create_message_array(secret_message_string)
    secret_message_string.chars
  end

  def process_rotation_arrays
    key_array = create_secret_key
    offset_array = create_date_offset
    add_secret_key_and_offset(key_array, offset_array)
  end

  def create_secret_key
    secret_key = Key_Generator.new
    secret_key.create_key
  end

  def create_date_offset
    offset = Offset_Generator.new
    offset.create_offset
  end

  def add_secret_key_and_offset(key_array, offset_array)
    rotations = []
    counter = 0
    key_array.each do |num|
      rotations << num + offset_array[counter]
      counter += 1
    end
    rotations
  end

  def encrypt_message(array, rotations)
    counter = 0
    encrypted = []
    array.each_with_index do |letter, index|
      if !CHAR_MAP.include? letter
        encrypted << letter
      else
        location = CHAR_MAP.index(letter)
        encrypted << CHAR_MAP[(location + rotations[counter]) % CHAR_MAP.length]
        counter = (counter + 1) % rotations.length
      end
    end
    encrypted.join
  end

  def output_date
    date = Offset_Generator.new
    date_output = date.find_date
  end



end

input_filename = ARGV[0]
output_filename = ARGV[1]

message = Encrypt.new
message.encrypt_runner(input_filename, output_filename)

puts "Wahoo! Done!"
"Created #{input_filename} with the key #{key_array.join} and date #{date_output}"
