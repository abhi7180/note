class my_data
{
  int? id;
  String? title,subtitle;


  my_data(this.id, this.title, this.subtitle);

  @override
  String toString() {
    return 'my_data{id: $id, title: $title, subtitle: $subtitle}';
  }

  static my_data fromMap(Map m)
  {
    return my_data(m['id'], m['title'], m['subtitle']);
  }
}