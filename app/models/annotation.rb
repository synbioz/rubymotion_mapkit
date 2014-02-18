class Annotation
  def initWithCoordinate(coordinate, title: title, subtitle: subtitle)
    @coordinate = coordinate
    @title      = title
    @subtitle   = subtitle

    self
  end

  def coordinate
    @coordinate
  end

  def title
    @title
  end

  def subtitle
    @subtitle
  end
end
