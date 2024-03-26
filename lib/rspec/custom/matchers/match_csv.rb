# frozen_string_literal: true

module MatchCsvMatcher
  class MatchCsvMatcher
    def initialize(expected_path, csvopts: {headers: true},
                   blankmode: :permissive)
      @expected_path = expected_path
      @csvopts = csvopts
      @blankmode = blankmode
      @expected = CSV.read(expected_path, **csvopts)
    end

    def matches?(result_path)
      @result_path = result_path
      @result = CSV.read(result_path, **csvopts)
      @header_diff = get_header_diff
      @row_diff = get_row_diff
      @value_diff = get_value_diff

      header_diff.empty? && row_diff.empty? && value_diff.empty?
    end

    def failure_message
      msgs = [
        "Expected: #{expected_path}",
        "Result: #{result_path}",
        header_mismatch_message,
        row_ct_mismatch_message,
        value_mismatch_message
      ].compact
      msgs.empty? ? "" : msgs.join("\n")
    end

    def failure_message_when_negated
      "Files are identical."
    end

    private

    attr_reader :result_path, :expected_path, :csvopts, :blankmode,
      :expected, :result, :header_diff, :row_diff, :value_diff

    def get_header_diff
      diff = {}
      reshdr = result.headers
      exphdr = expected.headers
      return diff if reshdr == exphdr

      missing = exphdr - reshdr
      diff[:missing] = missing unless missing.empty?

      extra = reshdr - exphdr
      diff[:extra] = extra unless extra.empty?

      diff
    end

    def get_row_diff
      esize = expected.size
      rsize = result.size
      return {} if esize == rsize

      {expected: esize, result: rsize}
    end

    def get_value_diff
      diffhash = {}
      result.each_with_index do |row, idx|
        exprow = expected[idx]
        next unless exprow

        diff = debug_job_row(exprow, row)
        next if diff.empty?

        diffhash[idx] = diff
      end
      diffhash
    end

    def debug_job_row(exprow, resrow)
      diff = {}
      exprow.headers.each do |hdr|
        e_val = exprow[hdr]
        r_val = resrow[hdr]
        next if e_val == r_val
        if blankmode == :permissive
          next if ( e_val.nil? && r_val.empty? ) ||
            ( e_val.empty? && r_val.nil? )
        end

        diffresult = {expected: e_val, result: r_val}
        diffresult.transform_values! do |val|
          if val.nil?
            "(nil value)"
          elsif val == ""
            "(empty string)"
          else
            val
          end
        end

        diff[hdr] = diffresult
      end
      diff
    end

    def header_mismatch_message
      return if header_diff.empty?

      msgs = [
        header_message(:missing),
        header_message(:extra)
      ].compact

      msgs.empty? ? nil : msgs.join("\n")
    end

    def row_ct_mismatch_message
      return if row_diff.empty?

      msgs = [
        "ROW COUNT MISMATCH:",
        "Expected: #{row_diff[:expected]}",
        "Got: #{row_diff[:result]}"
      ]
      msgs.join("\n")
    end

    def header_message(type)
      headers = header_diff[type]
      return unless headers

      [
        "#{type} headers:".upcase,
        headers.join(", ")
      ].join("\n")
    end

    def value_mismatch_message
      return if value_diff.empty?

      puts "Values are wrapped in -><- to make leading/trailing spacing "\
        "visible"
      value_diff.map{ |row, diff| row_mismatch_message(row, diff) }
        .join("\n")
    end

    def row_mismatch_message(row, diff)
      msg = ["ROW #{row}"]
      diff.each do |hdr, vals|
        msg << "  #{hdr}"
        msg << "    expected: ->#{vals[:expected]}<-"
        msg << "         got: ->#{vals[:result]}<-"
      end
      msg.join("\n")
    end
  end

  def match_csv(...)
    MatchCsvMatcher.new(...)
  end
end

RSpec.configure do |config|
  config.include MatchCsvMatcher
end
