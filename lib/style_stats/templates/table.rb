class StyleStats::Template
  class Table
    include CommandLineReporter

    def initialize(hash)
      @hash = hash
    end

    def run
      table(width: :auto, border: true) do
        @hash.each do |key, value|
          if value.is_a?(Array)
            value.each_with_index do |item, index|
              row(separate: index == value.count - 1) do
                column(index.zero? ? key : '', color: :red)
                column(item)
              end
            end
          else
            row do
              column(key, color: :red)
              column(value)
            end
          end
        end
      end
    end
  end
end

module CommandLineReporter
  class Table
    def output
      return if self.rows.size == 0
      auto_adjust_widths if self.width == :auto

      puts separator('first') if self.border
      self.rows.each_with_index do |row, index|
        row.output
        puts separator('middle') if self.border && (index != self.rows.size - 1) && row.separate
      end
      puts separator('last') if self.border
    end
  end

  class Row
    attr_accessor :separate

    def initialize(options = {})
      self.validate_options(options, *VALID_OPTIONS.push(:separate))

      self.columns = []
      self.border = false
      self.header = options[:header] || false
      self.color = options[:color]
      self.bold = options[:bold] || false
      self.encoding = options[:encoding] || :unicode
      self.separate = options[:separate].nil? ? true : options[:separate]
    end
  end
end
