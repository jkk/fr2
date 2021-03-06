module Content::EntryImporter::BasicData
  extend Content::EntryImporter::Utils
  provides :volume, :title, :toc_subject, :toc_doc, :citation, :regulation_id_numbers, :significant, :start_page, :end_page, :length, :type, :genre, :part_name, :granule_class, :abstract, :dates, :action, :contact, :docket_id
  
  def volume
    mods_file.volume
  end
  
  def title
    simple_node_value('title')
  end
  
  def toc_subject
    simple_node_value('tocSubject1')
  end
  
  def toc_doc
    val = simple_node_value('tocDoc')
    
    if val.present?
      val = val.sub(/, $/, '').strip
    end
    
    val
  end
  
  def citation
    simple_node_value('identifier[type="preferred citation"]')
  end
  
  def regulation_id_numbers
    regulation_id_numbers = simple_node_values('identifier[type="regulation ID number"]')
    regulation_id_numbers.map{|rin| rin.sub(/RIN /, '')}
  end
  
  def significant
    entry.current_regulatory_plans.any?(&:significant?)
  end
  
  def start_page
    simple_node_value('extent[unit="pages"] start')
  end
  
  def end_page
    simple_node_value('extent[unit="pages"] end')
  end
  
  def length
    simple_node_value('length')
  end
  
  def type
    simple_node_value('type')
  end
  
  def genre
    simple_node_value('genre')
  end
  
  def part_name
    simple_node_value('partName')
  end
  
  def granule_class
    simple_node_value('granuleClass')
  end
  
  def abstract
    simple_node_value('abstract')
  end
  
  def dates
    simple_node_value('dates')
  end
  
  def action
    simple_node_value('action')
  end
  
  def contact
    simple_node_value('contact')
  end
  
  def docket_id
    simple_node_value('identifier[type="department code"]')
  end
  
  private
  
  def simple_node_value(css_selector)
    mods_node.css(css_selector).first.try(:content)
  end
  
  def simple_node_values(css_selector)
    mods_node.css(css_selector).map(&:content)
  end
end
