module MigrationBuilder
  module Subprompts
    class AddOrRemoveColumn
      attr_reader :column_name, :lines

      def initialize(prompt, allow_remove: true)
        @prompt = prompt
        @lines = []
        @allow_remove = allow_remove
      end

      def run
        add_another = true

        while add_another
          add_or_remove = @allow_remove ? @prompt.enum_select('Add or remove?', ['Add', 'Remove']) : 'Add'
          @column_name = @prompt.ask('Column name:')
          @lines << line(@column_name, add_or_remove)
          add_another = @prompt.yes?(add_another_question)
        end
      end

      private

      def add_another_question
        @allow_remove ? 'Add/remove another?' : 'Add another?'
      end

      def line(column_name, add_or_remove)
        if add_or_remove == 'Add'
          column_type = @prompt.enum_select("Column type for #{column_name}:", COLUMN_TYPES)
          "t.#{column_type} :#{column_name}"
        else
          "t.remove :#{column_name}"
        end
      end
    end
  end
end
