def create_index(clazz)
  if clazz.respond_to? :tire
    clazz.tire.index.delete
    clazz.tire.create_elasticsearch_index
  end
end

def refresh_index(clazz)
  if clazz.respond_to? :tire
    clazz.tire.index.refresh
  end
end
