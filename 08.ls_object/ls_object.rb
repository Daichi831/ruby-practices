#! /usr/bin/env ruby

require 'optparse'
require 'etc'

class LsCommands
  def indicate
    define_options
    # オプションの条件分岐
    no_option
    a_option if @options[:a]
    r_option if @options[:r]
    if @options[:l]
      l_option
    else
      output
    end
  end

  private

  def define_options
    OptionParser.new do |opt|
      @options = {}
      opt.on('-a') { |n| @options[:a] = n }
      opt.on('-r') { |n| @options[:r] = n }
      opt.on('-l') { |n| @options[:l] = n }
      opt.parse(ARGV)
    end
  end

  def no_option
    @files = Dir.glob('*').sort
  end

  def a_option
    @files = Dir.glob('*', File::FNM_DOTMATCH).sort
  end

  def r_option
    @files = @files.reverse
  end

  def output
    files_array = @files.map { |x| x.to_s.ljust(20) }.each_slice(6).to_a
    files_array[0].zip(*files_array[1..-1]).each { |x| puts x.join(' ') }
  end

  def file_type
    case @data[0][0..2]
    when %w[1 0 0]
      @data[0][0..2] = '-'
    when [' ', '4', '0']
      @data[0][0..2] = 'd'
    end
  end

  def permission(data)
    table = {
      '7' => 'rwx',
      '6' => 'rw-',
      '5' => 'r-x',
      '4' => 'r--',
      '3' => '-wx',
      '2' => '-w-',
      '1' => '--x',
      '0' => '---'
    }
    permission = ''
    data.each do |c|
      permission += table[c]
    end
    permission
  end

  def l_option_detail_output
    file_type_atribute = file_type
    file_type_atribute << permission(@data[0][1..3])
    @data[0] = file_type_atribute
    puts @data.join(' ')
  end

  def total
    count = 0
    @files.each do |file|
      stat = File::Stat.new(file)
      count += stat.blocks
    end
    puts "total #{count}"
  end

  def l_option_detail
    @files.each do |file|
      stat = File::Stat.new(file)

      @data = [
        stat.mode.to_s(8).rjust(6).chars,
        stat.nlink.to_s.rjust(2),
        Etc.getpwuid(File.stat(file).uid).name,
        Etc.getgrgid(File.stat(file).gid).name,
        stat.size.to_s.rjust(5),
        stat.ctime.strftime('%m %e %k:%M').gsub(/^0/, ''),
        file
      ]
      l_option_detail_output
    end
  end

  def l_option
    total
    l_option_detail
  end
end

lscommand = LsCommands.new
lscommand.indicate
