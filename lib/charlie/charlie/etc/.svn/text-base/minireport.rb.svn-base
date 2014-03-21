
# This was handled by ruport earlier, but that turned out to be overkill and give a huge amount of dependencies.

class Array
  def to_table(colnames=nil)
    Table.new(self,colnames)
  end
end

class Table < Array
  def initialize(tbl,colnames=nil)
    @colnames = colnames || tbl[0].map_with_index{|e,i|i+1}
    super(tbl.map{|row|row.dup.map(&:to_s)})
  end
 
  def to_html
    "<table>\n" +
      "<tr>" + @colnames.map{|t| "<th>#{t}</th>" }.join + "</tr>\n" +
	map{|r| "<tr>\n" + r.map{|e| "\t<td>#{e.gsub('<','&lt;').gsub("\r\n",'<br>')}</td>\n"  }.join + "</tr>\n" }.join +
    "</table>"
  end

  def to_csv
    map{|r| r.map(&:inspect).join(', ') }.join("\n")
  end

  def to_s(csz=nil)
    console_size = 80
    rsz = at(0).size
    csz ||= [(console_size-rsz) / rsz]*rsz
    pad = ' ' * csz.max
    sep = csz.map{|x|'-'*x}.join('+')
    ([sep,@colnames.zip_with(csz){|str,sz| (str+pad)[0...sz] }.join('|'),sep]+
    map{|r| r.zip_with(csz){|str,sz| (str.gsub("\r\n","\\")+pad)[0...sz] }.join('|') } << sep).join("\n")
  end

end

if __FILE__ == $0
 t = [['aaaaaaa"a<>aaaaaaa',23],['bb',421]].to_table(['xx','yy'])
 puts t.to_s
 puts
 puts t.to_html
 puts
 puts t.to_csv
end