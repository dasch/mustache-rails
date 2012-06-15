class Nested < ActionView::Mustache
  def categories
    topic_1 = {
      "title" => "Topic 1"
    }

    category_a = {
      "title" => "Category A",
      "topics" => [topic_1]
    }

    category_b = {
      "title" => "Category B",
      "topics" => []
    }

    [category_a, category_b]
  end
end
