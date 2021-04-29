class Posts < ActiveRecord::Migration[6.1]
  def change
	create_table:posts do |t|
		t.text:name
		t.text:topic
		t.text:content
		t.timestamps
	end
  end
end
