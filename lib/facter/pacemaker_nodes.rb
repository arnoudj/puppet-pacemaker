# == Fact: pacemaker_nodes
#
require 'facter'
require 'rexml/document'

Facter.add(:pacemaker_nodes) do
  setcode do
    xml = Facter::Util::Resolution.exec("crm node status")
    doc = REXML::Document.new(xml)
    nodes = []
    doc.elements.each('nodes/node') do |node|
      nodes << node.attributes['uname']
    end
    nodes.join ','
  end
end
